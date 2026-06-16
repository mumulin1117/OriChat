import UIKit

final class GradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = bounds.height / 2
    }

    private func configure() {
        gradientLayer.colors = [
            UIColor(red: 239 / 255, green: 70 / 255, blue: 111 / 255, alpha: 1).cgColor,
            UIColor(red: 248 / 255, green: 86 / 255, blue: 155 / 255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        setTitleColor(.white, for: .normal)
        clipsToBounds = true
        heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        heightAnchor.constraint(lessThanOrEqualToConstant: 56).isActive = true
    }
}
