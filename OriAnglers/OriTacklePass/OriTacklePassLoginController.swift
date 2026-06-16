import UIKit

final class LoginViewController: UIViewController {
    private let authStore: OriaUserauthStore
    private let authManager: OriaUserauthManager
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let emailField = AuthTextField(placeholder: ~"EpznnvtGiezQrwU UkeMSmBYaFDibDlWj nQaaxduudKcrBGeRTsCrsUx", symbolName: ~"eNpnicvwyeTQliloJGpKgeBs")
    private let passwordField = AuthTextField(placeholder: ~"EqDnbXtLAeVyrtk ofpAgaXEsdFsLOwsbokXrIGdwA", symbolName: ~"lqcoqmczmkGF")
    private let signInButton = GradientButton(type: .system)
    private let createButton = UIButton(type: .system)
    private let termsButton = UIButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()

    init(authStore: OriaUserauthStore, authManager: OriaUserauthManager? = nil) {
        self.authStore = authStore
        self.authManager = authManager ?? OriaUserauthManager(oriaDatabasestoreStore: authStore)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError(~"iuDnEAiZAtOY(ZTcjBoRkdGFeEerRt:CO)lt UxhwearWsgV eKnqnoHCtmr eYbfieeOedynal NPizbmLtpwylXYeezmkveRunhqtxgeVudiI")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureKeyboardHandling()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func configureUI() {
        view.addSubview(AuthBackgroundView())
        view.subviews.first?.pinEdges(to: view)

        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view.safeAreaLayoutGuide)
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor)
        ])

        let close = UIButton(type: .system)
        close.setImage(UIImage(systemName: ~"xOwmDOaLBrNWkeo"), for: .normal)
        close.tintColor = .white
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        let titleImage = UIImageView(image: UIImage(named: AppAsset.loginFish))
        titleImage.contentMode = .scaleAspectFit
        let title = UILabel()
        title.text = ~"LOIovigEdikqnoa"
        title.textColor = .white
        title.font = .systemFont(ofSize: 32, weight: .bold)

        passwordField.isSecureTextEntry = true
        signInButton.setTitle(~"SBmishgDNneb bYiDqnLw tinQsoTHwCS", for: .normal)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        loadingLabel.text = ~"SXjilSgBynpkiuJncggLC fvieInUG.rn.EQ.jZ"
        loadingLabel.textColor = UIColor.white.withAlphaComponent(0.78)
        loadingLabel.font = .systemFont(ofSize: 13, weight: .medium)
        loadingLabel.isHidden = true
        let loadingRow = UIStackView(arrangedSubviews: [loadingIndicator, loadingLabel])
        loadingRow.axis = .horizontal
        loadingRow.alignment = .center
        loadingRow.spacing = 8
        loadingRow.isLayoutMarginsRelativeArrangement = true
        loadingRow.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)

        createButton.setTitle(~"CurRzBEPOAPBTpEEDw GUNlxEByWuD nDAOZChfCerOhdUVhNRbTmM", for: .normal)
        createButton.setTitleColor(AppConstants.accentColor, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)

        termsButton.setTitle(~"BDPysr SVcUCoprnawtFEieznmJuouijFnCCgLH sRyzIoVnueN gUaObgJRrszeIbebf bQtqroKd imoPpuArriU QsTcEeWjrzImaRsno MLaJrneFdSY ngPnfrOViyfvuaaYocNQywC MEPPUobHlaEiZucwPyYq.sF", for: .normal)
        termsButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        termsButton.titleLabel?.font = .systemFont(ofSize: 12)
        termsButton.titleLabel?.numberOfLines = 0
        termsButton.contentHorizontalAlignment = .left

        let stack = UIStackView(arrangedSubviews: [titleImage, title, emailField, passwordField, signInButton, loadingRow, createButton, termsButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 18
        contentView.addSubview(close)
        contentView.addSubview(stack)
        close.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            close.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            close.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalToConstant: 44),
            titleImage.heightAnchor.constraint(equalToConstant: 92),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 64),
            signInButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    private func configureKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let bottom = max(0, frame.height - view.safeAreaInsets.bottom) + 16
        scrollView.contentInset.bottom = bottom
        scrollView.verticalScrollIndicatorInsets.bottom = bottom
    }

    @objc private func keyboardWillHide() {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func createTapped() {
        present(SignUpViewController(authStore: authStore), animated: true)
    }

    @objc private func signInTapped() {
        setLoading(true)
        authManager.oriaUserauthSignIn(email: emailField.text ?? ~"", password: passwordField.text ?? ~"", agreed: authStore.oriaEulalegalAgreed) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.replaceRoot(with: MainTabBarController(authStore: self.authStore))
            case .failure(let error):
                self.setLoading(false)
                Toast.show(error.localizedDescription, in: self)
            }
        }
    }

    private func setLoading(_ isLoading: Bool) {
        signInButton.isEnabled = isLoading == false
        createButton.isEnabled = isLoading == false
        emailField.isEnabled = isLoading == false
        passwordField.isEnabled = isLoading == false
        loadingLabel.isHidden = isLoading == false
        isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        view.endEditing(true)
    }

    private func replaceRoot(with controller: UIViewController) {
        guard let window = view.window else { return }
        window.rootViewController = controller
        UIView.transition(with: window, duration: 0.25, options: [.transitionCrossDissolve], animations: nil)
    }
}
