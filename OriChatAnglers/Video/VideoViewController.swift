import UIKit

final class VideoViewController: UIViewController {
    private let viewModel = OriChatCatchFeedViewModel()
    private lazy var navigator = OriChatCatchFeedNavigator(navigationController: navigationController)

    private let titleLabel = UILabel()
    private let postButton = UIButton(type: .system)
    private let refreshControl = UIRefreshControl()
    private let stateLabel = UILabel()
    private let retryButton = UIButton(type: .system)

    private lazy var userCollectionView = makeUserCollectionView()
    private lazy var videoCollectionView = makeVideoCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        viewModel.loadInitial()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigator = OriChatCatchFeedNavigator(navigationController: navigationController)
    }

    private func configureUI() {
        view.backgroundColor = AppConstants.darkBackground

        titleLabel.text = "Catch Feed"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)

        postButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        postButton.tintColor = .white
        postButton.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        postButton.layer.cornerRadius = 22
        postButton.addTarget(self, action: #selector(postTapped), for: .touchUpInside)

        stateLabel.textColor = UIColor.white.withAlphaComponent(0.58)
        stateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        stateLabel.textAlignment = .center
        stateLabel.numberOfLines = 0

        retryButton.setTitle("Retry", for: .normal)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        retryButton.backgroundColor = AppConstants.accentColor
        retryButton.layer.cornerRadius = 22
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        retryButton.isHidden = true

        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        videoCollectionView.refreshControl = refreshControl

        [titleLabel, postButton, userCollectionView, videoCollectionView, stateLabel, retryButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            postButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            postButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            postButton.widthAnchor.constraint(equalToConstant: 44),
            postButton.heightAnchor.constraint(equalToConstant: 44),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: postButton.leadingAnchor, constant: -14),
            userCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            userCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userCollectionView.heightAnchor.constraint(equalToConstant: 92),
            videoCollectionView.topAnchor.constraint(equalTo: userCollectionView.bottomAnchor, constant: 16),
            videoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stateLabel.centerXAnchor.constraint(equalTo: videoCollectionView.centerXAnchor),
            stateLabel.centerYAnchor.constraint(equalTo: videoCollectionView.centerYAnchor, constant: -20),
            stateLabel.leadingAnchor.constraint(equalTo: videoCollectionView.leadingAnchor, constant: 28),
            stateLabel.trailingAnchor.constraint(equalTo: videoCollectionView.trailingAnchor, constant: -28),
            retryButton.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: stateLabel.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 132),
            retryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func makeUserCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 14
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 72, height: 86)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OriChatCatchUserStripCell.self, forCellWithReuseIdentifier: OriChatCatchUserStripCell.reuseIdentifier)
        return collectionView
    }

    private func makeVideoCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 24, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OriChatCatchVideoCell.self, forCellWithReuseIdentifier: OriChatCatchVideoCell.reuseIdentifier)
        return collectionView
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.userCollectionView.reloadData()
            self?.videoCollectionView.reloadData()
        }
        viewModel.onStateChange = { [weak self] state in
            self?.apply(state: state)
        }
    }

    private func apply(state: OriChatCatchFeedViewModel.State) {
        retryButton.isHidden = true
        switch state {
        case .idle:
            stateLabel.text = nil
        case .loading:
            stateLabel.text = "Loading catch videos..."
        case .loaded:
            stateLabel.text = nil
        case .empty:
            stateLabel.text = "No catch videos yet.\nPull down to refresh."
        case .failed:
            stateLabel.text = "Could not load catch videos."
            retryButton.isHidden = false
        }
    }

    @objc private func postTapped() {
        navigator.openPostVideo()
    }

    @objc private func retryTapped() {
        viewModel.loadInitial()
    }

    @objc private func refreshPulled() {
        viewModel.loadInitial()
    }

    private func presentReportSheet(for item: OriChatCatchVideo) {
        let alert = UIAlertController(title: "Report this video?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { [weak self] _ in
            self?.navigator.openReport(for: item)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY - 80, width: 1, height: 1)
        }
        present(alert, animated: true)
    }
}

extension VideoViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === userCollectionView {
            return viewModel.users.count
        }
        return viewModel.videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView === userCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OriChatCatchUserStripCell.reuseIdentifier, for: indexPath) as! OriChatCatchUserStripCell
            cell.configure(with: viewModel.users[indexPath.item])
            return cell
        }

        let item = viewModel.videos[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OriChatCatchVideoCell.reuseIdentifier, for: indexPath) as! OriChatCatchVideoCell
        cell.configure(with: item)
        cell.onOpen = { [weak self] in self?.navigator.openVideoDetail(item) }
        cell.onReport = { [weak self] in self?.presentReportSheet(for: item) }
        cell.onUser = { [weak self] in self?.navigator.openUserHome(userId: item.userId) }
        cell.onComment = { [weak self] in self?.navigator.openVideoDetail(item) }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView === userCollectionView {
            navigator.openUserHome(userId: viewModel.users[indexPath.item].userId)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard collectionView === videoCollectionView else {
            return CGSize(width: 72, height: 86)
        }
        let width = collectionView.bounds.width - 40
        let height = min(560, max(390, view.bounds.height * 0.58))
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView === videoCollectionView {
            viewModel.loadMoreIfNeeded(currentIndex: indexPath.item)
        }
    }
}
