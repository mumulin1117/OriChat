import UIKit

final class HomeFeatureCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    static let reuseIdentifier = "HomeFeatureCell"

    var onReport: (() -> Void)?
    var onOpen: (() -> Void)?

    private let imageView = RemoteImageView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let reportButton = UIButton(type: .system)
    private let arrowImageView = UIImageView(image: UIImage(named: AppAsset.homeCardArrow))

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onReport = nil
        onOpen = nil
        imageView.setImageURL(nil)
    }

    func configure(with item: HomeDynamicItem) {
        imageView.setImageURL(item.primaryImageURL)
        titleLabel.text = item.displayTitle
        contentLabel.text = item.displayContent
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(white: 0.10, alpha: 1)
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.numberOfLines = 2

        contentLabel.textColor = UIColor.white.withAlphaComponent(0.86)
        contentLabel.font = .systemFont(ofSize: 14, weight: .regular)
        contentLabel.numberOfLines = 2

        reportButton.setImage(UIImage(systemName: "exclamationmark.bubble"), for: .normal)
        reportButton.tintColor = .white
        reportButton.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        reportButton.layer.cornerRadius = 18
        reportButton.addTarget(self, action: #selector(reportTapped), for: .touchUpInside)

        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.isUserInteractionEnabled = true
        arrowImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTapped)))

        contentView.addSubview(imageView)
        contentView.addSubview(reportButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(arrowImageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.70),
            reportButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            reportButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            reportButton.widthAnchor.constraint(equalToConstant: 36),
            reportButton.heightAnchor.constraint(equalToConstant: 36),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            arrowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 38),
            arrowImageView.heightAnchor.constraint(equalToConstant: 38)
        ])

        let openGesture = UITapGestureRecognizer(target: self, action: #selector(openTapped))
        openGesture.delegate = self
        contentView.addGestureRecognizer(openGesture)
    }

    @objc private func reportTapped() {
        onReport?()
    }

    @objc private func openTapped() {
        onOpen?()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view?.isDescendant(of: reportButton) == false
    }
}
