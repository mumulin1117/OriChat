import UIKit

final class OriChatBuddyFilterSheet: UIViewController {
    var onApply: ((OriChatBuddyFilter) -> Void)?

    private var filter: OriChatBuddyFilter
    private let skillControl = UISegmentedControl(items: ["Any", "Beginner", "Experienced"])
    private let statusControl = UISegmentedControl(items: ["Any", "Recruiting", "Joined", "Full", "Waitlist"])
    private let costControl = UISegmentedControl(items: ["Any", "Free", "AA"])
    private let openSwitch = UISwitch()
    private let nearbySwitch = UISwitch()

    init(filter: OriChatBuddyFilter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
        if let sheetPresentationController {
            sheetPresentationController.detents = [.medium()]
            sheetPresentationController.prefersGrabberVisible = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        applyInitialValues()
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 18 / 255, green: 18 / 255, blue: 23 / 255, alpha: 1)
        let title = UILabel()
        title.text = "Filter trips"
        title.textColor = .white
        title.font = .systemFont(ofSize: 22, weight: .bold)

        [skillControl, statusControl, costControl].forEach {
            $0.selectedSegmentTintColor = .white
            $0.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            $0.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        }

        let stack = UIStackView(arrangedSubviews: [
            title,
            label("Skill"), skillControl,
            label("Status"), statusControl,
            label("Cost"), costControl,
            switchRow("Has open spots only", openSwitch),
            switchRow("Nearby first", nearbySwitch),
            buttonRow()
        ])
        stack.axis = .vertical
        stack.spacing = 14
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    private func applyInitialValues() {
        skillControl.selectedSegmentIndex = filter.skill == "Beginner friendly" ? 1 : filter.skill == "Experienced only" ? 2 : 0
        switch filter.status {
        case .recruiting: statusControl.selectedSegmentIndex = 1
        case .joined: statusControl.selectedSegmentIndex = 2
        case .full: statusControl.selectedSegmentIndex = 3
        case .waitlist: statusControl.selectedSegmentIndex = 4
        case .canceled, .draft: statusControl.selectedSegmentIndex = 0
        case nil: statusControl.selectedSegmentIndex = 0
        }
        costControl.selectedSegmentIndex = filter.cost == "Free" ? 1 : filter.cost == "AA" ? 2 : 0
        openSwitch.isOn = filter.openOnly
        nearbySwitch.isOn = filter.nearbyFirst
    }

    private func label(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.white.withAlphaComponent(0.70)
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        return label
    }

    private func switchRow(_ title: String, _ control: UISwitch) -> UIView {
        let label = label(title)
        let row = UIStackView(arrangedSubviews: [label, control])
        row.axis = .horizontal
        row.alignment = .center
        row.distribution = .equalSpacing
        return row
    }

    private func buttonRow() -> UIView {
        let reset = UIButton(type: .system)
        reset.setTitle("Reset", for: .normal)
        reset.setTitleColor(.white, for: .normal)
        reset.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        reset.layer.cornerRadius = 22
        reset.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)

        let apply = UIButton(type: .system)
        apply.setTitle("Apply Filters", for: .normal)
        apply.setTitleColor(.white, for: .normal)
        apply.backgroundColor = AppConstants.accentColor
        apply.layer.cornerRadius = 22
        apply.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)

        let row = UIStackView(arrangedSubviews: [reset, apply])
        row.axis = .horizontal
        row.spacing = 12
        row.distribution = .fillEqually
        [reset, apply].forEach { $0.heightAnchor.constraint(equalToConstant: 44).isActive = true }
        return row
    }

    @objc private func resetTapped() {
        onApply?(OriChatBuddyFilter())
        dismiss(animated: true)
    }

    @objc private func applyTapped() {
        var next = OriChatBuddyFilter()
        next.skill = skillControl.selectedSegmentIndex == 1 ? "Beginner friendly" : skillControl.selectedSegmentIndex == 2 ? "Experienced only" : nil
        next.status = [nil, .recruiting, .joined, .full, .waitlist][statusControl.selectedSegmentIndex]
        next.cost = costControl.selectedSegmentIndex == 1 ? "Free" : costControl.selectedSegmentIndex == 2 ? "AA" : nil
        next.openOnly = openSwitch.isOn
        next.nearbyFirst = nearbySwitch.isOn
        onApply?(next)
        dismiss(animated: true)
    }
}
