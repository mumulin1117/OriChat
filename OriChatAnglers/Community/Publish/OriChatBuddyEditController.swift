import UIKit

final class OriChatBuddyEditController: UIViewController {
    var onSave: ((OriChatBuddyTrip) -> Void)?
    var onCanceled: ((OriChatBuddyTrip) -> Void)?

    private var trip: OriChatBuddyTrip
    private let titleField = UITextField()
    private let spotField = UITextField()
    private let aboutField = UITextField()
    private let goodField = UITextField()
    private let carpoolSwitch = UISwitch()
    private let stack = UIStackView()
    private let stepper: OriChatBuddyStepperRowView

    init(trip: OriChatBuddyTrip) {
        self.trip = trip
        self.stepper = OriChatBuddyStepperRowView(value: trip.capacity, minimum: max(1, trip.joinedCount))
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fill()
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 15 / 255, alpha: 1)
        let close = UIButton(type: .system)
        close.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        close.tintColor = .white
        close.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        let save = UIButton(type: .system)
        save.setTitle("Save", for: .normal)
        save.setTitleColor(.white, for: .normal)
        save.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        save.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        let title = UILabel()
        title.text = "Edit trip"
        title.textColor = .white
        title.font = .systemFont(ofSize: 28, weight: .bold)
        [close, save, title].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            close.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            close.widthAnchor.constraint(equalToConstant: 42),
            close.heightAnchor.constraint(equalTo: close.widthAnchor),
            save.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            save.centerYAnchor.constraint(equalTo: close.centerYAnchor),
            title.topAnchor.constraint(equalTo: close.bottomAnchor, constant: 12),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        let scroll = UIScrollView()
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        scroll.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -28),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
        stack.addArrangedSubview(field("Trip title", titleField))
        stack.addArrangedSubview(field("Spot", spotField))
        stack.addArrangedSubview(stepperRow())
        stack.addArrangedSubview(toggleRow("Carpool available", carpoolSwitch))
        stack.addArrangedSubview(field("About", aboutField))
        stack.addArrangedSubview(field("Good to know", goodField))
        stack.addArrangedSubview(danger())
    }

    private func fill() {
        titleField.text = trip.title
        spotField.text = trip.locationTitle
        aboutField.text = trip.aboutText
        goodField.text = trip.goodToKnow.first
        carpoolSwitch.isOn = trip.isCarpoolAvailable
        stepper.onChange = { [weak self] count in self?.trip.capacity = count }
    }

    private func field(_ title: String, _ input: UITextField) -> UIView {
        let label = UILabel()
        label.text = title
        label.textColor = UIColor.white.withAlphaComponent(0.68)
        label.font = .systemFont(ofSize: 13, weight: .bold)
        input.textColor = .white
        input.backgroundColor = UIColor.white.withAlphaComponent(0.09)
        input.layer.cornerRadius = 14
        input.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 1))
        input.leftViewMode = .always
        input.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let card = UIStackView(arrangedSubviews: [label, input])
        card.axis = .vertical
        card.spacing = 8
        return card
    }

    private func stepperRow() -> UIView {
        let label = UILabel()
        label.text = "Group size"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        let row = UIStackView(arrangedSubviews: [label, stepper])
        row.axis = .horizontal
        row.distribution = .equalSpacing
        row.alignment = .center
        return row
    }

    private func toggleRow(_ title: String, _ toggle: UISwitch) -> UIView {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .bold)
        let row = UIStackView(arrangedSubviews: [label, toggle])
        row.axis = .horizontal
        row.distribution = .equalSpacing
        row.alignment = .center
        return row
    }

    private func danger() -> UIView {
        let button = UIButton(type: .system)
        button.setTitle("Cancel this trip\nNotify everyone and close this group", for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.setTitleColor(UIColor(red: 255 / 255, green: 77 / 255, blue: 94 / 255, alpha: 1), for: .normal)
        button.backgroundColor = UIColor(red: 255 / 255, green: 77 / 255, blue: 94 / 255, alpha: 0.10)
        button.layer.cornerRadius = 18
        button.heightAnchor.constraint(equalToConstant: 72).isActive = true
        button.addTarget(self, action: #selector(cancelTripTapped), for: .touchUpInside)
        return button
    }

    @objc private func saveTapped() {
        trip.title = titleField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? titleField.text! : trip.title
        trip.locationTitle = spotField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false ? spotField.text! : trip.locationTitle
        trip.aboutText = aboutField.text ?? trip.aboutText
        trip.goodToKnow = [goodField.text ?? ""]
        trip.isCarpoolAvailable = carpoolSwitch.isOn
        onSave?(trip)
        Toast.show("Trip updated.", in: self)
        navigationController?.popViewController(animated: true)
    }

    @objc private func cancelTripTapped() {
        let sheet = OriChatBuddyCancelSheetController(trip: trip)
        sheet.onCancel = { [weak self] canceled in
            self?.trip = canceled
            self?.onCanceled?(canceled)
            let done = OriChatBuddyTripCanceledController(trip: canceled)
            done.onPostAgain = { [weak self] draft in
                let create = OriChatBuddyCreateController(prefill: draft)
                create.onCreate = { [weak self] trip in self?.onSave?(trip) }
                self?.navigationController?.pushViewController(create, animated: true)
            }
            self?.navigationController?.pushViewController(done, animated: true)
        }
        present(sheet, animated: true)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
