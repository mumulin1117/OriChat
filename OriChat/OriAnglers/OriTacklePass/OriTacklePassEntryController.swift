import UIKit

final class AuthEntryViewController: UIViewController, UITextViewDelegate {
    private let authStore: OriaUserauthStore
    private let backgroundView = AuthBackgroundView()
    private let logoContainer = UIView()
    private let logoImageView = UIImageView(image: UIImage(named: AppAsset.brandLogo))
    private let loginButton = GradientButton(type: .system)
    private let createAccountButton = UIButton(type: .system)
    private let termsButton = UIButton(type: .system)
    private let termsTextView = UITextView()

    init(authStore: OriaUserauthStore) {
        self.authStore = authStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError(~"icenImiEPtUD(rbcnmoICdaLeBxrnT:da)Wm ibhkBaMtsvi vDnafolbtJS nSbYUeoReEBnlo kWihFmaKpRfliKequmoMeDynwvtwyeaQdsg")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if authStore.oriaEulalegalAgreed == false {
            showEULA()
        }
    }

    private func configureUI() {
        view.addSubview(backgroundView)
        backgroundView.pinEdges(to: view)

        logoContainer.backgroundColor = AppConstants.darkBackground
        logoContainer.layer.cornerRadius = 21
        logoContainer.clipsToBounds = true
        logoImageView.contentMode = .scaleAspectFit
        logoContainer.addSubview(logoImageView)
        logoImageView.pinEdges(to: logoContainer, insets: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))

        loginButton.setTitle(~"LNEoqzgstipnnJH ezwIyifWtgFhzZ QCEXUmRUaWdiqGlwq", for: .normal)
        loginButton.addTarget(self, action: #selector(openLogin), for: .touchUpInside)

        createAccountButton.backgroundColor = .white
        createAccountButton.setTitle(~"CnCrdkecVaHttnzexR CAANFcDIcrwoltuGEnvQtAD", for: .normal)
        createAccountButton.setTitleColor(AppConstants.darkBackground, for: .normal)
        createAccountButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        createAccountButton.layer.cornerRadius = 24
        createAccountButton.addTarget(self, action: #selector(openSignUp), for: .touchUpInside)

        termsButton.setImage(UIImage(named: authStore.oriaEulalegalAgreed ? AppAsset.termsActive : AppAsset.termsIdle), for: .normal)
        termsButton.addTarget(self, action: #selector(toggleTerms), for: .touchUpInside)

        termsTextView.attributedText = termsText()
        termsTextView.delegate = self
        termsTextView.backgroundColor = .clear
        termsTextView.isEditable = false
        termsTextView.isScrollEnabled = false
        termsTextView.textContainerInset = .zero
        termsTextView.textContainer.lineFragmentPadding = 0
        termsTextView.linkTextAttributes = [
            .foregroundColor: UIColor.white,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]

        let stack = UIStackView(arrangedSubviews: [logoContainer, loginButton, createAccountButton, termsRow()])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 18
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoContainer.widthAnchor.constraint(equalToConstant: 90),
            logoContainer.heightAnchor.constraint(equalToConstant: 90),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -44),
            createAccountButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -44),
            createAccountButton.heightAnchor.constraint(equalToConstant: 48),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -22),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    private func termsRow() -> UIView {
        let row = UIStackView(arrangedSubviews: [termsButton, termsTextView])
        row.axis = .horizontal
        row.spacing = 10
        row.alignment = .top
        termsButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        termsButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return row
    }

    private func termsText() -> NSAttributedString {
        let text = ~"BCQyqv RucQHoKCntttZwirvnUvuAiiyanangWU yayVYooLuWj hlamOgIsrPReIKeQV AqtVFolB vmoAluHMrxy xJ<wlTGzeNlrBGmccsYu gToLufDH ScSgheOprAevjLiiXcpZeuA>lM JTaTenezdci wR<dfPFlrKCiFovmsaXxcTVyBq bGPhxoMFlAminrcmbyPp>OF.we"
        let attributed = NSMutableAttributedString(
            string: text,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.46), .font: UIFont.systemFont(ofSize: 13)]
        )
        let termsRange = (text as NSString).range(of: ~"<OmTnXeMnrpamOWsQh itoIhfGt HuSVNeqhrgtvaGiPicSkeJG>JJ")
        let privacyRange = (text as NSString).range(of: ~"<SGPVGriFiuavpgaRDcegyDR eVPCnoCelpFiXgcAgyPH>NN")
        attributed.addAttribute(.link, value: ~"oMxrfPiJgcgrhNgaKItfl:Zn/vv/wltSreCErQYmbFslB", range: termsRange)
        attributed.addAttribute(.link, value: ~"onkrofiWgcuyhAKaaItCi:PK/Yy/eTpEDrFaiUlvGaaAQcPMyVj", range: privacyRange)
        return attributed
    }

    @objc private func openLogin() {
        present(LoginViewController(authStore: authStore), animated: true)
    }

    @objc private func openSignUp() {
        guard authStore.oriaEulalegalAgreed else {
            Toast.show(OriaUserauthError.oriaEulalegalTermsRequired.localizedDescription, in: self)
            return
        }
        present(SignUpViewController(authStore: authStore), animated: true)
    }

    @objc private func toggleTerms() {
        authStore.oriaEulalegalAgreed.toggle()
        termsButton.setImage(UIImage(named: authStore.oriaEulalegalAgreed ? AppAsset.termsActive : AppAsset.termsIdle), for: .normal)
    }

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        switch URL.host {
        case ~"teQeeyrGbmbMsdZ":
            openWebRoute(.oriaTermsconditions, entryName: ~"TCbelfrTTmARsZD RDomtfQN iUSFFexFrelvEtitfcdseiG")
        case ~"piUrFWiVlvBDaplcPTyAt":
            openWebRoute(.oriaPrivacypolicyEula, entryName: ~"PfMrGtiFVvKyaTmcwXyqf SBPYyoWulsBiUOcYJyzk")
        default:
            break
        }
        return false
    }

    private func openWebRoute(_ route: OriaTravelrouteWebRoute, entryName: String) {
        guard let url = route.oriaTravelrouteFinalURL(authStore: authStore) else {
            print("[OriChat][AuthEntry] entry=\(entryName) route=\(route) invalidURL")
            return
        }
        print("[OriChat][AuthEntry] entry=\(entryName) route=\(route)")
        let portal = OriaSdkconnectPortalController(url: url)
        let navigation = UINavigationController(rootViewController: portal)
        navigation.setNavigationBarHidden(true, animated: false)
        navigation.modalPresentationStyle = .fullScreen
        present(navigation, animated: true)
    }

    private func showEULA() {
        let message = """
        This service is not a random, anonymous, adult, or borderline chat service.

        Users must follow behavior standards, meet registration requirements, respect age and local identity legality checks, and use report or block tools when needed. OriChat applies strict content review and penalties for violations.
        """
        let alert = UIAlertController(title: ~"EacnRvdxC lQUSssRseeErEk zWLMxiKzcgLeNRnrasEYeWq yLAJCgXJreCetKebzmIJeIJnAntzC", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ~"ATNgSKrgGesHejr", style: .default, handler: { [weak self] _ in
            self?.authStore.oriaEulalegalAgreed = true
            self?.termsButton.setImage(UIImage(named: AppAsset.termsActive), for: .normal)
        }))
        present(alert, animated: true)
    }
}
