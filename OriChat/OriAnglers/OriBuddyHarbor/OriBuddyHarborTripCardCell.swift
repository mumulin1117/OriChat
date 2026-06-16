import UIKit

final class OriChatBuddyTripCardCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    static let reuseIdentifier = "OriChatBuddyTripCardCell"

    var onOpen: (() -> Void)?
    var onMore: (() -> Void)?
    var onApply: (() -> Void)?

    private let coverView = UIImageView()
    private let moreButton = UIButton(type: .system)
    private let categoryLabel = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private let spotsLabel = UILabel()
    private let costLabel = UILabel()
    private let skillLabel = UILabel()
    private let avatarView = UIImageView()
    private let organizerLabel = UILabel()
    private let statsLabel = UILabel()
    private let actionButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with trip: OriChatBuddyTrip) {
        coverView.image = AppAsset.buddyImage(named: trip.coverAssetName, fallback: AppAsset.buddyCoverDockMorning)
        categoryLabel.text = trip.category.rawValue
        titleLabel.text = trip.title
        dateLabel.text = "\(trip.dateText) · \(trip.startTimeText) – \(trip.endTimeText)"
        locationLabel.text = "\(trip.locationTitle) · \(trip.distanceText)"
        let progress = Float(trip.joinedCount) / Float(max(1, trip.capacity))
        progressView.progress = progress
        spotsLabel.text = "\(trip.joinedCount)/\(trip.capacity) anglers · \(trip.openSpots) spots left"
        costLabel.text = trip.costTitle
        skillLabel.text = trip.skillText
        avatarView.image = AppAsset.buddyImage(named: trip.organizer.avatarAssetName, fallback: AppAsset.buddyAvatarGuest01)
        organizerLabel.text = trip.organizer.name
        statsLabel.text = String(format: "%.1f · %d trips", trip.organizer.rating, trip.organizer.trips)
        configureAction(trip)
    }

    private func configureAction(_ trip: OriChatBuddyTrip) {
        let title: String
        let enabled: Bool
        switch trip.status {
        case .joined:
            title = "Joined"
            enabled = true
        case .waitlist:
            title = "Waitlist"
            enabled = true
        case .full:
            title = "Waitlist"
            enabled = true
        case .recruiting:
            title = "Apply"
            enabled = true
        case .canceled:
            title = "Canceled"
            enabled = false
        case .draft:
            title = "Draft"
            enabled = false
        }
        actionButton.setTitle(title, for: .normal)
        actionButton.isEnabled = enabled
        actionButton.alpha = enabled ? 1 : 0.7
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 38 / 255, alpha: 1)
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true

        coverView.contentMode = .scaleAspectFill
        coverView.clipsToBounds = true
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .white
        moreButton.backgroundColor = UIColor.black.withAlphaComponent(0.42)
        moreButton.layer.cornerRadius = 17
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)

        categoryLabel.textColor = .white
        categoryLabel.font = .systemFont(ofSize: 12, weight: .bold)
        categoryLabel.backgroundColor = UIColor.black.withAlphaComponent(0.44)
        categoryLabel.layer.cornerRadius = 12
        categoryLabel.clipsToBounds = true
        categoryLabel.textAlignment = .center

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 2
        [dateLabel, locationLabel, spotsLabel, statsLabel].forEach {
            $0.textColor = UIColor.white.withAlphaComponent(0.62)
            $0.font = .systemFont(ofSize: 12)
        }
        progressView.progressTintColor = AppConstants.accentColor
        progressView.trackTintColor = UIColor.white.withAlphaComponent(0.14)
        [costLabel, skillLabel].forEach {
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 11, weight: .semibold)
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.10)
            $0.layer.cornerRadius = 11
            $0.clipsToBounds = true
            $0.textAlignment = .center
        }
        avatarView.contentMode = .scaleAspectFill
        avatarView.layer.cornerRadius = 16
        avatarView.clipsToBounds = true
        organizerLabel.textColor = .white
        organizerLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        actionButton.backgroundColor = AppConstants.accentColor
        actionButton.layer.cornerRadius = 18
        actionButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)

        [coverView, moreButton, categoryLabel, titleLabel, dateLabel, locationLabel, progressView, spotsLabel, costLabel, skillLabel, avatarView, organizerLabel, statsLabel, actionButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverView.heightAnchor.constraint(equalToConstant: 132),
            moreButton.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 12),
            moreButton.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -12),
            moreButton.widthAnchor.constraint(equalToConstant: 34),
            moreButton.heightAnchor.constraint(equalToConstant: 34),
            categoryLabel.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 14),
            categoryLabel.bottomAnchor.constraint(equalTo: coverView.bottomAnchor, constant: -14),
            categoryLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 54),
            categoryLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.topAnchor.constraint(equalTo: coverView.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            progressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            spotsLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            spotsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            costLabel.topAnchor.constraint(equalTo: spotsLabel.bottomAnchor, constant: 12),
            costLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            costLabel.widthAnchor.constraint(equalToConstant: 60),
            costLabel.heightAnchor.constraint(equalToConstant: 24),
            skillLabel.leadingAnchor.constraint(equalTo: costLabel.trailingAnchor, constant: 8),
            skillLabel.centerYAnchor.constraint(equalTo: costLabel.centerYAnchor),
            skillLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 132),
            skillLabel.heightAnchor.constraint(equalTo: costLabel.heightAnchor),
            avatarView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            avatarView.widthAnchor.constraint(equalToConstant: 32),
            avatarView.heightAnchor.constraint(equalToConstant: 32),
            organizerLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 9),
            organizerLabel.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: -1),
            statsLabel.leadingAnchor.constraint(equalTo: organizerLabel.leadingAnchor),
            statsLabel.topAnchor.constraint(equalTo: organizerLabel.bottomAnchor, constant: 1),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 96),
            actionButton.heightAnchor.constraint(equalToConstant: 36)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(openTapped))
        tap.delegate = self
        contentView.addGestureRecognizer(tap)
    }

    @objc private func openTapped() { onOpen?() }
    @objc private func moreTapped() { onMore?() }
    @objc private func applyTapped() { onApply?() }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        [moreButton, actionButton].allSatisfy { touch.view?.isDescendant(of: $0) == false }
    }
}
