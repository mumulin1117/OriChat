import UIKit

final class OriChatBuddyCancelSheetController: UIViewController {
    var onCancel: ((OriChatBuddyTrip) -> Void)?

    private var trip: OriChatBuddyTrip
    private var selectedReason: String?
    private let cancelButton = UIButton(type: .system)
    private var chips: [String: OriChatBuddyOptionChipView] = [:]

    init(trip: OriChatBuddyTrip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
        if let sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
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
        refresh()
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 18 / 255, green: 18 / 255, blue: 24 / 255, alpha: 1)
        let icon = UIImageView(image: UIImage(systemName: "flag.fill"))
        icon.tintColor = UIColor(red: 255 / 255, green: 77 / 255, blue: 94 / 255, alpha: 1)
        let title = label("Cancel this trip?", 23, .bold, .white)
        let subtitle = label("\(max(0, trip.joinedCount - 1)) angler will be notified and the group chat will close.", 14, .medium, UIColor.white.withAlphaComponent(0.62))
        subtitle.numberOfLines = 0
        let reason = label("Reason (shared with the group)", 14, .bold, .white)
        let chipWrap = UIStackView()
        chipWrap.axis = .vertical
        chipWrap.spacing = 10
        var row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        chipWrap.addArrangedSubview(row)
        ["Weather", "Can't make the time", "Not enough anglers", "Personal reasons", "Other"].enumerated().forEach { index, item in
            if index > 0 && index % 2 == 0 {
                row = UIStackView()
                row.axis = .horizontal
                row.spacing = 8
                chipWrap.addArrangedSubview(row)
            }
            let chip = OriChatBuddyOptionChipView(title: item)
            chip.addAction(UIAction { [weak self] _ in
                self?.selectedReason = item
                self?.refresh()
            }, for: .touchUpInside)
            chips[item] = chip
            row.addArrangedSubview(chip)
        }
        let keep = UIButton(type: .system)
        keep.setTitle("Keep trip", for: .normal)
        keep.setTitleColor(.white, for: .normal)
        keep.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        keep.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        keep.layer.cornerRadius = 24
        keep.addTarget(self, action: #selector(keepTapped), for: .touchUpInside)
        cancelButton.setTitle("Cancel trip", for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        cancelButton.layer.cornerRadius = 24
        cancelButton.addTarget(self, action: #selector(cancelTripTapped), for: .touchUpInside)
        let actions = UIStackView(arrangedSubviews: [keep, cancelButton])
        actions.axis = .horizontal
        actions.spacing = 12
        actions.distribution = .fillEqually
        let stack = UIStackView(arrangedSubviews: [icon, title, subtitle, reason, chipWrap, actions])
        stack.axis = .vertical
        stack.spacing = 15
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 34),
            icon.heightAnchor.constraint(equalToConstant: 34),
            actions.heightAnchor.constraint(equalToConstant: 50),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    private func refresh() {
        chips.forEach { $0.value.isSelected = $0.key == selectedReason }
        let enabled = selectedReason != nil
        cancelButton.isEnabled = enabled
        cancelButton.alpha = enabled ? 1 : 0.45
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = enabled ? UIColor(red: 255 / 255, green: 77 / 255, blue: 94 / 255, alpha: 1) : UIColor.white.withAlphaComponent(0.10)
    }

    private func label(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }

    @objc private func keepTapped() {
        dismiss(animated: true)
    }

    @objc private func cancelTripTapped() {
        guard let selectedReason else { return }
        trip.status = .canceled
        trip.cancelReason = selectedReason
        trip.canceledAt = Date()
        dismiss(animated: true) { [trip, onCancel] in onCancel?(trip) }
    }
}
