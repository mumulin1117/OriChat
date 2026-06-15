import UIKit

final class AuthTextField: UITextField {
    init(placeholder: String, symbolName: String) {
        super.init(frame: .zero)
        configure(placeholder: placeholder, symbolName: symbolName)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(placeholder: "", symbolName: "circle")
    }

    private func configure(placeholder: String, symbolName: String) {
        backgroundColor = .white
        textColor = .black
        tintColor = AppConstants.accentColor
        font = .systemFont(ofSize: 16, weight: .regular)
        layer.cornerRadius = 26
        clipsToBounds = true
        autocapitalizationType = .none
        autocorrectionType = .no
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor(white: 0.62, alpha: 1)]
        )

        let icon = UIImageView(image: UIImage(systemName: symbolName))
        icon.tintColor = UIColor(white: 0.62, alpha: 1)
        icon.contentMode = .scaleAspectFit
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 58, height: 24))
        icon.frame = CGRect(x: 18, y: 0, width: 24, height: 24)
        container.addSubview(icon)
        leftView = container
        leftViewMode = .always
        heightAnchor.constraint(equalToConstant: 54).isActive = true
    }
}
