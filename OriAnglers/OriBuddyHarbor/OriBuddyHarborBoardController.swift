import UIKit

final class CommunityViewController: OriChatBuddyBoardController {}

class OriChatBuddyBoardController: UIViewController {
    private let harborStore = OriChatBuddyHarborStore()
    private let filterEngine = OriChatBuddyFilterEngine()
    private let filterMemory = OriChatBuddyFilterMemory()
    private var trips: [OriChatBuddyTrip] = []
    private var selectedCategory: OriChatBuddyCategory?
    private var filterState = OriChatBuddyFilterState()
    private var sortOption = OriChatBuddySortOption.soonestFirst

    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private let searchField = UITextField()
    private let statsLabel = UILabel()
    private let emptyView = OriChatBuddyEmptyStateView()
    private let collectionView: UICollectionView
    private var collectionHeightConstraint: NSLayoutConstraint?
    private var emptyHeightConstraint: NSLayoutConstraint?
    private var chipButtons: [OriChatBuddyCategory: OriChatBuddyChipView] = [:]

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 18
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 24, right: 20)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        filterState = filterMemory.loadFilter()
        sortOption = filterMemory.loadSort()
        configureUI()
        reloadTrips()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        harborStore.reload()
        reloadTrips()
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 15 / 255, alpha: 1)
        view.addSubview(scrollView)
        scrollView.pinEdges(to: view.safeAreaLayoutGuide)
        scrollView.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        stack.addArrangedSubview(header())
        let hero = OriChatBuddyHeroHeaderView()
        hero.onAI = { [weak self] in self?.openWeb(entryName: "FishBuddy AI", route: .oriaFishbuddyAiExpert) }
        let heroWrap = padded(hero)
        stack.addArrangedSubview(heroWrap)
        stack.addArrangedSubview(searchAndFilter())
        stack.addArrangedSubview(chips())
        stack.addArrangedSubview(statsRow())

        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OriChatBuddyTripCardCell.self, forCellWithReuseIdentifier: OriChatBuddyTripCardCell.reuseIdentifier)
        stack.addArrangedSubview(collectionView)
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionHeightConstraint?.isActive = true

        emptyView.onCreate = { [weak self] in self?.createTapped() }
        emptyView.onReset = { [weak self] in
            self?.filterState = OriChatBuddyFilterState()
            self?.filterMemory.clearFilter()
            self?.reloadTrips()
        }
        stack.addArrangedSubview(emptyView)
        emptyHeightConstraint = emptyView.heightAnchor.constraint(equalToConstant: 1)
        emptyHeightConstraint?.isActive = true
    }

    private func header() -> UIView {
        let container = UIView()
        let title = UILabel()
        title.text = "Trip Detail"
        title.textColor = .white
        title.font = .systemFont(ofSize: 32, weight: .bold)
        let create = iconButton("square.and.pencil", action: #selector(createTapped))
        let notify = iconButton("bell", action: #selector(notifyTapped))
        [title, create, notify].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 48),
            title.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            notify.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            notify.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            notify.widthAnchor.constraint(equalToConstant: 42),
            notify.heightAnchor.constraint(equalToConstant: 42),
            create.trailingAnchor.constraint(equalTo: notify.leadingAnchor, constant: -10),
            create.centerYAnchor.constraint(equalTo: notify.centerYAnchor),
            create.widthAnchor.constraint(equalTo: notify.widthAnchor),
            create.heightAnchor.constraint(equalTo: notify.heightAnchor)
        ])
        return container
    }

    private func iconButton(_ symbol: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        button.layer.cornerRadius = 21
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func searchAndFilter() -> UIView {
        let container = UIView()
        searchField.placeholder = "Spot, fish, method, angler..."
        searchField.textColor = .white
        searchField.font = .systemFont(ofSize: 15)
        searchField.backgroundColor = UIColor(white: 0.12, alpha: 1)
        searchField.layer.cornerRadius = 22
        searchField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        searchField.leftViewMode = .always
        searchField.tintColor = .clear
        searchField.delegate = self
        let filterButton = iconButton("slider.horizontal.3", action: #selector(filterTapped))
        [searchField, filterButton].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 50),
            searchField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            searchField.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            searchField.heightAnchor.constraint(equalToConstant: 44),
            filterButton.leadingAnchor.constraint(equalTo: searchField.trailingAnchor, constant: 10),
            filterButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            filterButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 44),
            filterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        return container
    }

    private func chips() -> UIView {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        scroll.addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.heightAnchor.constraint(equalToConstant: 42),
            row.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            row.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            row.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            row.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            row.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor)
        ])
        let categories: [OriChatBuddyCategory] = [.nearby, .lure, .sea, .night, .fly]
        categories.forEach { category in
            let chip = OriChatBuddyChipView(title: category.rawValue)
            chip.addTarget(self, action: #selector(chipTapped(_:)), for: .touchUpInside)
            chipButtons[category] = chip
            row.addArrangedSubview(chip)
        }
        return scroll
    }

    private func statsRow() -> UIView {
        let container = UIView()
        statsLabel.textColor = UIColor.white.withAlphaComponent(0.74)
        statsLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        let sortButton = UIButton(type: .system)
        sortButton.setTitle(sortOption.rawValue, for: .normal)
        sortButton.setTitleColor(.white, for: .normal)
        sortButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        sortButton.addTarget(self, action: #selector(sortTapped), for: .touchUpInside)
        sortButton.tag = 301
        [statsLabel, sortButton].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 30),
            statsLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            statsLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            sortButton.centerYAnchor.constraint(equalTo: statsLabel.centerYAnchor)
        ])
        return container
    }

    private func padded(_ view: UIView) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: wrapper.topAnchor),
            view.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -20),
            view.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        return wrapper
    }

    private func reloadTrips() {
        let next = filterEngine.apply(trips: harborStore.trips, filter: filterState, sort: sortOption, query: nil, category: selectedCategory)
        trips = next
        statsLabel.text = "\(next.filter { $0.status == .recruiting }.count) trips recruiting"
        if next.isEmpty {
            let filtered = filterState.isEmpty == false || selectedCategory != nil
            statsLabel.text = "No buddy cards yet"
            emptyView.configure(filtered: filtered)
            emptyView.isHidden = false
            emptyHeightConstraint?.constant = 282
            collectionHeightConstraint?.constant = 1
        } else {
            emptyView.isHidden = true
            emptyHeightConstraint?.constant = 1
            collectionHeightConstraint?.constant = max(1, CGFloat(next.count) * 398)
        }
        collectionView.reloadData()
        (view.viewWithTag(301) as? UIButton)?.setTitle(sortOption.rawValue, for: .normal)
    }

    private func mutate(_ trip: OriChatBuddyTrip, toast: String? = nil) {
        harborStore.upsert(trip)
        reloadTrips()
        if let toast { Toast.show(toast, in: self) }
    }

    @objc private func chipTapped(_ sender: OriChatBuddyChipView) {
        guard let match = chipButtons.first(where: { $0.value == sender })?.key else { return }
        selectedCategory = selectedCategory == match ? nil : match
        chipButtons.forEach { $0.value.isChipSelected = $0.key == selectedCategory }
        reloadTrips()
    }

    @objc private func filterTapped() {
        let sheet = OriChatBuddyFilterSheetController(currentState: filterState, availableTrips: harborStore.trips, selectedCategory: selectedCategory)
        sheet.onApply = { [weak self] state in
            self?.filterState = state
            self?.filterMemory.saveFilter(state)
            self?.reloadTrips()
        }
        sheet.onReset = { [weak self] in
            self?.filterState = OriChatBuddyFilterState()
            self?.filterMemory.clearFilter()
        }
        present(sheet, animated: true)
    }

    @objc private func sortTapped() {
        let sheet = OriChatBuddySortSheetController(current: sortOption)
        sheet.onSelect = { [weak self] option in
            self?.sortOption = option
            self?.filterMemory.saveSort(option)
            self?.reloadTrips()
        }
        present(sheet, animated: true)
    }

    @objc private func createTapped() {
        let create = OriChatBuddyCreateController()
        create.onCreate = { [weak self] trip in
            self?.harborStore.upsert(trip)
            self?.reloadTrips()
        }
        navigationController?.pushViewController(create, animated: true)
    }

    @objc private func notifyTapped() {
        let messages = OriChatBuddyMessageListController()
        messages.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(messages, animated: true)
    }

    private func openWeb(entryName: String, route: OriaTravelrouteWebRoute) {
        guard let url = route.oriaTravelrouteFinalURL() else {
            print("[OriChat][Click] \(entryName) route=\(route) invalid URL")
            return
        }
        print("[OriChat][Click] entry=\(entryName) route=\(route) oriaTravelrouteFinalURL=\(mask(url.absoluteString))")
        let web = OriaSdkconnectPortalController(url: url)
        web.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(web, animated: true)
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
}

extension OriChatBuddyBoardController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let search = OriChatBuddySearchController(store: harborStore)
        search.onTripUpdate = { [weak self] trip in
            self?.harborStore.upsert(trip)
            self?.reloadTrips()
        }
        navigationController?.pushViewController(search, animated: true)
        return false
    }
}

extension OriChatBuddyBoardController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { trips.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trip = trips[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OriChatBuddyTripCardCell.reuseIdentifier, for: indexPath) as! OriChatBuddyTripCardCell
        cell.configure(with: trip)
        cell.onOpen = { [weak self] in self?.openDetail(trip) }
        cell.onMore = { [weak self] in self?.showMore(for: trip) }
        cell.onApply = { [weak self] in self?.apply(to: trip) }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 40, height: 380)
    }

    private func openDetail(_ trip: OriChatBuddyTrip) {
        let detail = OriChatBuddyDetailController(trip: trip)
        detail.onUpdate = { [weak self] updated in self?.mutate(updated) }
        navigationController?.pushViewController(detail, animated: true)
    }

    private func apply(to trip: OriChatBuddyTrip) {
        var next = trip
        guard next.status != .canceled && next.status != .draft else {
            openDetail(trip)
            return
        }
        let current = OriChatBuddyFixtureForge.currentAngler
        if next.status == .joined {
            openDetail(trip)
            return
        }
        if next.openSpots > 0 {
            if next.attendeeIds.contains(current.id) == false {
                next.attendeeIds.append(current.id)
                next.attendees.append(current)
            }
            next.status = .joined
            mutate(next, toast: "You're in!")
        } else {
            if next.waitlistIds.contains(current.id) == false { next.waitlistIds.append(current.id) }
            next.status = .waitlist
            mutate(next, toast: "You're on the waitlist.")
        }
    }

    private func showMore(for trip: OriChatBuddyTrip) {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Report Trip", style: .destructive, handler: { [weak self] _ in
            var next = trip
            next.isReported = true
            self?.mutate(next, toast: "Thanks, we'll review this trip.")
        }))
        alert.addAction(UIAlertAction(title: "Hide This Trip", style: .default, handler: { [weak self] _ in
            var next = trip
            next.isHidden = true
            self?.mutate(next)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
