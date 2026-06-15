import UIKit

final class LoginViewController: UIViewController {
    private let authStore: AuthStore
    private let authManager: AuthManager
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let emailField = AuthTextField(placeholder: "Enter email address", symbolName: "envelope")
    private let passwordField = AuthTextField(placeholder: "Enter password", symbolName: "lock")
    private let signInButton = GradientButton(type: .system)
    private let createButton = UIButton(type: .system)
    private let termsButton = UIButton(type: .system)

    init(authStore: AuthStore, authManager: AuthManager? = nil) {
        self.authStore = authStore
        self.authManager = authManager ?? AuthManager(store: authStore)
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.tintColor = .white
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        let titleImage = UIImageView(image: UIImage(named: AppAsset.loginFish))
        titleImage.contentMode = .scaleAspectFit
        let title = UILabel()
        title.text = "Login"
        title.textColor = .white
        title.font = .systemFont(ofSize: 32, weight: .bold)

        passwordField.isSecureTextEntry = true
        signInButton.setTitle("Sign in now", for: .normal)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        createButton.setTitle("CREATE NEW ACCOUNT", for: .normal)
        createButton.setTitleColor(AppConstants.accentColor, for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        createButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)

        termsButton.setTitle("By continuing you agree to our Terms and Privacy Policy.", for: .normal)
        termsButton.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        termsButton.titleLabel?.font = .systemFont(ofSize: 12)
        termsButton.titleLabel?.numberOfLines = 0
        termsButton.contentHorizontalAlignment = .left

        let stack = UIStackView(arrangedSubviews: [titleImage, title, emailField, passwordField, signInButton, createButton, termsButton])
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
        authManager.signIn(email: emailField.text ?? "", password: passwordField.text ?? "", agreed: authStore.agreedEULA) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.replaceRoot(with: MainTabBarController(authStore: self.authStore))
            case .failure(let error):
                Toast.show(error.localizedDescription, in: self)
            }
        }
    }

    private func replaceRoot(with controller: UIViewController) {
        guard let window = view.window else { return }
        window.rootViewController = controller
        UIView.transition(with: window, duration: 0.25, options: [.transitionCrossDissolve], animations: nil)
    }
}
