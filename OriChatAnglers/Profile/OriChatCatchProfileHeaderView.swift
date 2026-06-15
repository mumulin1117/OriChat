import UIKit

final class OriChatCatchProfileHeaderView: UIView {
    var onFollowing: (() -> Void)?
    var onPosts: (() -> Void)?
    var onFollowers: (() -> Void)?

    private let avatarView = RemoteImageView()
    private let ratingLabel = UILabel()
    private let nameLabel = UILabel()
    private let followingButton = UIButton(type: .system)
    private let postsButton = UIButton(type: .system)
    private let followersButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarView.layer.cornerRadius = avatarView.bounds.height / 2
    }

    func configure(summary: OriChatCatchProfileSummary) {
        avatarView.contentMode = .scaleAspectFill
        if let avatarURL = summary.avatarURL, avatarURL.isEmpty == false {
            avatarView.setImageURL(avatarURL, placeholderColor: UIColor.white.withAlphaComponent(0.08))
        } else {
            avatarView.image = UIImage(named: summary.avatarAssetName)
            avatarView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        }
        ratingLabel.text = summary.ratingText == "No rating yet" ? summary.ratingText : "★ \(summary.ratingText)"
        nameLabel.text = summary.name
        configure(stat: followingButton, value: summary.followingCount, title: "Following")
        configure(stat: postsButton, value: summary.postCount, title: "Post")
        configure(stat: followersButton, value: summary.followersCount, title: "Followers")
    }

    private func configureUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.08)
        layer.cornerRadius = 22
        avatarView.clipsToBounds = true
        ratingLabel.textColor = UIColor(red: 245 / 255, green: 208 / 255, blue: 89 / 255, alpha: 1)
        ratingLabel.font = .systemFont(ofSize: 11, weight: .bold)
        ratingLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 13, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1

        let statRow = UIStackView(arrangedSubviews: [followingButton, postsButton, followersButton])
        statRow.axis = .horizontal
        statRow.distribution = .fillEqually
        statRow.spacing = 8
        let stack = UIStackView(arrangedSubviews: [avatarView, ratingLabel, nameLabel, statRow])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 6
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 72),
            avatarView.heightAnchor.constraint(equalToConstant: 72),
            avatarView.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: -46),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 146)
        ])

        followingButton.addTarget(self, action: #selector(followingTapped), for: .touchUpInside)
        postsButton.addTarget(self, action: #selector(postsTapped), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(followersTapped), for: .touchUpInside)
    }

    private func configure(stat button: UIButton, value: Int, title: String) {
        let text = NSMutableAttributedString(
            string: "\(title)\n",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.72),
                .font: UIFont.systemFont(ofSize: 11, weight: .medium)
            ]
        )
        text.append(NSAttributedString(
            string: "\(value)",
            attributes: [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 19, weight: .heavy)
            ]
        ))
        button.setAttributedTitle(text, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
    }

    @objc private func followingTapped() { onFollowing?() }
    @objc private func postsTapped() { onPosts?() }
    @objc private func followersTapped() { onFollowers?() }
}
