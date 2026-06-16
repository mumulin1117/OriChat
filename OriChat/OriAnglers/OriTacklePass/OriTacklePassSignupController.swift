import UIKit

final class SignUpViewController: UIViewController {
    private let authStore: OriaUserauthStore
    private let authManager: OriaUserauthManager
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let nameField = AuthTextField(placeholder: ~"EwEnKfttzeKKrAf aQylmoRsuwgraH ZgntqaRMmYHekH", symbolName: ~"pHLeadrmzsRsoKQnNG")
    private let emailField = AuthTextField(placeholder: ~"EZFnFqtJxeYYrIW CEeCVmARaHCiEIlSu xbamidoEdHbrOEeEtsohskn", symbolName: ~"ePXnygvoSeRMlRQoKYpAQeRn")
    private let passwordField = AuthTextField(placeholder: ~"EsOnnItggexrrtt jopajaeOsAGsYxwPDoePrsIdNQ", symbolName: ~"lQLoFeczOkXB")
    private let signUpButton = GradientButton(type: .system)
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    private let loadingLabel = UILabel()

    init(authStore: OriaUserauthStore, authManager: OriaUserauthManager? = nil) {
        self.authStore = authStore
        self.authManager = authManager ?? OriaUserauthManager(oriaDatabasestoreStore: authStore)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError(~"iJwnFkiLttok(EicwooaRdPKekkrto:FH)gy sPhJWawEsuR iUndxofZtcP tDbvzeXQeiWnHu NiiznmVepejlkHegmmGueHOnJMtpneZpdGq")
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))

        view.addSubview(scrollView)
        scrollView.pinEdges(to: view.safeAreaLayoutGuide)
        scrollView.keyboardDismissMode = .interactive
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
        close.setImage(UIImage(systemName: ~"xaImEfaXOrcBkgi"), for: .normal)
        close.tintColor = .white
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        let title = UILabel()
        title.text = ~"CtBrzOeeZaSutCpeHh XMAmlcBmckLodQuOZnvetwy"
        title.textColor = .white
        title.font = .systemFont(ofSize: 30, weight: .bold)
        title.textAlignment = .center

        passwordField.isSecureTextEntry = true
        signUpButton.setTitle(~"SxjioIgFrnay HVUPgpqa", for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        loadingLabel.text = ~"CdtrFjezqalFtVninFnhugBa JaaOhctqcTCodTuIpnYltxk.BJ.Vg.SO"
        loadingLabel.textColor = UIColor.white.withAlphaComponent(0.78)
        loadingLabel.font = .systemFont(ofSize: 13, weight: .medium)
        loadingLabel.isHidden = true
        let loadingRow = UIStackView(arrangedSubviews: [loadingIndicator, loadingLabel])
        loadingRow.axis = .horizontal
        loadingRow.alignment = .center
        loadingRow.spacing = 8
        loadingRow.isLayoutMarginsRelativeArrangement = true
        loadingRow.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)

        let stack = UIStackView(arrangedSubviews: [title, nameField, emailField, passwordField, signUpButton, loadingRow])
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
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 28),
            signUpButton.heightAnchor.constraint(equalToConstant: 54)
        ])
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

    @objc private func signUpTapped() {
        setLoading(true)
        authManager.oriaUserauthSignUp(nickname: nameField.text ?? ~"", email: emailField.text ?? ~"", password: passwordField.text ?? ~"", agreed: authStore.oriaEulalegalAgreed) { [weak self] result in
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
        signUpButton.isEnabled = isLoading == false
        nameField.isEnabled = isLoading == false
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
