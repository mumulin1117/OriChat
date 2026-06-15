import UIKit
import WebKit
import StoreKit

final class WebPortalViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private enum ScriptMessage: String, CaseIterable {
        case initiateRecharge = "clayanglingOria"
        case rechargeSuccess = "mudwaterOria"
        case pageRedirect = "compostwaterOria"
        case goToLogin = "substanceanglingOria"
        case closeH5 = "blockanglingOria"
        case logoutStatus = "slackanglingOria"
    }

    private let url: URL
    private let portalBackgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4500)
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        ScriptMessage.allCases.forEach {
            configuration.userContentController.add(self, name: $0.rawValue)
        }
        let view = WKWebView(frame: .zero, configuration: configuration)
        view.navigationDelegate = self
        view.uiDelegate = self
        view.isOpaque = false
        view.backgroundColor = .clear
        view.scrollView.backgroundColor = .clear
        view.scrollView.contentInsetAdjustmentBehavior = .never
        return view
    }()
    private let indicator = UIActivityIndicatorView(style: .large)
    private var activeProductRequest: SKProductsRequest?
    private var handlersRemoved = false

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        print("[OriChat][WebPortal] finalURL=\(Self.mask(url.absoluteString))")
        SKPaymentQueue.default().add(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeScriptHandlers()
        activeProductRequest?.cancel()
        SKPaymentQueue.default().remove(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = portalBackgroundColor
        view.addSubview(webView)
        webView.pinEdges(to: view)
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        indicator.startAnimating()
        webView.load(URLRequest(url: url))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            removeScriptHandlers()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let script = ScriptMessage(rawValue: message.name) else { return }
        print("[OriChat][H5Message] name=\(message.name) action=\(script)")
        switch script {
        case .initiateRecharge:
            initiateRecharge(from: message.body)
        case .rechargeSuccess:
            indicator.stopAnimating()
            view.isUserInteractionEnabled = true
        case .pageRedirect:
            redirect(from: message.body)
        case .goToLogin, .logoutStatus:
            logoutToEntry()
        case .closeH5:
            closeWeb()
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            finishRecharge(message: "Recharge item unavailable.", success: false)
            return
        }
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        finishRecharge(message: error.localizedDescription, success: false)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                queue.finishTransaction(transaction)
                notifyRechargeSuccess()
            case .failed:
                queue.finishTransaction(transaction)
                finishRecharge(message: transaction.error?.localizedDescription ?? "Recharge failed.", success: false)
            case .restored:
                queue.finishTransaction(transaction)
            default:
                break
            }
        }
    }

    private func initiateRecharge(from body: Any) {
        guard let productId = productId(from: body), productId.isEmpty == false else {
            finishRecharge(message: "Missing recharge product id.", success: false)
            return
        }
        view.isUserInteractionEnabled = false
        indicator.startAnimating()
        let request = SKProductsRequest(productIdentifiers: [productId])
        activeProductRequest = request
        request.delegate = self
        request.start()
    }

    private func redirect(from body: Any) {
        guard let url = resolvedURL(from: body) else {
            print("[OriChat][H5Message] pageRedirect invalid body=\(body)")
            return
        }
        print("[OriChat][H5Message] pageRedirect finalURL=\(Self.mask(url.absoluteString))")
        navigationController?.pushViewController(WebPortalViewController(url: url), animated: true)
    }

    private func closeWeb() {
        if navigationController?.presentingViewController != nil && navigationController?.viewControllers.first == self {
            navigationController?.dismiss(animated: true)
        } else if presentingViewController != nil && navigationController?.viewControllers.first == self {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func logoutToEntry() {
        AuthStore.shared.signOut()
        Network.OriChatSessionToken = nil
        let entry = AuthEntryViewController(authStore: .shared)
        if let window = view.window {
            window.rootViewController = entry
            UIView.transition(with: window, duration: 0.25, options: [.transitionCrossDissolve], animations: nil)
        } else {
            navigationController?.setViewControllers([entry], animated: true)
        }
    }

    private func notifyRechargeSuccess() {
        finishRecharge(message: "Recharge successful.", success: true)
        ["rechargeSuccess()", "mudwaterOria()"].forEach { script in
            webView.evaluateJavaScript(script) { _, error in
                if let error {
                    print("[OriChat][H5Message] callback=\(script) error=\(error.localizedDescription)")
                }
            }
        }
    }

    private func finishRecharge(message: String, success: Bool) {
        activeProductRequest = nil
        view.isUserInteractionEnabled = true
        indicator.stopAnimating()
        print("[OriChat][H5Message] recharge success=\(success) message=\(message)")
        if success == false {
            Toast.show(message, in: self)
        }
    }

    private func productId(from body: Any) -> String? {
        if let value = body as? String { return value.trimmingCharacters(in: .whitespacesAndNewlines) }
        if let dict = body as? [String: Any] {
            let keys = ["productId", "productID", "id", "payId", "rechargeId"]
            for key in keys {
                if let value = dict[key] as? String { return value.trimmingCharacters(in: .whitespacesAndNewlines) }
                if let value = dict[key] { return String(describing: value).trimmingCharacters(in: .whitespacesAndNewlines) }
            }
        }
        return nil
    }

    private func removeScriptHandlers() {
        guard handlersRemoved == false else { return }
        handlersRemoved = true
        ScriptMessage.allCases.forEach {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: $0.rawValue)
        }
    }

    private func resolvedURL(from body: Any) -> URL? {
        let raw: String?
        if let value = body as? String {
            raw = value
        } else if let dict = body as? [String: Any] {
            raw = (dict["url"] ?? dict["path"] ?? dict["route"] ?? dict["href"]).map { String(describing: $0) }
        } else {
            raw = nil
        }
        guard let text = raw?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty == false else { return nil }
        if let absolute = URL(string: text), absolute.scheme != nil {
            return absolute
        }
        let separator = text.contains("?") ? "&" : "?"
        let token = AuthStore.shared.sessionToken ?? ""
        let suffix = text.contains("token=") ? "" : "\(separator)token=\(token)&appID=\(AppConstants.appId)"
        return URL(string: AppConstants.webBaseURL.absoluteString + text + suffix)
    }

    private static func mask(_ text: String) -> String {
        guard let tokenRange = text.range(of: "token=") else { return text }
        let prefix = text[..<tokenRange.upperBound]
        let suffixStart = text[tokenRange.upperBound...].firstIndex(of: "&") ?? text.endIndex
        return "\(prefix)***\(text[suffixStart...])"
    }
}
