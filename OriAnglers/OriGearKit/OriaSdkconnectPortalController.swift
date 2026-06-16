import UIKit
import WebKit
import StoreKit

final class OriaSdkconnectPortalController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private enum OriaSdkconnectMessage: CaseIterable {
        case oriaInappitemStartRecharge
        case oriaReceiptvalidSuccess
        case oriaTravelrouteRedirect
        case oriaUserauthReturn
        case oriaSdkconnectCloseSignal
        case oriaSessiontimeoutLogout

        var name: String {
            switch self {
            case .oriaInappitemStartRecharge:
                return ~"cTalTWaNYySBagrnLbgIIlwOiVQnQyggDOoOrjxifOajt"
            case .oriaReceiptvalidSuccess:
                return ~"mHouJadnkwxHaSvtEGeCmrmKOhZrSUiMMauX"
            case .oriaTravelrouteRedirect:
                return ~"cQZoiFmtapNjoynsUNtydweAavlttHeCGrngOCOrYVicIaWD"
            case .oriaUserauthReturn:
                return ~"sqruRXbnYspTtMRaQvnUscfpeddabnnrYgCalqPiWCnpvgqUOOJrQIiByaZi"
            case .oriaSdkconnectCloseSignal:
                return ~"bGKlftoRScLnkiVasnnCrgiVlRtiRQnOygPGOCJrMWiWeaxI"
            case .oriaSessiontimeoutLogout:
                return ~"sqSldQamecAakMLaTWntxgRblXciYinmrgSYOqcroQiGNauG"
            }
        }

        init?(name: String) {
            guard let value = Self.allCases.first(where: { $0.name == name }) else { return nil }
            self = value
        }
    }

    private let url: URL
    private let oriaDarkmodeBackdrop = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4500)
    private lazy var oriaSdkconnectView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        OriaSdkconnectMessage.allCases.forEach {
            configuration.userContentController.add(self, name: $0.name)
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
    private let oriaActivityscoreSpinner = UIActivityIndicatorView(style: .large)
    private let oriaAlertfishStatusLabel = UILabel()
    private var oriaInappitemProductRequest: SKProductsRequest?
    private var oriaSdkconnectHandlersCleared = false
    private var oriaReceiptvalidToastShown = false

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
        print("[OriChat][WebPortal] oriaTravelrouteFinalURL=\(Self.oriaPrivacyzoneMask(url.absoluteString))")
        SKPaymentQueue.default().add(self)
    }

    required init?(coder: NSCoder) {
        fatalError(~"ipknztiKctuB(eScWlocBdaSeJJrqy:Zb)fc jahrJaSsshN lTnSGoDnthL EpbkOemkeeoncO HniQOmRnpfblfbezXmbHexnnwLtflemzdfI")
    }

    deinit {
        oriaSdkconnectClearHandlers()
        oriaInappitemProductRequest?.cancel()
        SKPaymentQueue.default().remove(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = oriaDarkmodeBackdrop
        view.addSubview(oriaSdkconnectView)
        oriaSdkconnectView.pinEdges(to: view)
        view.addSubview(oriaActivityscoreSpinner)
        oriaActivityscoreSpinner.translatesAutoresizingMaskIntoConstraints = false
        oriaAlertfishStatusLabel.textColor = .white
        oriaAlertfishStatusLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        oriaAlertfishStatusLabel.textAlignment = .center
        oriaAlertfishStatusLabel.numberOfLines = 0
        oriaAlertfishStatusLabel.isHidden = true
        view.addSubview(oriaAlertfishStatusLabel)
        oriaAlertfishStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            oriaActivityscoreSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            oriaActivityscoreSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -12),
            oriaAlertfishStatusLabel.topAnchor.constraint(equalTo: oriaActivityscoreSpinner.bottomAnchor, constant: 14),
            oriaAlertfishStatusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 28),
            oriaAlertfishStatusLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -28),
            oriaAlertfishStatusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        oriaActivityscoreSpinner.startAnimating()
        oriaSdkconnectView.load(URLRequest(url: url))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            oriaSdkconnectClearHandlers()
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        oriaActivityscoreSpinner.stopAnimating()
        oriaAlertfishStatusLabel.isHidden = true
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        oriaActivityscoreSpinner.stopAnimating()
        print("[OriChat][WebPortal] load failed=\(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        oriaActivityscoreSpinner.stopAnimating()
        print("[OriChat][WebPortal] provisional load failed=\(error.localizedDescription)")
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let script = OriaSdkconnectMessage(name: message.name) else { return }
        print("[OriChat][H5Message] name=\(message.name) action=\(script)")
        switch script {
        case .oriaInappitemStartRecharge:
            oriaInappitemStartRecharge(from: message.body)
        case .oriaReceiptvalidSuccess:
            oriaInappitemSetLoading(false)
            oriaReceiptvalidShowSuccessIfNeeded()
        case .oriaTravelrouteRedirect:
            oriaTravelrouteRedirectToPage(from: message.body)
        case .oriaUserauthReturn, .oriaSessiontimeoutLogout:
            oriaSessiontimeoutReturnToEntry()
        case .oriaSdkconnectCloseSignal:
            oriaSdkconnectClosePage()
        }
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            oriaReceiptvalidFinishRecharge(message: ~"RVbeYIcpJhuhapurZAgWaezX vPiLNtcCeVKmwA UFuaKnxTakYvHXalmidylJIaAZbnnljmeYz.Ai", success: false)
            return
        }
        oriaInappitemUpdateMessage(~"ORfppteKYnlTigmnqIgcg srAFOpwkpQL TDSsTtyXoOSrMreNu HfcKIhHPeoQckIkvvotiunOtWZ.Fp.Nr.jp")
        SKPaymentQueue.default().add(SKPayment(product: product))
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        oriaReceiptvalidFinishRecharge(message: error.localizedDescription, success: false)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { transaction in
            switch transaction.transactionState {
            case .purchased:
                queue.finishTransaction(transaction)
                oriaReceiptvalidNotifySuccess()
            case .failed:
                queue.finishTransaction(transaction)
                oriaReceiptvalidFinishRecharge(message: transaction.error?.localizedDescription ?? ~"RUHeCOcbqhQXaNgrHYgZRemq QCfQBaKUiFrlegeRNdkM.gN", success: false)
            case .purchasing, .deferred:
                oriaInappitemUpdateMessage(~"ClJoAXmHHpxylSQerctkqizvntWgds NjrKjejacVdhGaatmrtQgzheIq.Dc.Cs.uq")
            case .restored:
                queue.finishTransaction(transaction)
            default:
                break
            }
        }
    }

    private func oriaInappitemStartRecharge(from body: Any) {
        guard let oriaInappitemProductId = oriaInappitemProductId(from: body), oriaInappitemProductId.isEmpty == false else {
            oriaReceiptvalidFinishRecharge(message: ~"MtAiySskosYgiYZnWDgAw DRrwdeUDcpAhCZaIVrxxgQBeTN SjpPUrUFoJydnguoHcGHtHx etiCKdyf.iU", success: false)
            return
        }
        oriaReceiptvalidToastShown = false
        oriaInappitemSetLoading(true, message: ~"PcqrPReLCpjDaDQrbOiAOnNugKf DFsFPeAEcWPuFBrRuebO qfclhhTJeDQccHkjCoAKuwYtSQ.hk.wC.yc")
        let request = SKProductsRequest(productIdentifiers: [oriaInappitemProductId])
        oriaInappitemProductRequest = request
        request.delegate = self
        request.start()
    }

    private func oriaTravelrouteRedirectToPage(from body: Any) {
        guard let url = oriaTravelrouteResolvedURL(from: body) else {
            print("[OriChat][H5Message] oriaTravelrouteRedirect invalid body=\(body)")
            return
        }
        print("[OriChat][H5Message] oriaTravelrouteRedirect oriaTravelrouteFinalURL=\(Self.oriaPrivacyzoneMask(url.absoluteString))")
        navigationController?.pushViewController(OriaSdkconnectPortalController(url: url), animated: true)
    }

    private func oriaSdkconnectClosePage() {
        if navigationController?.presentingViewController != nil && navigationController?.viewControllers.first == self {
            navigationController?.dismiss(animated: true)
        } else if presentingViewController != nil && navigationController?.viewControllers.first == self {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func oriaSessiontimeoutReturnToEntry() {
        OriaUserauthStore.oriaCloudsyncShared.oriaSessiontimeoutSignOut()
        OriBuaaAkeForNetTool.OriChatSessionToken = nil
        let entry = AuthEntryViewController(authStore: .oriaCloudsyncShared)
        if let window = view.window {
            window.rootViewController = entry
            UIView.transition(with: window, duration: 0.25, options: [.transitionCrossDissolve], animations: nil)
        } else {
            navigationController?.setViewControllers([entry], animated: true)
        }
    }

    private func oriaReceiptvalidNotifySuccess() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.oriaReceiptvalidNotifySuccess()
            }
            return
        }
        oriaReceiptvalidFinishRecharge(message: ~"RoSeqZccRhHUaMyrlAgureAV EWsgCueBcrpcniejmsbtsAXfGGuuklCg.ch", success: true)
        [~"rqHeZocsGhSlaQZrcBglyeBnSkfugTcvucCAeXIspzsAq(lF)Ba", ~"maIuoVdgqwkDazDtALemgrVxOOZrpiiKGaYB(Io)RD"].forEach { script in
            oriaSdkconnectView.evaluateJavaScript(script) { _, error in
                if let error {
                    print("[OriChat][H5Message] callback=\(script) error=\(error.localizedDescription)")
                }
            }
        }
    }

    private func oriaReceiptvalidFinishRecharge(message: String, success: Bool) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.oriaReceiptvalidFinishRecharge(message: message, success: success)
            }
            return
        }
        oriaInappitemProductRequest = nil
        oriaInappitemSetLoading(false)
        print("[OriChat][H5Message] recharge success=\(success) message=\(message)")
        success ? oriaReceiptvalidShowSuccessIfNeeded() : Toast.show(message, in: self)
    }

    private func oriaInappitemSetLoading(_ isLoading: Bool, message: String? = nil) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.oriaInappitemSetLoading(isLoading, message: message)
            }
            return
        }
        view.isUserInteractionEnabled = isLoading == false
        if let message {
            oriaAlertfishStatusLabel.text = message
        }
        oriaAlertfishStatusLabel.isHidden = isLoading == false
        isLoading ? oriaActivityscoreSpinner.startAnimating() : oriaActivityscoreSpinner.stopAnimating()
    }

    private func oriaInappitemUpdateMessage(_ message: String) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.oriaInappitemUpdateMessage(message)
            }
            return
        }
        oriaAlertfishStatusLabel.text = message
        oriaAlertfishStatusLabel.isHidden = false
        oriaActivityscoreSpinner.startAnimating()
    }

    private func oriaReceiptvalidShowSuccessIfNeeded() {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.oriaReceiptvalidShowSuccessIfNeeded()
            }
            return
        }
        guard oriaReceiptvalidToastShown == false else { return }
        oriaReceiptvalidToastShown = true
        Toast.show(~"REZedUcuwhkLabcrcXgjeeJF CxcgvoBDmdrpKilBremwtEIeaE.mK", in: self)
    }

    private func oriaInappitemProductId(from body: Any) -> String? {
        if let value = body as? String { return value.trimmingCharacters(in: .whitespacesAndNewlines) }
        if let dict = body as? [String: Any] {
            let keys = [~"poCraRoyldfeuYKcfptyxIRVdYd", ~"pJUrWooVWdQquaacPotnnIAaDTi", ~"iIgdJJ", ~"pTiajvydRIJAdpL", ~"rADeLGcXIhVdaPLruEgBOeVpIdmddQ"]
            for key in keys {
                if let value = dict[key] as? String { return value.trimmingCharacters(in: .whitespacesAndNewlines) }
                if let value = dict[key] { return String(describing: value).trimmingCharacters(in: .whitespacesAndNewlines) }
            }
        }
        return nil
    }

    private func oriaSdkconnectClearHandlers() {
        guard oriaSdkconnectHandlersCleared == false else { return }
        oriaSdkconnectHandlersCleared = true
        OriaSdkconnectMessage.allCases.forEach {
            oriaSdkconnectView.configuration.userContentController.removeScriptMessageHandler(forName: $0.name)
        }
    }

    private func oriaTravelrouteResolvedURL(from body: Any) -> URL? {
        let raw: String?
        if let value = body as? String {
            raw = value
        } else if let dict = body as? [String: Any] {
            raw = (dict[~"uBxreFlDr"] ?? dict[~"pKiaOJteghjS"] ?? dict[~"rnjoGouFftbGelC"] ?? dict[~"hobrKWengfMB"]).map { String(describing: $0) }
        } else {
            raw = nil
        }
        guard let text = raw?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty == false else { return nil }
        if let absolute = URL(string: text), absolute.scheme != nil {
            return absolute
        }
        let separator = text.contains(~"?ak") ? ~"&Uj" : ~"?zG"
        let token = OriaUserauthStore.oriaCloudsyncShared.oriaTokenvalidResolvedSessionToken
        let suffix = text.contains(~"tqxorakGaehlndL=Wt") ? ~"" : "\(separator)token=\(token)&appID=\(AppConstants.appId)"
        return URL(string: AppConstants.webBaseURL.absoluteString + text + suffix)
    }

    private static func oriaPrivacyzoneMask(_ text: String) -> String {
        guard let tokenRange = text.range(of: ~"tlioOckcAeodnCj=fK") else { return text }
        let prefix = text[..<tokenRange.upperBound]
        let suffixStart = text[tokenRange.upperBound...].firstIndex(of: Character(~"&Ir")) ?? text.endIndex
        if tokenRange.upperBound == suffixStart {
            return "\(prefix)<missing>\(text[suffixStart...])"
        }
        return "\(prefix)***\(text[suffixStart...])"
    }
}
