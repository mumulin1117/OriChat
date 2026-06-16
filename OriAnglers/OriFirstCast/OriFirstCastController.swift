import UIKit

final class LaunchViewController: UIViewController {
    private let authStore: OriaUserauthStore
    private let backgroundView = AuthBackgroundView()
    private let logoContainer = UIView()
    private let logoImageView = UIImageView(image: UIImage(named: AppAsset.brandLogo))

    init(authStore: OriaUserauthStore) {
        self.authStore = authStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.routeNext()
        }
    }

    private func configureUI() {
        view.addSubview(backgroundView)
        backgroundView.pinEdges(to: view)

        logoContainer.backgroundColor = AppConstants.darkBackground
        logoContainer.layer.cornerRadius = 21
        logoContainer.clipsToBounds = true
        view.addSubview(logoContainer)
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        logoContainer.addSubview(logoImageView)
        logoImageView.pinEdges(to: logoContainer, insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))

        NSLayoutConstraint.activate([
            logoContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -86),
            logoContainer.widthAnchor.constraint(equalToConstant: 90),
            logoContainer.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    private func routeNext() {
        let next: UIViewController = authStore.oriaTokenvalidLoggedIn ? MainTabBarController(authStore: authStore) : AuthEntryViewController(authStore: authStore)
        replaceRoot(with: next)
    }

    private func replaceRoot(with controller: UIViewController) {
        guard let window = view.window else { return }
        window.rootViewController = controller
        UIView.transition(with: window, duration: 0.25, options: [.transitionCrossDissolve], animations: nil)
    }
}
