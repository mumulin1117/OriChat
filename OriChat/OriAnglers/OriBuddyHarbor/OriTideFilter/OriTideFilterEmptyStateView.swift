import UIKit

final class OriChatBuddyEmptyStateView: UIView {
    var onCreate: (() -> Void)?
    var onReset: (() -> Void)?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let resetButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(filtered: Bool) {
        titleLabel.text = filtered ? "No trips match your filters." : "No buddy cards yet"
        subtitleLabel.text = filtered ? "Reset filters or create a new trip." : "Be the first to oriaApiintegratPost a trip near you\nand let anglers come to you."
        resetButton.isHidden = filtered == false
    }

    private func configureUI() {
        backgroundColor = .clear
        let iconWrap = UIView()
        iconWrap.backgroundColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 36 / 255, alpha: 1)
        iconWrap.layer.cornerRadius = 38
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 1)
        icon.contentMode = .scaleAspectFit
        iconWrap.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: iconWrap.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconWrap.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            iconWrap.widthAnchor.constraint(equalToConstant: 76),
            iconWrap.heightAnchor.constraint(equalToConstant: 76)
        ])

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 21, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.58)
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0

        let create = GradientButton(type: .system)
        create.setTitle("Create a trip", for: .normal)
        create.addTarget(self, action: #selector(createTapped), for: .touchUpInside)

        resetButton.setTitle("Reset filters", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        resetButton.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        resetButton.layer.cornerRadius = 22
        resetButton.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [iconWrap, titleLabel, subtitleLabel, create, resetButton])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 14
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 26),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -26),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            create.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.72),
            create.heightAnchor.constraint(equalToConstant: 52),
            resetButton.widthAnchor.constraint(equalTo: create.widthAnchor),
            resetButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        configure(filtered: false)
    }

    @objc private func createTapped() {
        onCreate?()
    }

    @objc private func resetTapped() {
        onReset?()
    }
}
