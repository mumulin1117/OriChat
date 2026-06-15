import UIKit

final class HomeGuideCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    static let reuseIdentifier = "HomeGuideCell"

    var onReport: (() -> Void)?
    var onOpen: (() -> Void)?

    private let imageView = RemoteImageView()
    private let titleLabel = UILabel()
    private let metaLabel = UILabel()
    private let reportButton = UIButton(type: .system)

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
        metaLabel.text = "\(item.likeCount) likes  \(item.commentCount) comments"
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(white: 0.11, alpha: 1)
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 2
        metaLabel.textColor = UIColor.white.withAlphaComponent(0.52)
        metaLabel.font = .systemFont(ofSize: 12)

        reportButton.setImage(UIImage(systemName: "flag"), for: .normal)
        reportButton.tintColor = .white
        reportButton.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        reportButton.layer.cornerRadius = 15
        reportButton.addTarget(self, action: #selector(reportTapped), for: .touchUpInside)

        contentView.addSubview(imageView)
        contentView.addSubview(reportButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(metaLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        metaLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            reportButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            reportButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            reportButton.widthAnchor.constraint(equalToConstant: 30),
            reportButton.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            metaLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            metaLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            metaLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
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
