import UIKit

final class OriChatBuddySearchChipView: UIButton {
    init(title: String, symbol: String? = nil) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white.withAlphaComponent(0.82), for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        backgroundColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 36 / 255, alpha: 1)
        layer.cornerRadius = 18
        layer.borderColor = UIColor(red: 45 / 255, green: 45 / 255, blue: 57 / 255, alpha: 1).cgColor
        layer.borderWidth = 1
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        if let symbol {
            setImage(UIImage(systemName: symbol), for: .normal)
            tintColor = UIColor(red: 50 / 255, green: 215 / 255, blue: 215 / 255, alpha: 1)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -3, bottom: 0, right: 5)
        }
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.12) {
                self.alpha = self.isHighlighted ? 0.68 : 1
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.97, y: 0.97) : .identity
            }
        }
    }
}
