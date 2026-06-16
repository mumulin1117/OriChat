import UIKit

final class OriChatTrustEmptyReviewView: UIView {
    init(message: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.white.withAlphaComponent(0.05)
        layer.cornerRadius = 18
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor

        let icon = UIImageView(image: UIImage(systemName: "fish"))
        icon.tintColor = AppConstants.accentColor
        icon.contentMode = .scaleAspectFit
        let label = UILabel()
        label.text = message
        label.textColor = UIColor.white.withAlphaComponent(0.62)
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        let stack = UIStackView(arrangedSubviews: [icon, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 118),
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.heightAnchor.constraint(equalToConstant: 28),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
