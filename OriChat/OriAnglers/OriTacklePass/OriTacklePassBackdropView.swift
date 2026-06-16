import UIKit

final class AuthBackgroundView: UIView {
    private let imageView = UIImageView(image: UIImage(named: AppAsset.authBackground))
    private let dimView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        backgroundColor = AppConstants.darkBackground
        imageView.contentMode = .scaleAspectFill
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        addSubview(imageView)
        addSubview(dimView)
        imageView.pinEdges(to: self)
        dimView.pinEdges(to: self)
    }
}
