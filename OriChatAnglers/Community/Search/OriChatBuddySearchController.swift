import UIKit

final class OriChatBuddySearchController: UIViewController {
    var onTripUpdate: ((OriChatBuddyTrip) -> Void)?

    private let store: OriChatBuddyHarborStore
    private let viewModel: OriChatBuddySearchViewModel
    private let searchField = UITextField()
    private let clearButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let suggestionsScroll = UIScrollView()
    private let suggestionsStack = UIStackView()
    private let resultHeader = UILabel()
    private let emptyStack = UIStackView()
    private let collectionView: UICollectionView
    private var debounceWorkItem: DispatchWorkItem?

    init(store: OriChatBuddyHarborStore) {
        self.store = store
        self.viewModel = OriChatBuddySearchViewModel(store: store)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 20, bottom: 28, right: 20)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureKeyboard()
        render()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        store.reload()
        viewModel.refresh()
        render()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchField.becomeFirstResponder()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        debounceWorkItem?.cancel()
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 15 / 255, alpha: 1)

        let searchWrap = UIView()
        searchWrap.backgroundColor = UIColor(red: 18 / 255, green: 18 / 255, blue: 24 / 255, alpha: 1)
        searchWrap.layer.cornerRadius = 12
        searchWrap.layer.borderWidth = 1
        searchWrap.layer.borderColor = UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 1).cgColor

        let magnifier = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        magnifier.tintColor = UIColor.white.withAlphaComponent(0.58)
        magnifier.contentMode = .scaleAspectFit

        searchField.attributedPlaceholder = NSAttributedString(
            string: "Spot, fish, method, angler...",
            attributes: [.foregroundColor: UIColor(red: 141 / 255, green: 141 / 255, blue: 152 / 255, alpha: 1)]
        )
        searchField.textColor = .white
        searchField.tintColor = UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 1)
        searchField.font = .systemFont(ofSize: 15, weight: .medium)
        searchField.returnKeyType = .search
        searchField.autocorrectionType = .no
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(textChanged), for: .editingChanged)

        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = UIColor.white.withAlphaComponent(0.48)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)

        [magnifier, searchField, clearButton].forEach {
            searchWrap.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        let topRow = UIView()
        topRow.addSubview(searchWrap)
        topRow.addSubview(cancelButton)
        searchWrap.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        suggestionsScroll.keyboardDismissMode = .onDrag
        suggestionsScroll.addSubview(suggestionsStack)
        suggestionsStack.axis = .vertical
        suggestionsStack.spacing = 28
        suggestionsStack.translatesAutoresizingMaskIntoConstraints = false

        resultHeader.textColor = .white
        resultHeader.font = .systemFont(ofSize: 16, weight: .bold)

        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OriChatBuddySearchResultCell.self, forCellWithReuseIdentifier: OriChatBuddySearchResultCell.reuseIdentifier)

        emptyStack.axis = .vertical
        emptyStack.spacing = 18
        emptyStack.alignment = .center

        [topRow, suggestionsScroll, resultHeader, collectionView, emptyStack].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            topRow.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topRow.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topRow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topRow.heightAnchor.constraint(equalToConstant: 48),
            searchWrap.leadingAnchor.constraint(equalTo: topRow.leadingAnchor, constant: 20),
            searchWrap.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            searchWrap.heightAnchor.constraint(equalToConstant: 44),
            cancelButton.leadingAnchor.constraint(equalTo: searchWrap.trailingAnchor, constant: 12),
            cancelButton.trailingAnchor.constraint(equalTo: topRow.trailingAnchor, constant: -18),
            cancelButton.centerYAnchor.constraint(equalTo: searchWrap.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 58),
            magnifier.leadingAnchor.constraint(equalTo: searchWrap.leadingAnchor, constant: 13),
            magnifier.centerYAnchor.constraint(equalTo: searchWrap.centerYAnchor),
            magnifier.widthAnchor.constraint(equalToConstant: 18),
            magnifier.heightAnchor.constraint(equalToConstant: 18),
            searchField.leadingAnchor.constraint(equalTo: magnifier.trailingAnchor, constant: 9),
            searchField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -8),
            searchField.topAnchor.constraint(equalTo: searchWrap.topAnchor),
            searchField.bottomAnchor.constraint(equalTo: searchWrap.bottomAnchor),
            clearButton.trailingAnchor.constraint(equalTo: searchWrap.trailingAnchor, constant: -10),
            clearButton.centerYAnchor.constraint(equalTo: searchWrap.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 24),
            clearButton.heightAnchor.constraint(equalToConstant: 24),
            suggestionsScroll.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 18),
            suggestionsScroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestionsScroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            suggestionsScroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            suggestionsStack.topAnchor.constraint(equalTo: suggestionsScroll.contentLayoutGuide.topAnchor, constant: 6),
            suggestionsStack.leadingAnchor.constraint(equalTo: suggestionsScroll.contentLayoutGuide.leadingAnchor),
            suggestionsStack.trailingAnchor.constraint(equalTo: suggestionsScroll.contentLayoutGuide.trailingAnchor),
            suggestionsStack.bottomAnchor.constraint(equalTo: suggestionsScroll.contentLayoutGuide.bottomAnchor, constant: -30),
            suggestionsStack.widthAnchor.constraint(equalTo: suggestionsScroll.frameLayoutGuide.widthAnchor),
            resultHeader.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 24),
            resultHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: resultHeader.bottomAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            emptyStack.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 92),
            emptyStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func configureKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func render() {
        clearButton.isHidden = viewModel.query.isEmpty
        switch viewModel.state {
        case .idle, .showingSuggestions:
            suggestionsScroll.isHidden = false
            resultHeader.isHidden = true
            collectionView.isHidden = true
            emptyStack.isHidden = true
            renderSuggestions()
        case let .showingResults(query, count):
            suggestionsScroll.isHidden = true
            resultHeader.isHidden = false
            collectionView.isHidden = false
            emptyStack.isHidden = true
            resultHeader.text = "\(count) \(count == 1 ? "result" : "results") for \"\(query)\""
            collectionView.reloadData()
        case let .empty(query):
            suggestionsScroll.isHidden = true
            resultHeader.isHidden = true
            collectionView.isHidden = true
            emptyStack.isHidden = false
            renderEmpty(query: query)
        }
    }

    private func renderSuggestions() {
        suggestionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        suggestionsStack.addArrangedSubview(section(title: "Recent", actionTitle: "Clear", action: #selector(clearRecentTapped), terms: viewModel.recentTerms(), symbol: nil))
        suggestionsStack.addArrangedSubview(section(title: "Popular near you", actionTitle: nil, action: nil, terms: viewModel.popularTerms, symbol: "fish"))
    }

    private func renderEmpty(query: String) {
        emptyStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let title = UILabel()
        title.text = "No trips found for \"\(query)\""
        title.textColor = .white
        title.font = .systemFont(ofSize: 19, weight: .bold)
        title.textAlignment = .center
        title.numberOfLines = 0
        let subtitle = UILabel()
        subtitle.text = "Try another spot, fish, method, or angler."
        subtitle.textColor = UIColor(red: 141 / 255, green: 141 / 255, blue: 152 / 255, alpha: 1)
        subtitle.font = .systemFont(ofSize: 14, weight: .medium)
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
        emptyStack.addArrangedSubview(title)
        emptyStack.addArrangedSubview(subtitle)
        emptyStack.addArrangedSubview(chipWrap(terms: viewModel.emptySuggestions, symbol: nil))
    }

    private func section(title: String, actionTitle: String?, action: Selector?, terms: [String], symbol: String?) -> UIView {
        let container = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        container.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20)
        ]

        if let actionTitle, let action {
            let button = UIButton(type: .system)
            button.setTitle(actionTitle, for: .normal)
            button.setTitleColor(UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 1), for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.addTarget(self, action: action, for: .touchUpInside)
            container.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(contentsOf: [
                button.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
                button.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
        }

        let chips = chipWrap(terms: terms, symbol: symbol)
        container.addSubview(chips)
        chips.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(contentsOf: [
            chips.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            chips.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            chips.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            chips.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        NSLayoutConstraint.activate(constraints)
        return container
    }

    private func chipWrap(terms: [String], symbol: String?) -> UIView {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        scroll.addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.heightAnchor.constraint(equalToConstant: 40),
            row.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            row.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            row.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            row.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            row.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor)
        ])
        terms.forEach { term in
            let chip = OriChatBuddySearchChipView(title: term, symbol: symbol)
            chip.addTarget(self, action: #selector(chipTapped(_:)), for: .touchUpInside)
            row.addArrangedSubview(chip)
        }
        return scroll
    }

    private func setQuery(_ query: String, saveRecent: Bool) {
        searchField.text = query
        viewModel.setQuery(query)
        if saveRecent { viewModel.recordCurrentQuery() }
        render()
    }

    @objc private func textChanged() {
        let nextText = searchField.text ?? ""
        debounceWorkItem?.cancel()
        let work = DispatchWorkItem { [weak self] in
            self?.viewModel.setQuery(nextText)
            self?.render()
        }
        debounceWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: work)
    }

    @objc private func chipTapped(_ sender: OriChatBuddySearchChipView) {
        let term = sender.title(for: .normal) ?? ""
        setQuery(term, saveRecent: true)
    }

    @objc private func clearTapped() {
        setQuery("", saveRecent: false)
        searchField.becomeFirstResponder()
    }

    @objc private func clearRecentTapped() {
        viewModel.clearRecent()
        render()
    }

    @objc private func cancelTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func backgroundTapped() {
        view.endEditing(true)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let endFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let overlap = max(0, view.bounds.maxY - endFrame.minY)
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: overlap + 18, right: 0)
        suggestionsScroll.contentInset = inset
        suggestionsScroll.scrollIndicatorInsets = inset
        collectionView.contentInset = inset
        collectionView.scrollIndicatorInsets = inset
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0)
        suggestionsScroll.contentInset = inset
        suggestionsScroll.scrollIndicatorInsets = inset
        collectionView.contentInset = inset
        collectionView.scrollIndicatorInsets = inset
    }
}

extension OriChatBuddySearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.setQuery(textField.text ?? "")
        viewModel.recordCurrentQuery()
        render()
        textField.resignFirstResponder()
        return true
    }
}

extension OriChatBuddySearchController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.matches.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OriChatBuddySearchResultCell.reuseIdentifier, for: indexPath) as! OriChatBuddySearchResultCell
        cell.configure(with: viewModel.matches[indexPath.item].trip)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let trip = viewModel.matches[indexPath.item].trip
        viewModel.recordCurrentQuery()
        let detail = OriChatBuddyDetailController(trip: trip)
        detail.onUpdate = { [weak self] updated in
            self?.store.upsert(updated)
            self?.onTripUpdate?(updated)
        }
        navigationController?.pushViewController(detail, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width - 40, height: 102)
    }
}
