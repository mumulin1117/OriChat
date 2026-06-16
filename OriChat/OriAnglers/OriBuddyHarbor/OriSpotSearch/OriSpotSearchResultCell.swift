import UIKit

final class OriChatBuddySearchResultCell: UICollectionViewCell {
    static let reuseIdentifier = "OriChatBuddySearchResultCell"

    private let coverView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let categoryLabel = UILabel()
    private let statusLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with trip: OriChatBuddyTrip) {
        coverView.image = AppAsset.buddyImage(named: trip.coverAssetName, fallback: AppAsset.buddyCoverDockMorning)
        titleLabel.text = trip.title
        subtitleLabel.text = "\(trip.dateText) · \(trip.locationTitle)"
        categoryLabel.text = trip.category.rawValue
        statusLabel.text = statusTitle(trip.status)
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 36 / 255, alpha: 1)
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true

        coverView.contentMode = .scaleAspectFill
        coverView.clipsToBounds = true
        coverView.layer.cornerRadius = 12

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        subtitleLabel.textColor = UIColor(red: 141 / 255, green: 141 / 255, blue: 152 / 255, alpha: 1)
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        subtitleLabel.numberOfLines = 1

        [categoryLabel, statusLabel].forEach {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 11, weight: .bold)
            $0.textAlignment = .center
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        categoryLabel.backgroundColor = UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 0.72)
        statusLabel.backgroundColor = UIColor(red: 50 / 255, green: 215 / 255, blue: 215 / 255, alpha: 0.22)

        let labels = UIStackView(arrangedSubviews: [categoryLabel, statusLabel, UIView()])
        labels.axis = .horizontal
        labels.spacing = 8
        labels.alignment = .leading

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, labels])
        textStack.axis = .vertical
        textStack.spacing = 7
        textStack.alignment = .fill

        [coverView, textStack].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            coverView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            coverView.widthAnchor.constraint(equalToConstant: 86),
            coverView.heightAnchor.constraint(equalToConstant: 78),
            textStack.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 12),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 56),
            statusLabel.heightAnchor.constraint(equalTo: categoryLabel.heightAnchor),
            statusLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 82)
        ])
    }

    private func statusTitle(_ status: OriChatBuddyTripStatus) -> String {
        switch status {
        case .recruiting: return "Recruiting"
        case .joined: return "Joined"
        case .full: return "Full"
        case .waitlist: return "Waitlist"
        case .canceled: return "Canceled"
        case .draft: return "Draft"
        }
    }
}
