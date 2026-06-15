import UIKit

final class ProfileViewController: UIViewController {
    private let authStore: AuthStore
    private let viewModel: OriChatCatchProfileViewModel
    private let buddyStore: OriChatBuddyHarborStore
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private let refreshControl = UIRefreshControl()
    private let titleLabel = UILabel()
    private let headerView = OriChatCatchProfileHeaderView()
    private let walletView = OriChatCatchWalletView()
    private let segmentView = OriChatCatchSegmentView()
    private let recordsStack = UIStackView()
    private var currentState: OriChatCatchProfileViewState?

    init(authStore: AuthStore) {
        self.authStore = authStore
        self.buddyStore = OriChatBuddyHarborStore()
        self.viewModel = OriChatCatchProfileViewModel(buddyStore: buddyStore, authStore: authStore)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindActions()
        load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }

    private func configureUI() {
        view.backgroundColor = AppConstants.darkBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.refreshControl = refreshControl
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        stack.axis = .vertical
        stack.spacing = 14
        scrollView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -36)
        ])

        stack.addArrangedSubview(navBar())
        let headerSpacer = UIView()
        headerSpacer.heightAnchor.constraint(equalToConstant: 42).isActive = true
        stack.addArrangedSubview(headerSpacer)
        stack.addArrangedSubview(headerView)
        stack.addArrangedSubview(walletView)
        stack.addArrangedSubview(segmentView)
        recordsStack.axis = .vertical
        recordsStack.spacing = 10
        stack.addArrangedSubview(recordsStack)
    }

    private func navBar() -> UIView {
        titleLabel.text = "My Catch"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 19, weight: .heavy)
        let edit = iconButton("square.and.pencil", action: #selector(editTapped))
        let settings = iconButton("gearshape", action: #selector(settingsTapped))
        let actions = UIStackView(arrangedSubviews: [edit, settings])
        actions.axis = .horizontal
        actions.spacing = 10
        let row = UIStackView(arrangedSubviews: [titleLabel, actions])
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .equalSpacing
        row.heightAnchor.constraint(equalToConstant: 38).isActive = true
        return row
    }

    private func iconButton(_ symbol: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.tintColor = UIColor.white.withAlphaComponent(0.72)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return button
    }

    private func bindActions() {
        headerView.onFollowing = { [weak self] in self?.open(route: .following, entry: "Following") }
        headerView.onFollowers = { [weak self] in self?.open(route: .followers, entry: "Followers") }
        headerView.onPosts = { [weak self] in
            guard let self else { return }
            self.render(self.viewModel.select(tab: .myPosts))
            self.open(route: .userHomepage, entry: "Post count", extraQuery: self.currentState?.summary.userId)
        }
        walletView.addTarget(self, action: #selector(walletTapped), for: .touchUpInside)
        segmentView.onSelect = { [weak self] tab in
            guard let self else { return }
            self.render(self.viewModel.select(tab: tab))
        }
    }

    private func load() {
        viewModel.load { [weak self] state in
            self?.refreshControl.endRefreshing()
            self?.render(state)
        }
    }

    private func render(_ state: OriChatCatchProfileViewState) {
        currentState = state
        headerView.configure(summary: state.summary)
        walletView.configure(hasWalletState: state.summary.hasWalletState)
        segmentView.select(state.selectedTab)
        recordsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if state.records.isEmpty {
            let empty = OriChatCatchProfileEmptyView(message: emptyMessage(for: state.selectedTab), showsCreate: state.selectedTab == .myPosts)
            empty.onCreate = { [weak self] in self?.createTripTapped() }
            recordsStack.addArrangedSubview(empty)
        } else {
            state.records.forEach { record in
                let card = OriChatCatchRecordCardView()
                card.configure(record: record)
                card.onAction = { [weak self] record in
                    self?.handle(record: record)
                }
                recordsStack.addArrangedSubview(card)
            }
            if state.selectedTab == .myPosts {
                let empty = OriChatCatchProfileEmptyView(message: "Anglers near you are looking for buddies this weekend.", showsCreate: true)
                empty.onCreate = { [weak self] in self?.createTripTapped() }
                recordsStack.addArrangedSubview(empty)
            }
        }
    }

    private func emptyMessage(for tab: OriChatCatchProfileRecordTab) -> String {
        switch tab {
        case .myPosts:
            return "Anglers near you are looking for buddies this weekend."
        case .applied:
            return "Applied trips will appear here when you request a spot."
        case .joined:
            return "Joined trips will appear here after you enter a crew."
        case .history:
            return "Completed and canceled fishing records will appear here."
        }
    }

    private func handle(record: OriChatCatchProfileRecord) {
        switch record.action {
        case .view:
            open(route: .catchDetail, entry: "Record view", extraQuery: record.id)
        case .review:
            open(route: .report, entry: "Record review", extraQuery: "tripId=\(record.id)")
        case .chat:
            open(route: .privateChat, entry: "Record chat", extraQuery: record.trip.organizer.id)
        }
    }

    private func open(route: WebRoute, entry: String, extraQuery: String? = nil) {
        guard let url = route.finalURL(extraQuery: extraQuery, authStore: authStore) else { return }
        print("[OriChat][Profile] entry=\(entry) route=\(route) finalURL=\(masked(url.absoluteString))")
        navigationController?.pushViewController(WebPortalViewController(url: url), animated: true)
    }

    private func masked(_ text: String) -> String {
        guard let range = text.range(of: "token=") else { return text }
        let suffix = text[range.upperBound...].firstIndex(of: "&") ?? text.endIndex
        return "\(text[..<range.upperBound])***\(text[suffix...])"
    }

    @objc private func refreshPulled() {
        load()
    }

    @objc private func editTapped() {
        open(route: .editProfile, entry: "Edit profile")
    }

    @objc private func settingsTapped() {
        open(route: .settings, entry: "Settings")
    }

    @objc private func walletTapped() {
        open(route: .wallet, entry: "My wallet")
    }

    private func createTripTapped() {
        let create = OriChatBuddyCreateController()
        create.onCreate = { [weak self] trip in
            guard let self else { return }
            self.buddyStore.create(trip)
            self.navigationController?.popViewController(animated: true)
            self.load()
            Toast.show("Trip created.", in: self)
        }
        navigationController?.pushViewController(create, animated: true)
    }

    @objc private func signOutTapped() {
        authStore.signOut()
        guard let window = view.window else { return }
        window.rootViewController = AuthEntryViewController(authStore: authStore)
        UIView.transition(with: window, duration: 0.25, options: [.transitionCrossDissolve], animations: nil)
    }
}
