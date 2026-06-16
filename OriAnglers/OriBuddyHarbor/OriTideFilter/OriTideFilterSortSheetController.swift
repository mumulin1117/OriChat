import UIKit

final class OriChatBuddySortSheetController: UIViewController {
    var onSelect: ((OriChatBuddySortOption) -> Void)?

    private let current: OriChatBuddySortOption

    init(current: OriChatBuddySortOption) {
        self.current = current
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
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 18 / 255, green: 18 / 255, blue: 24 / 255, alpha: 1)
        let title = UILabel()
        title.text = "Sort by"
        title.textColor = .white
        title.font = .systemFont(ofSize: 22, weight: .bold)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.addArrangedSubview(title)
        OriChatBuddySortOption.allCases.forEach { option in
            stack.addArrangedSubview(row(option))
        }
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    private func row(_ option: OriChatBuddySortOption) -> UIControl {
        let control = UIControl()
        control.tag = OriChatBuddySortOption.allCases.firstIndex(of: option) ?? 0
        control.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
        let label = UILabel()
        label.text = option.rawValue
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        let check = UIImageView(image: UIImage(systemName: option == current ? "checkmark" : ""))
        check.tintColor = UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 1)
        [label, check].forEach {
            control.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            control.heightAnchor.constraint(equalToConstant: 52),
            label.leadingAnchor.constraint(equalTo: control.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: control.centerYAnchor),
            check.trailingAnchor.constraint(equalTo: control.trailingAnchor),
            check.centerYAnchor.constraint(equalTo: control.centerYAnchor),
            check.widthAnchor.constraint(equalToConstant: 18),
            check.heightAnchor.constraint(equalToConstant: 18)
        ])
        return control
    }

    @objc private func optionTapped(_ sender: UIControl) {
        let option = OriChatBuddySortOption.allCases[sender.tag]
        onSelect?(option)
        dismiss(animated: true)
    }
}
