import UIKit

final class OriChatTrustReviewCell: UIView {
    private let avatarView = OriaImagewaterRemoteView()
    private let avatarPipeline = OriChatTrustAvatarPipeline()
    private let nameLabel = UILabel()
    private let tagLabel = UILabel()
    private let contentLabel = UILabel()
    private let ratingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.06)
        layer.cornerRadius = 18
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor

        avatarView.layer.cornerRadius = 22
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        tagLabel.textColor = AppConstants.accentColor
        tagLabel.font = .systemFont(ofSize: 12, weight: .bold)
        contentLabel.textColor = UIColor.white.withAlphaComponent(0.68)
        contentLabel.font = .systemFont(ofSize: 13)
        contentLabel.numberOfLines = 0
        ratingLabel.textColor = UIColor(red: 244 / 255, green: 201 / 255, blue: 92 / 255, alpha: 1)
        ratingLabel.font = .systemFont(ofSize: 12, weight: .bold)
        ratingLabel.textAlignment = .right

        let header = UIStackView(arrangedSubviews: [nameLabel, ratingLabel])
        header.axis = .horizontal
        header.spacing = 8
        let copy = UIStackView(arrangedSubviews: [header, tagLabel, contentLabel])
        copy.axis = .vertical
        copy.spacing = 5
        let row = UIStackView(arrangedSubviews: [avatarView, copy])
        row.axis = .horizontal
        row.alignment = .top
        row.spacing = 12
        addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 44),
            avatarView.heightAnchor.constraint(equalToConstant: 44),
            row.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(review: OriChatTrustReview) {
        let profile = OriChatTrustUserProfile(
            userId: review.reviewerId,
            name: review.reviewerName,
            avatarURL: review.reviewerAvatarURL,
            avatarAssetName: review.reviewerAvatarAssetName,
            location: "",
            brief: "",
            isVerified: false,
            averageReplyMinutes: nil
        )
        avatarPipeline.load(into: avatarView, profile: profile)
        nameLabel.text = review.reviewerName
        tagLabel.text = review.tag
        contentLabel.text = review.content
        ratingLabel.text = "\(review.rating)/5"
    }
}
