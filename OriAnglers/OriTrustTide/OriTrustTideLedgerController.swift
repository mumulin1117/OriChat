import UIKit

final class OriChatTrustProfileController: UIViewController {
    private let viewModel: OriChatTrustProfileViewModel
    private let avatarPipeline = OriChatTrustAvatarPipeline()
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private let refreshControl = UIRefreshControl()
    private let avatarView = OriaImagewaterRemoteView()
    private let nameLabel = UILabel()
    private let metaLabel = UILabel()
    private let briefLabel = UILabel()
    private let tagStack = UIStackView()
    private let scoreCard = OriChatTrustScoreCardView()
    private let organizedTile = OriChatTrustMetricTileView(title: "ORGANIZED")
    private let joinedTile = OriChatTrustMetricTileView(title: "JOINED")
    private let replyTile = OriChatTrustMetricTileView(title: "AVG REPLY")
    private let buddySayStack = UIStackView()
    private let reviewStack = UIStackView()

    init(mode: OriChatTrustProfileMode,
         buddyStore: OriChatBuddyHarborStore = OriChatBuddyHarborStore(),
         localProfile: OriChatTrustUserProfile? = nil) {
        self.viewModel = OriChatTrustProfileViewModel(mode: mode, buddyStore: buddyStore, localProfile: localProfile)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        load()
    }

    private func configureUI() {
        view.backgroundColor = AppConstants.darkBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(scrollView)
        scrollView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -28),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])

        stack.addArrangedSubview(headerBar())
        stack.addArrangedSubview(identityBlock())
        stack.addArrangedSubview(scoreCard)
        stack.addArrangedSubview(metricRow())
        stack.addArrangedSubview(section(title: "What buddies say", body: buddySayStack))
        stack.addArrangedSubview(section(title: "Recent reviews", body: reviewStack))
    }

    private func headerBar() -> UIView {
        let back = UIButton(type: .system)
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .white
        back.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        back.layer.cornerRadius = 20
        back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        let title = UILabel()
        title.text = "My Trust Profile"
        title.textColor = .white
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textAlignment = .center

        let edit = UIButton(type: .system)
        edit.setImage(UIImage(systemName: "pencil"), for: .normal)
        edit.tintColor = .white
        edit.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        edit.layer.cornerRadius = 20
        edit.addTarget(self, action: #selector(editTapped), for: .touchUpInside)

        let row = UIStackView(arrangedSubviews: [back, title, edit])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        NSLayoutConstraint.activate([
            back.widthAnchor.constraint(equalToConstant: 40),
            back.heightAnchor.constraint(equalToConstant: 40),
            edit.widthAnchor.constraint(equalToConstant: 40),
            edit.heightAnchor.constraint(equalToConstant: 40),
            row.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])
        return row
    }

    private func identityBlock() -> UIView {
        let container = UIView()
        avatarView.layer.cornerRadius = 46
        let verified = UIImageView(image: UIImage(systemName: "checkmark.seal.fill"))
        verified.tintColor = AppConstants.accentColor
        nameLabel.textColor = .white
        nameLabel.font = .systemFont(ofSize: 28, weight: .heavy)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        metaLabel.textColor = UIColor.white.withAlphaComponent(0.62)
        metaLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        metaLabel.textAlignment = .center
        metaLabel.numberOfLines = 0
        briefLabel.textColor = UIColor.white.withAlphaComponent(0.58)
        briefLabel.font = .systemFont(ofSize: 14)
        briefLabel.textAlignment = .center
        briefLabel.numberOfLines = 0

        tagStack.axis = .horizontal
        tagStack.alignment = .center
        tagStack.spacing = 8
        tagStack.distribution = .fill

        [avatarView, verified, nameLabel, metaLabel, briefLabel, tagStack].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: container.topAnchor),
            avatarView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 92),
            avatarView.heightAnchor.constraint(equalToConstant: 92),
            verified.trailingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 2),
            verified.bottomAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 2),
            verified.widthAnchor.constraint(equalToConstant: 26),
            verified.heightAnchor.constraint(equalToConstant: 26),
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 14),
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            metaLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            metaLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            metaLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            briefLabel.topAnchor.constraint(equalTo: metaLabel.bottomAnchor, constant: 10),
            briefLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            briefLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            tagStack.topAnchor.constraint(equalTo: briefLabel.bottomAnchor, constant: 14),
            tagStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            tagStack.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor),
            tagStack.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
            tagStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    private func metricRow() -> UIView {
        let row = UIStackView(arrangedSubviews: [organizedTile, joinedTile, replyTile])
        row.axis = .horizontal
        row.spacing = 10
        row.distribution = .fillEqually
        return row
    }

    private func section(title: String, body: UIStackView) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        body.axis = .vertical
        body.spacing = 10
        let stack = UIStackView(arrangedSubviews: [titleLabel, body])
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }

    private func load() {
        viewModel.load { [weak self] state in
            self?.refreshControl.endRefreshing()
            self?.render(state)
        }
    }

    private func render(_ state: OriChatTrustProfileState) {
        switch state {
        case .loaded(let data):
            render(data: data)
        case .partial(let data, let warning):
            render(data: data)
            if let warning { Toast.show(warning, in: self) }
        case .failed(let message):
            Toast.show(message, in: self)
        case .empty:
            Toast.show("No trust profile yet.", in: self)
        case .loading:
            break
        }
    }

    private func render(data: OriChatTrustProfileViewData) {
        avatarPipeline.load(into: avatarView, profile: data.profile)
        nameLabel.text = data.profile.name
        metaLabel.text = "\(data.profile.location) · replies \(data.metrics.averageReplyText)"
        briefLabel.text = data.profile.brief
        scoreCard.configure(metrics: data.metrics)
        organizedTile.configure(value: "\(data.metrics.organizedCount)")
        joinedTile.configure(value: "\(data.metrics.joinedCount)")
        replyTile.configure(value: data.metrics.averageReplyText)
        renderTags(data.metrics.buddyTags)
        renderBuddySay(data.metrics.buddyTags)
        renderReviews(data.metrics.reviews)
    }

    private func renderTags(_ tags: [String]) {
        tagStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for tag in tags.prefix(3) {
            tagStack.addArrangedSubview(OriChatTrustBadgeView(text: tag))
        }
    }

    private func renderBuddySay(_ tags: [String]) {
        buddySayStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if tags.isEmpty {
            buddySayStack.addArrangedSubview(OriChatTrustEmptyReviewView(message: "Buddy tags will appear after anglers review completed trips."))
            return
        }
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        row.alignment = .leading
        row.distribution = .fill
        for tag in tags.prefix(3) {
            row.addArrangedSubview(OriChatTrustBadgeView(text: tag, tint: UIColor(red: 112 / 255, green: 205 / 255, blue: 172 / 255, alpha: 1)))
        }
        buddySayStack.addArrangedSubview(row)
    }

    private func renderReviews(_ reviews: [OriChatTrustReview]) {
        reviewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if reviews.isEmpty {
            reviewStack.addArrangedSubview(OriChatTrustEmptyReviewView(message: "No reviews yet. Complete buddy trips to collect trust notes."))
            return
        }
        reviews.prefix(3).forEach { review in
            let cell = OriChatTrustReviewCell()
            cell.configure(review: review)
            reviewStack.addArrangedSubview(cell)
        }
    }

    @objc private func refreshPulled() {
        load()
    }

    @objc private func editTapped() {
        let alert = UIAlertController(title: "Edit profile", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Edit profile", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            Toast.show("Profile editor TODO.", in: self)
        }))
        alert.addAction(UIAlertAction(title: "Change avatar", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            Toast.show("Avatar picker TODO.", in: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
