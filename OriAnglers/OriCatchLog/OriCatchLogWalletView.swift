import UIKit

final class OriChatCatchWalletView: UIControl {
    private let gradientLayer = CAGradientLayer()
    private let iconContainer = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }

    func configure(hasWalletState: Bool) {
        titleLabel.text = "My wallet"
        subtitleLabel.text = hasWalletState ? "Ready for your next catch" : "Manage fishing rewards"
    }

    private func configureUI() {
        layer.cornerRadius = 20
        clipsToBounds = true
        gradientLayer.colors = [
            UIColor(red: 178 / 255, green: 36 / 255, blue: 255 / 255, alpha: 1).cgColor,
            UIColor(red: 249 / 255, green: 36 / 255, blue: 151 / 255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)

        iconContainer.backgroundColor = UIColor.white.withAlphaComponent(0.24)
        iconContainer.layer.cornerRadius = 16
        let icon = UIImageView(image: UIImage(named: "oriangler_profile_wallet_gem"))
        icon.contentMode = .scaleAspectFit
        iconContainer.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 42),
            icon.heightAnchor.constraint(equalToConstant: 42)
        ])

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        subtitleLabel.textColor = .white
        subtitleLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        subtitleLabel.numberOfLines = 1
        arrowButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        arrowButton.tintColor = .black
        arrowButton.backgroundColor = .white
        arrowButton.layer.cornerRadius = 14
        arrowButton.isUserInteractionEnabled = false

        let labels = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        labels.axis = .vertical
        labels.spacing = 2
        let row = UIStackView(arrangedSubviews: [iconContainer, labels, arrowButton])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 14
        row.isUserInteractionEnabled = false
        addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 66),
            iconContainer.widthAnchor.constraint(equalToConstant: 48),
            iconContainer.heightAnchor.constraint(equalToConstant: 48),
            arrowButton.widthAnchor.constraint(equalToConstant: 28),
            arrowButton.heightAnchor.constraint(equalToConstant: 28),
            row.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -9)
        ])
    }
}
