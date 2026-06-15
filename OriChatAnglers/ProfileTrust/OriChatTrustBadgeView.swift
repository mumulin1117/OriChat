import UIKit

final class OriChatTrustBadgeView: UIView {
    private let label = UILabel()

    init(text: String, tint: UIColor = AppConstants.accentColor) {
        super.init(frame: .zero)
        backgroundColor = tint.withAlphaComponent(0.16)
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = tint.withAlphaComponent(0.34).cgColor
        label.text = text
        label.textColor = tint
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 1
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
