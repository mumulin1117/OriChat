import UIKit

final class OriChatCatchVideoCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    static let reuseIdentifier = "OriChatCatchVideoCell"

    var onOpen: (() -> Void)?
    var onReport: (() -> Void)?
    var onUser: (() -> Void)?
    var onComment: (() -> Void)?

    private let coverView = OriaImagewaterRemoteView()
    private let overlayView = UIView()
    private let playButton = UIButton(type: .system)
    private let reportButton = UIButton(type: .system)
    private let avatarView = OriaImagewaterRemoteView()
    private let authorButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    private let likeButton = UIButton(type: .system)
    private let commentButton = UIButton(type: .system)
    private let storeButton = UIButton(type: .system)

    private var likeCount = 0
    private var storeCount = 0
    private var liked = false
    private var stored = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onOpen = nil
        onReport = nil
        onUser = nil
        onComment = nil
        coverView.oriaImagewaterSetURL(nil)
        avatarView.oriaImagewaterSetURL(nil)
        liked = false
        stored = false
    }

    func configure(with item: OriChatCatchVideo) {
        coverView.oriaImagewaterSetURL(item.videoCoverURL, placeholderColor: UIColor(white: 0.12, alpha: 1))
        avatarView.oriaImagewaterSetURL(item.userAvatarURL, placeholderColor: UIColor(white: 0.20, alpha: 1))
        authorButton.setTitle(item.userName, for: .normal)
        titleLabel.text = item.displayTitle
        contentLabel.text = item.displayContent
        likeCount = item.praiseNum
        storeCount = item.storeNum
        updateActionButtons(commentCount: item.commentNum)
    }

    private func configureUI() {
        contentView.backgroundColor = UIColor(white: 0.10, alpha: 1)
        contentView.layer.cornerRadius = 28
        contentView.clipsToBounds = true

        coverView.contentMode = .scaleAspectFill
        coverView.clipsToBounds = true
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.18)

        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = .black
        playButton.backgroundColor = UIColor.white.withAlphaComponent(0.92)
        playButton.layer.cornerRadius = 27
        playButton.addTarget(self, action: #selector(openTapped), for: .touchUpInside)

        reportButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        reportButton.tintColor = .white
        reportButton.backgroundColor = UIColor.black.withAlphaComponent(0.44)
        reportButton.layer.cornerRadius = 18
        reportButton.addTarget(self, action: #selector(reportTapped), for: .touchUpInside)

        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 19
        avatarView.isUserInteractionEnabled = true
        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(userTapped)))

        authorButton.setTitleColor(.white, for: .normal)
        authorButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        authorButton.contentHorizontalAlignment = .left
        authorButton.addTarget(self, action: #selector(userTapped), for: .touchUpInside)

        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 2
        contentLabel.textColor = UIColor.white.withAlphaComponent(0.76)
        contentLabel.font = .systemFont(ofSize: 13, weight: .regular)
        contentLabel.numberOfLines = 2

        [likeButton, commentButton, storeButton].forEach {
            $0.tintColor = .white
            $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.38)
            $0.layer.cornerRadius = 18
            $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 9, bottom: 0, right: 9)
        }
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentTapped), for: .touchUpInside)
        storeButton.addTarget(self, action: #selector(storeTapped), for: .touchUpInside)

        [coverView, overlayView, playButton, reportButton, avatarView, authorButton, titleLabel, contentLabel, likeButton, commentButton, storeButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10),
            playButton.widthAnchor.constraint(equalToConstant: 54),
            playButton.heightAnchor.constraint(equalToConstant: 54),
            reportButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            reportButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            reportButton.widthAnchor.constraint(equalToConstant: 36),
            reportButton.heightAnchor.constraint(equalToConstant: 36),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            avatarView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
            avatarView.widthAnchor.constraint(equalToConstant: 38),
            avatarView.heightAnchor.constraint(equalToConstant: 38),
            authorButton.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 9),
            authorButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            authorButton.trailingAnchor.constraint(lessThanOrEqualTo: likeButton.leadingAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            titleLabel.bottomAnchor.constraint(equalTo: avatarView.topAnchor, constant: -10),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -4),
            storeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            storeButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            storeButton.heightAnchor.constraint(equalToConstant: 36),
            commentButton.trailingAnchor.constraint(equalTo: storeButton.leadingAnchor, constant: -8),
            commentButton.centerYAnchor.constraint(equalTo: storeButton.centerYAnchor),
            commentButton.heightAnchor.constraint(equalTo: storeButton.heightAnchor),
            likeButton.trailingAnchor.constraint(equalTo: commentButton.leadingAnchor, constant: -8),
            likeButton.centerYAnchor.constraint(equalTo: storeButton.centerYAnchor),
            likeButton.heightAnchor.constraint(equalTo: storeButton.heightAnchor)
        ])

        let openGesture = UITapGestureRecognizer(target: self, action: #selector(openTapped))
        openGesture.delegate = self
        contentView.addGestureRecognizer(openGesture)
    }

    private func updateActionButtons(commentCount: Int? = nil) {
        likeButton.setImage(UIImage(systemName: liked ? "heart.fill" : "heart"), for: .normal)
        likeButton.setTitle(" \(max(0, likeCount))", for: .normal)
        likeButton.tintColor = liked ? AppConstants.accentColor : .white
        if let commentCount {
            commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
            commentButton.setTitle(" \(commentCount)", for: .normal)
        }
        storeButton.setImage(UIImage(systemName: stored ? "bookmark.fill" : "bookmark"), for: .normal)
        storeButton.setTitle(" \(max(0, storeCount))", for: .normal)
        storeButton.tintColor = stored ? AppConstants.accentColor : .white
    }

    @objc private func openTapped() {
        onOpen?()
    }

    @objc private func reportTapped() {
        onReport?()
    }

    @objc private func userTapped() {
        onUser?()
    }

    @objc private func commentTapped() {
        onComment?()
    }

    @objc private func likeTapped() {
        liked.toggle()
        likeCount += liked ? 1 : -1
        updateActionButtons()
    }

    @objc private func storeTapped() {
        stored.toggle()
        updateActionButtons()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        [reportButton, likeButton, commentButton, storeButton, authorButton, avatarView].allSatisfy {
            touch.view?.isDescendant(of: $0) == false
        }
    }
}
