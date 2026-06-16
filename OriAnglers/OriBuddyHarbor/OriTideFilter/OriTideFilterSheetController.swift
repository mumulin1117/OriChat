import UIKit

final class OriChatBuddyFilterSheetController: UIViewController {
    var onApply: ((OriChatBuddyFilterState) -> Void)?
    var onReset: (() -> Void)?

    private var state: OriChatBuddyFilterState
    private let availableTrips: [OriChatBuddyTrip]
    private let selectedCategory: OriChatBuddyCategory?
    private let engine = OriChatBuddyFilterEngine()
    private let stack = UIStackView()
    private let showButton = GradientButton(type: .system)
    private var chips: [UIControl: () -> Void] = [:]

    init(currentState: OriChatBuddyFilterState, availableTrips: [OriChatBuddyTrip], selectedCategory: OriChatBuddyCategory?) {
        self.state = currentState
        self.availableTrips = availableTrips
        self.selectedCategory = selectedCategory
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
        if let sheetPresentationController {
            sheetPresentationController.detents = [.large()]
            sheetPresentationController.prefersGrabberVisible = true
            sheetPresentationController.preferredCornerRadius = 24
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        render()
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 17 / 255, alpha: 1)

        let header = UIView()
        let title = UILabel()
        title.text = "Filters"
        title.textColor = .white
        title.font = .systemFont(ofSize: 24, weight: .bold)
        let reset = UIButton(type: .system)
        reset.setTitle("Reset", for: .normal)
        reset.setTitleColor(UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 1), for: .normal)
        reset.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        reset.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        [title, reset].forEach {
            header.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: 52),
            title.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            reset.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -20),
            reset.centerYAnchor.constraint(equalTo: title.centerYAnchor)
        ])

        let scroll = UIScrollView()
        scroll.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 26
        stack.translatesAutoresizingMaskIntoConstraints = false

        let bottom = UIView()
        bottom.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 17 / 255, alpha: 0.96)
        let cancel = UIButton(type: .system)
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(.white, for: .normal)
        cancel.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        cancel.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        cancel.layer.cornerRadius = 25
        cancel.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        showButton.setTitle("Show results", for: .normal)
        showButton.addTarget(self, action: #selector(showTapped), for: .touchUpInside)
        [cancel, showButton].forEach {
            bottom.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [header, scroll, bottom].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: header.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: bottom.topAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40),
            bottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottom.heightAnchor.constraint(equalToConstant: 96),
            cancel.leadingAnchor.constraint(equalTo: bottom.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancel.topAnchor.constraint(equalTo: bottom.topAnchor, constant: 14),
            cancel.widthAnchor.constraint(equalToConstant: 118),
            cancel.heightAnchor.constraint(equalToConstant: 50),
            showButton.leadingAnchor.constraint(equalTo: cancel.trailingAnchor, constant: 12),
            showButton.trailingAnchor.constraint(equalTo: bottom.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            showButton.centerYAnchor.constraint(equalTo: cancel.centerYAnchor),
            showButton.heightAnchor.constraint(equalTo: cancel.heightAnchor)
        ])
    }

    private func render() {
        chips.removeAll()
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stack.addArrangedSubview(section("When", OriChatBuddyWhenFilter.allCases.map(\.rawValue), selected: { state.when?.rawValue == $0 }) { [weak self] title in
            guard let self, let item = OriChatBuddyWhenFilter(rawValue: title) else { return }
            state.when = state.when == item ? nil : item
            render()
        })
        stack.addArrangedSubview(section("Method", OriChatBuddyMethod.allCases.map(\.rawValue), selected: { state.methods.contains(OriChatBuddyMethod(rawValue: $0)!) }) { [weak self] title in
            guard let self, let item = OriChatBuddyMethod(rawValue: title) else { return }
            toggle(item, in: &state.methods)
            render()
        })
        stack.addArrangedSubview(section("Group size", OriChatBuddyGroupSize.allCases.map(\.rawValue), selected: { state.groupSize?.rawValue == $0 }) { [weak self] title in
            guard let self, let item = OriChatBuddyGroupSize(rawValue: title) else { return }
            state.groupSize = state.groupSize == item ? nil : item
            render()
        })
        stack.addArrangedSubview(section("Cost", OriChatBuddyCostFilter.allCases.map(\.rawValue), selected: { state.costs.contains(OriChatBuddyCostFilter(rawValue: $0)!) }) { [weak self] title in
            guard let self, let item = OriChatBuddyCostFilter(rawValue: title) else { return }
            toggle(item, in: &state.costs)
            render()
        })
        stack.addArrangedSubview(section("Experience", OriChatBuddyExperienceFilter.allCases.map(\.rawValue), selected: { state.experiences.contains(OriChatBuddyExperienceFilter(rawValue: $0)!) }) { [weak self] title in
            guard let self, let item = OriChatBuddyExperienceFilter(rawValue: title) else { return }
            toggle(item, in: &state.experiences)
            render()
        })
        stack.addArrangedSubview(section("Trust", OriChatBuddyTrustFilter.allCases.map(\.rawValue), selected: { state.trusts.contains(OriChatBuddyTrustFilter(rawValue: $0)!) }) { [weak self] title in
            guard let self, let item = OriChatBuddyTrustFilter(rawValue: title) else { return }
            toggle(item, in: &state.trusts)
            render()
        })
        updateShowButton()
    }

    private func section(_ title: String, _ items: [String], selected: (String) -> Bool, action: @escaping (String) -> Void) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        container.addArrangedSubview(label)
        let rows = UIStackView()
        rows.axis = .vertical
        rows.spacing = 10
        var row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        row.alignment = .leading
        rows.addArrangedSubview(row)
        items.enumerated().forEach { index, item in
            if index > 0 && index % 2 == 0 {
                row = UIStackView()
                row.axis = .horizontal
                row.spacing = 10
                row.alignment = .leading
                rows.addArrangedSubview(row)
            }
            let chip = OriChatBuddyFilterChipView(title: item)
            chip.configure(title: item, isSelected: selected(item))
            chip.addTarget(self, action: #selector(chipTapped(_:)), for: .touchUpInside)
            chips[chip] = { action(item) }
            row.addArrangedSubview(chip)
        }
        container.addArrangedSubview(rows)
        return container
    }

    private func toggle<T: Hashable>(_ item: T, in set: inout Set<T>) {
        if set.contains(item) { set.remove(item) } else { set.insert(item) }
    }

    private func updateShowButton() {
        let count = engine.resultCount(trips: availableTrips, filter: state, category: selectedCategory)
        showButton.setTitle("Show results · \(count)", for: .normal)
    }

    @objc private func chipTapped(_ sender: UIControl) {
        chips[sender]?()
    }

    @objc private func resetTapped() {
        state = OriChatBuddyFilterState()
        onReset?()
        render()
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func showTapped() {
        onApply?(state)
        dismiss(animated: true)
    }
}
