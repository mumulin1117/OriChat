import UIKit

enum Toast {
    static func show(_ message: String, in viewController: UIViewController) {
        let label = PaddingLabel()
        label.text = message
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.82)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .center
        viewController.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            label.widthAnchor.constraint(lessThanOrEqualTo: viewController.view.widthAnchor, constant: -48)
        ])
        label.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            label.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 1.7, options: [], animations: {
                label.alpha = 0
            }, completion: { _ in
                label.removeFromSuperview()
            })
        })
    }
}

private final class PaddingLabel: UILabel {
    private let edgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + edgeInsets.left + edgeInsets.right, height: size.height + edgeInsets.top + edgeInsets.bottom)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
}
