import UIKit

final class OriChatBuddyChipView: UIButton {
    var isChipSelected = false {
        didSet { updateStyle() }
    }

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        contentEdgeInsets = UIEdgeInsets(top: 9, left: 14, bottom: 9, right: 14)
        layer.cornerRadius = 18
        updateStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateStyle() {
        backgroundColor = isChipSelected ? .white : UIColor(white: 0.13, alpha: 1)
        setTitleColor(isChipSelected ? .black : UIColor.white.withAlphaComponent(0.70), for: .normal)
    }
}

final class OriChatBuddyHeroHeaderView: UIView {
    var onAI: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = UIColor(red: 33 / 255, green: 34 / 255, blue: 46 / 255, alpha: 1)
        layer.cornerRadius = 22

        let tag = UILabel()
        tag.text = "FISHING BUDDY"
        tag.textColor = AppConstants.accentColor
        tag.font = .systemFont(ofSize: 11, weight: .bold)

        let title = UILabel()
        title.text = "FishBuddy AI"
        title.textColor = .white
        title.font = .systemFont(ofSize: 22, weight: .bold)

        let subtitle = UILabel()
        subtitle.text = "Your smart fishing buddy"
        subtitle.textColor = UIColor.white.withAlphaComponent(0.62)
        subtitle.font = .systemFont(ofSize: 14)

        let arrow = UIButton(type: .system)
        arrow.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        arrow.tintColor = .black
        arrow.backgroundColor = .white
        arrow.layer.cornerRadius = 20
        arrow.addTarget(self, action: #selector(aiTapped), for: .touchUpInside)

        [tag, title, subtitle, arrow].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 128),
            tag.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            tag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.topAnchor.constraint(equalTo: tag.bottomAnchor, constant: 8),
            title.leadingAnchor.constraint(equalTo: tag.leadingAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            subtitle.leadingAnchor.constraint(equalTo: tag.leadingAnchor),
            subtitle.trailingAnchor.constraint(lessThanOrEqualTo: arrow.leadingAnchor, constant: -16),
            arrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 40),
            arrow.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc private func aiTapped() {
        onAI?()
    }
}

final class OriChatBuddyInfoTileView: UIView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let subtitleLabel = UILabel()

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(value: String, subtitle: String) {
        valueLabel.text = value
        subtitleLabel.text = subtitle
    }

    private func configureUI() {
        backgroundColor = UIColor(white: 0.12, alpha: 1)
        layer.cornerRadius = 16
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.44)
        titleLabel.font = .systemFont(ofSize: 11, weight: .bold)
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        valueLabel.numberOfLines = 2
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.60)
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.numberOfLines = 2

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 6
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 96),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }
}
