import UIKit

final class OriChatBuddyFilterChipView: UIControl {
    private let checkView = UIImageView(image: UIImage(systemName: "checkmark"))
    private let titleLabel = UILabel()

    var title: String { titleLabel.text ?? "" }

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, isSelected: Bool, showsCheckmark: Bool = true) {
        titleLabel.text = title
        self.isSelected = isSelected
        checkView.isHidden = isSelected == false || showsCheckmark == false
        backgroundColor = isSelected ? UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 0.18) : UIColor(red: 27 / 255, green: 27 / 255, blue: 36 / 255, alpha: 1)
        layer.borderColor = (isSelected ? UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 1) : UIColor(red: 55 / 255, green: 55 / 255, blue: 68 / 255, alpha: 1)).cgColor
        titleLabel.textColor = isSelected ? .white : UIColor.white.withAlphaComponent(0.68)
    }

    private func configureUI() {
        layer.cornerRadius = 18
        layer.borderWidth = 1
        checkView.tintColor = UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        [checkView, titleLabel].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 38),
            checkView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            checkView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkView.widthAnchor.constraint(equalToConstant: 13),
            checkView.heightAnchor.constraint(equalToConstant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: checkView.trailingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        configure(title: title, isSelected: false)
    }
}
