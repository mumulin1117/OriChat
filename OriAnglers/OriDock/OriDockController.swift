import UIKit

final class HomeViewController: UIViewController {
    private enum Section: Int, CaseIterable {
        case featured
        case guide
    }

    private let manager = HomeManager()
    private var featuredItems: [HomeDynamicItem] = []
    private var guideItems: [HomeDynamicItem] = []

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let refreshControl = UIRefreshControl()
    private let stateLabel = UILabel()
    private lazy var featuredCollection = makeCollectionView(height: 310, section: .featured)
    private lazy var guideCollection = makeCollectionView(height: 230, section: .guide)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadHome()
    }

    private func configureUI() {
        view.backgroundColor = AppConstants.darkBackground

        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view.safeAreaLayoutGuide)

        contentStack.axis = .vertical
        contentStack.spacing = 24
        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 18),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        contentStack.addArrangedSubview(headerView())
        contentStack.addArrangedSubview(titleBlock())
      
        contentStack.addArrangedSubview(featuredCollection)
        contentStack.addArrangedSubview(sectionTitle("Angler's Guide"))
        contentStack.addArrangedSubview(guideCollection)
        contentStack.addArrangedSubview(stateLabel)

        stateLabel.text = "Loading..."
        stateLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        stateLabel.font = .systemFont(ofSize: 14)
        stateLabel.textAlignment = .center
        stateLabel.numberOfLines = 0
    }

    private func headerView() -> UIView {
        let container = UIView()
        let logo = UIImageView(image: UIImage(named: AppAsset.homeWordmark))
        logo.contentMode = .scaleAspectFit
        let notificationButton = UIButton(type: .system)
        notificationButton.setImage(UIImage(named: AppAsset.homeNotification)?.withRenderingMode(.alwaysOriginal), for: .normal)
        notificationButton.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)

        container.addSubview(logo)
        container.addSubview(notificationButton)
        logo.translatesAutoresizingMaskIntoConstraints = false
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 44),
            logo.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            logo.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            logo.widthAnchor.constraint(equalToConstant: 121),
            logo.heightAnchor.constraint(equalToConstant: 35),
            notificationButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            notificationButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 44),
            notificationButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        return container
    }

    private func titleBlock() -> UIView {
        let label = UILabel()
        label.text = "OriChat 🎣🐟\nWelcome Back,\nSpots For Your Next Catch"
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.numberOfLines = 0
        let wrapper = UIView()
        wrapper.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: wrapper.topAnchor),
            label.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        return wrapper
    }

    private func sectionTitle(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .bold)
        let wrapper = UIView()
        wrapper.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: wrapper.topAnchor),
            label.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        return wrapper
    }

    private func makeCollectionView(height: CGFloat, section: Section) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 18
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.tag = section.rawValue
        collectionView.register(HomeFeatureCell.self, forCellWithReuseIdentifier: HomeFeatureCell.reuseIdentifier)
        collectionView.register(HomeGuideCell.self, forCellWithReuseIdentifier: HomeGuideCell.reuseIdentifier)
        collectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return collectionView
    }

    private func loadHome() {
        stateLabel.text = "Loading..."
        manager.loadHome { [weak self] result in
            guard let self else { return }
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let snapshot):
                self.featuredItems = snapshot.featured
                self.guideItems = snapshot.guides
                self.stateLabel.text = self.featuredItems.isEmpty && self.guideItems.isEmpty ? "No fishing stories yet. Pull down to refresh." : ""
                self.featuredCollection.reloadData()
                self.guideCollection.reloadData()
            case .failure(let error):
                self.stateLabel.text = "Request failed. Pull down to retry."
                print("[OriChat][Home] request failed: \(error.localizedDescription)")
            }
        }
    }

    @objc private func refreshPulled() {
        loadHome()
    }

    @objc private func notificationTapped() {
        openWeb(entryName: "Home System Notifications", route: .oriaSystemtideNotifications)
    }

    private func openWeb(entryName: String, route: OriaTravelrouteWebRoute, query: String? = nil) {
        guard let url = route.oriaTravelrouteFinalURL(oriaDataanglingExtraQuery: query) else {
            print("[OriChat][Click] \(entryName) route=\(route) invalid URL")
            return
        }
        print("[OriChat][Click] entry=\(entryName) route=\(route) oriaTravelrouteFinalURL=\(mask(url.absoluteString))")
        navigationController?.pushViewController(OriaSdkconnectPortalController(url: url), animated: true)
    }

    private func reportQuery(for item: HomeDynamicItem) -> String {
        var query = "dynamicId=\(item.id)"
        if item.userId.isEmpty == false {
            query += "&userId=\(item.userId)"
        }
        return query
    }

    private func mask(_ text: String) -> String {
        guard let tokenRange = text.range(of: "token=") else { return text }
        let prefix = text[..<tokenRange.upperBound]
        let suffixStart = text[tokenRange.upperBound...].firstIndex(of: "&") ?? text.endIndex
        if tokenRange.upperBound == suffixStart {
            return "\(prefix)<missing>\(text[suffixStart...])"
        }
        return "\(prefix)***\(text[suffixStart...])"
    }

    private func item(for collectionView: UICollectionView, indexPath: IndexPath) -> HomeDynamicItem {
        collectionView.tag == Section.featured.rawValue ? featuredItems[indexPath.item] : guideItems[indexPath.item]
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.tag == Section.featured.rawValue ? featuredItems.count : guideItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = item(for: collectionView, indexPath: indexPath)
        if collectionView.tag == Section.featured.rawValue {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeatureCell.reuseIdentifier, for: indexPath) as! HomeFeatureCell
            cell.configure(with: item)
            cell.onReport = { [weak self] in
                self?.openWeb(entryName: "Home Catch Spot Report", route: .oriaBugreport, query: self?.reportQuery(for: item))
            }
            cell.onOpen = { [weak self] in
                self?.openWeb(entryName: "Home Catch Spot", route: .oriaPopularcatchDetail, query: item.id)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGuideCell.reuseIdentifier, for: indexPath) as! HomeGuideCell
            cell.configure(with: item)
            cell.onReport = { [weak self] in
                self?.openWeb(entryName: "Home Angler Guide Report", route: .oriaBugreport, query: self?.reportQuery(for: item))
            }
            cell.onOpen = { [weak self] in
                self?.openWeb(entryName: "Home Angler Guide", route: .oriaRiggingguideDetail, query: item.id)
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == Section.featured.rawValue {
            let width = min(280, max(238, view.bounds.width * 0.72))
            return CGSize(width: width, height: 300)
        }
        let width = min(170, max(145, view.bounds.width * 0.42))
        return CGSize(width: width, height: 220)
    }
}
