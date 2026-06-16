import UIKit

final class OriChatCatchUserStripCell: UICollectionViewCell {
    static let reuseIdentifier = "OriChatCatchUserStripCell"

    private let avatarView = OriaImagewaterRemoteView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.oriaImagewaterSetURL(nil)
        nameLabel.text = nil
    }

    func configure(with user: OriChatCatchUser) {
        avatarView.oriaImagewaterSetURL(user.avatarURL, placeholderColor: UIColor(white: 0.18, alpha: 1))
        nameLabel.text = user.name
    }

    private func configureUI() {
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 31
        avatarView.layer.borderWidth = 2
        avatarView.layer.borderColor = UIColor.white.withAlphaComponent(0.16).cgColor

        nameLabel.textColor = UIColor.white.withAlphaComponent(0.72)
        nameLabel.font = .systemFont(ofSize: 11, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1

        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 62),
            avatarView.heightAnchor.constraint(equalToConstant: 62),
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
