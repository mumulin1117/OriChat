import UIKit

final class OriChatBuddyCreateController: UIViewController {
    var onCreate: ((OriChatBuddyTrip) -> Void)?

    private let draftLedger = OriChatBuddyDraftLedger()
    private var draft: OriChatBuddyTripDraft
    private var isDraftPromptPending = true
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private let titleField = UITextField()
    private let targetField = UITextField()
    private let spotField = UITextField()
    private let subtitleField = UITextField()
    private let aboutField = UITextField()
    private let goodField = UITextField()
    private let errorLabel = UILabel()
    private let dateButton = UIButton(type: .system)
    private let stepper: OriChatBuddyStepperRowView
    private let carpoolSwitch = UISwitch()
    private let chatSwitch = UISwitch()
    private let verifiedSwitch = UISwitch()
    private var methodChips: [OriChatBuddyMethod: OriChatBuddyOptionChipView] = [:]
    private var costChips: [OriChatBuddyCostFilter: OriChatBuddyOptionChipView] = [:]
    private var experienceChips: [OriChatBuddyExperienceFilter: OriChatBuddyOptionChipView] = [:]
    private var tagChips: [String: OriChatBuddyOptionChipView] = [:]

    init(prefill: OriChatBuddyTripDraft? = nil) {
        self.draft = prefill ?? OriChatBuddyTripDraft()
        self.stepper = OriChatBuddyStepperRowView(value: self.draft.capacity)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        applyDraft(draft)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isDraftPromptPending, let saved = draftLedger.load() else { return }
        isDraftPromptPending = false
        let alert = UIAlertController(title: "Continue your saved draft?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Start new", style: .destructive, handler: { [weak self] _ in
            self?.draftLedger.clear()
        }))
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] _ in
            self?.draft = saved
            self?.applyDraft(saved)
        }))
        present(alert, animated: true)
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 15 / 255, alpha: 1)
        let close = topButton("xmark")
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        let saveDraft = UIButton(type: .system)
        saveDraft.setTitle("Save draft", for: .normal)
        saveDraft.setTitleColor(.white, for: .normal)
        saveDraft.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        saveDraft.addTarget(self, action: #selector(saveDraftTapped), for: .touchUpInside)
        let title = UILabel()
        title.text = "Create buddy card"
        title.textColor = .white
        title.font = .systemFont(ofSize: 27, weight: .bold)

        let bottom = UIView()
        bottom.backgroundColor = view.backgroundColor
        let preview = UIButton(type: .system)
        preview.setTitle("Preview", for: .normal)
        preview.setTitleColor(.white, for: .normal)
        preview.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        preview.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        preview.layer.cornerRadius = 25
        preview.addTarget(self, action: #selector(previewTapped), for: .touchUpInside)
        let publish = GradientButton(type: .system)
        publish.setTitle("Publish trip", for: .normal)
        publish.addTarget(self, action: #selector(publishTapped), for: .touchUpInside)

        [close, saveDraft, title, scrollView, bottom].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [preview, publish].forEach {
            bottom.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            close.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            close.widthAnchor.constraint(equalToConstant: 42),
            close.heightAnchor.constraint(equalTo: close.widthAnchor),
            saveDraft.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveDraft.centerYAnchor.constraint(equalTo: close.centerYAnchor),
            title.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottom.topAnchor),
            bottom.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottom.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottom.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottom.heightAnchor.constraint(equalToConstant: 92),
            preview.leadingAnchor.constraint(equalTo: bottom.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            preview.topAnchor.constraint(equalTo: bottom.topAnchor, constant: 12),
            preview.widthAnchor.constraint(equalToConstant: 118),
            preview.heightAnchor.constraint(equalToConstant: 50),
            publish.leadingAnchor.constraint(equalTo: preview.trailingAnchor, constant: 12),
            publish.trailingAnchor.constraint(equalTo: bottom.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            publish.centerYAnchor.constraint(equalTo: preview.centerYAnchor),
            publish.heightAnchor.constraint(equalTo: preview.heightAnchor)
        ])

        scrollView.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])
        buildForm()
    }

    private func buildForm() {
        errorLabel.textColor = UIColor(red: 255 / 255, green: 77 / 255, blue: 94 / 255, alpha: 1)
        errorLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        stack.addArrangedSubview(fieldCard("Trip title", titleField, "Sunday lure & coffee at the reservoir"))
        stack.addArrangedSubview(errorLabel)
        stack.addArrangedSubview(chipSection("Method", OriChatBuddyMethod.allCases.map(\.rawValue)) { [weak self] title in
            guard let self, let method = OriChatBuddyMethod(rawValue: title) else { return }
            draft.method = method
            syncChips()
        })
        stack.addArrangedSubview(doubleCard())
        stack.addArrangedSubview(fieldCard("Target fish", targetField, "Bass"))
        stack.addArrangedSubview(fieldCard("Spot details", subtitleField, "Meet by the north parking lot"))
        stack.addArrangedSubview(stepperCard())
        stack.addArrangedSubview(chipSection("Cost", OriChatBuddyCostFilter.allCases.map(\.rawValue)) { [weak self] title in
            guard let self, let cost = OriChatBuddyCostFilter(rawValue: title) else { return }
            draft.cost = cost
            syncChips()
        })
        stack.addArrangedSubview(chipSection("Experience", ["Beginner friendly", "Some experience", "Experienced only"]) { [weak self] title in
            guard let self else { return }
            draft.experience = title == "Experienced only" ? .experienced : title == "Some experience" ? .knowsSpot : .beginner
            syncChips()
        })
        stack.addArrangedSubview(chipSection("Tags", ["Weekend", "Lure", "Quiet trip", "Carpool", "Beginner", "Gear share", "Night", "Female friendly"]) { [weak self] title in
            guard let self else { return }
            if draft.tags.contains(title) { draft.tags.removeAll { $0 == title } } else { draft.tags.append(title) }
            syncChips()
        })
        stack.addArrangedSubview(toggleRow("Carpool available", carpoolSwitch))
        stack.addArrangedSubview(toggleRow("Open a temporary group chat", chatSwitch))
        stack.addArrangedSubview(toggleRow("Verified anglers only", verifiedSwitch))
        stack.addArrangedSubview(fieldCard("About", aboutField, "A relaxed local fishing plan for reliable anglers."))
        stack.addArrangedSubview(fieldCard("Good to know", goodField, "Bring water, hat, and a small tackle box."))
    }

    private func applyDraft(_ draft: OriChatBuddyTripDraft) {
        titleField.text = draft.title
        spotField.text = draft.locationTitle
        subtitleField.text = draft.locationSubtitle
        targetField.text = draft.targetFish
        aboutField.text = draft.aboutText
        goodField.text = draft.goodToKnow
        stepper.setValue(draft.capacity)
        carpoolSwitch.isOn = draft.isCarpoolAvailable
        chatSwitch.isOn = draft.opensTemporaryChat
        verifiedSwitch.isOn = draft.verifiedOnly
        updateDateButton()
        syncChips()
    }

    private func collectDraft() -> OriChatBuddyTripDraft {
        draft.title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        draft.locationTitle = spotField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        draft.locationSubtitle = subtitleField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        draft.targetFish = targetField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        draft.aboutText = aboutField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        draft.goodToKnow = goodField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        draft.isCarpoolAvailable = carpoolSwitch.isOn
        draft.opensTemporaryChat = chatSwitch.isOn
        draft.verifiedOnly = verifiedSwitch.isOn
        return draft
    }

    private func validate() -> OriChatBuddyTripDraft? {
        let next = collectDraft()
        let message: String?
        if next.title.isEmpty { message = "Please enter a trip title." }
        else if next.title.count < 6 { message = "Trip title must be at least 6 characters." }
        else if next.title.count > 80 { message = "Trip title must be 80 characters or fewer." }
        else if next.locationTitle.isEmpty { message = "Please enter a spot." }
        else if next.capacity < 1 { message = "Group size must be at least 1." }
        else { message = nil }
        if let message {
            errorLabel.text = message
            errorLabel.isHidden = false
            titleField.layer.borderColor = UIColor(red: 255 / 255, green: 77 / 255, blue: 94 / 255, alpha: 1).cgColor
            titleField.layer.borderWidth = 1
            Toast.show(message, in: self)
            return nil
        }
        errorLabel.isHidden = true
        titleField.layer.borderWidth = 0
        if next.verifiedOnly { Toast.show("Only verified anglers will be able to apply.", in: self) }
        return next
    }

    private func fieldCard(_ title: String, _ field: UITextField, _ placeholder: String) -> UIView {
        let card = cardView()
        let label = sectionLabel(title)
        field.placeholder = placeholder
        field.textColor = .white
        field.font = .systemFont(ofSize: 15, weight: .medium)
        field.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        field.layer.cornerRadius = 13
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        field.leftViewMode = .always
        let inner = UIStackView(arrangedSubviews: [label, field])
        inner.axis = .vertical
        inner.spacing = 10
        card.addSubview(inner)
        inner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            inner.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            inner.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -14),
            inner.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14),
            field.heightAnchor.constraint(equalToConstant: 48)
        ])
        return card
    }

    private func chipSection(_ title: String, _ items: [String], action: @escaping (String) -> Void) -> UIView {
        let card = cardView()
        let label = sectionLabel(title)
        let wrap = UIStackView()
        wrap.axis = .vertical
        wrap.spacing = 10
        var row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        wrap.addArrangedSubview(row)
        items.enumerated().forEach { index, item in
            if index > 0 && index % 2 == 0 {
                row = UIStackView()
                row.axis = .horizontal
                row.spacing = 8
                wrap.addArrangedSubview(row)
            }
            let chip = OriChatBuddyOptionChipView(title: item)
            chip.addAction(UIAction { _ in action(item) }, for: .touchUpInside)
            row.addArrangedSubview(chip)
            if let method = OriChatBuddyMethod(rawValue: item) { methodChips[method] = chip }
            if let cost = OriChatBuddyCostFilter(rawValue: item) { costChips[cost] = chip }
            if item == "Beginner friendly" { experienceChips[.beginner] = chip }
            if item == "Some experience" { experienceChips[.knowsSpot] = chip }
            if item == "Experienced only" { experienceChips[.experienced] = chip }
            if title == "Tags" { tagChips[item] = chip }
        }
        let inner = UIStackView(arrangedSubviews: [label, wrap])
        inner.axis = .vertical
        inner.spacing = 12
        card.addSubview(inner)
        inner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            inner.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 14),
            inner.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -14),
            inner.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14)
        ])
        return card
    }

    private func doubleCard() -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 10
        row.distribution = .fillEqually
        dateButton.setTitleColor(.white, for: .normal)
        dateButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        dateButton.backgroundColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 36 / 255, alpha: 1)
        dateButton.layer.cornerRadius = 16
        dateButton.addTarget(self, action: #selector(dateTapped), for: .touchUpInside)
        spotField.placeholder = "Hagg reservoir"
        spotField.textColor = .white
        spotField.backgroundColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 36 / 255, alpha: 1)
        spotField.layer.cornerRadius = 16
        spotField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        spotField.leftViewMode = .always
        [dateButton, spotField].forEach {
            row.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 82).isActive = true
        }
        return row
    }

    private func stepperCard() -> UIView {
        let card = cardView()
        let label = sectionLabel("Group size")
        let value = UILabel()
        value.text = "\(draft.capacity) anglers total"
        value.textColor = UIColor.white.withAlphaComponent(0.62)
        value.font = .systemFont(ofSize: 13, weight: .semibold)
        stepper.onChange = { [weak self, weak value] count in
            self?.draft.capacity = count
            value?.text = "\(count) anglers total"
        }
        [label, value, stepper].forEach {
            card.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            value.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            value.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            value.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16),
            stepper.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stepper.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return card
    }

    private func toggleRow(_ title: String, _ toggle: UISwitch) -> UIView {
        let card = cardView()
        let label = sectionLabel(title)
        [label, toggle].forEach {
            card.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 58),
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return card
    }

    private func syncChips() {
        methodChips.forEach { $0.value.isSelected = $0.key == draft.method }
        costChips.forEach { $0.value.isSelected = $0.key == draft.cost }
        experienceChips.forEach { $0.value.isSelected = $0.key == draft.experience }
        tagChips.forEach { $0.value.isSelected = draft.tags.contains($0.key) }
    }

    private func updateDateButton() {
        let date = draft.startDate ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "'WHEN'\nEEE · MMM d, h:mm a"
        dateButton.setTitle(formatter.string(from: date), for: .normal)
        dateButton.titleLabel?.numberOfLines = 2
        dateButton.contentHorizontalAlignment = .left
        dateButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 10)
    }

    private func cardView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 26 / 255, green: 26 / 255, blue: 36 / 255, alpha: 1)
        view.layer.cornerRadius = 18
        return view
    }

    private func sectionLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }

    private func topButton(_ symbol: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        button.layer.cornerRadius = 21
        return button
    }

    @objc private func dateTapped() {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .wheels
        picker.date = draft.startDate ?? Date()
        let alert = UIAlertController(title: "Choose time", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(picker)
        picker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 8),
            picker.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -8),
            picker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 44),
            picker.heightAnchor.constraint(equalToConstant: 210)
        ])
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            self?.draft.startDate = picker.date
            self?.draft.endDate = picker.date.addingTimeInterval(7_200)
            self?.updateDateButton()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func saveDraftTapped() {
        draftLedger.save(collectDraft())
        Toast.show("Draft saved.", in: self)
    }

    @objc private func previewTapped() {
        guard let draft = validate() else { return }
        let preview = OriChatBuddyDetailController(trip: OriChatBuddyPublishFactory.trip(from: draft, id: "preview", status: .draft), previewActions: true)
        preview.onPreviewPublish = { [weak self] in self?.publish(draft) }
        navigationController?.pushViewController(preview, animated: true)
    }

    @objc private func publishTapped() {
        guard let draft = validate() else { return }
        publish(draft)
    }

    private func publish(_ draft: OriChatBuddyTripDraft) {
        let trip = OriChatBuddyPublishFactory.trip(from: draft)
        onCreate?(trip)
        draftLedger.clear()
        let published = OriChatBuddyPublishedController(trip: trip)
        published.onUpdate = { [weak self] updated in
            self?.onCreate?(updated)
        }
        navigationController?.pushViewController(published, animated: true)
    }

    @objc private func closeTapped() {
        navigationController?.popViewController(animated: true)
    }
}
