import UIKit

final class OriChatCatchSegmentView: UIView {
    var onSelect: ((OriChatCatchProfileRecordTab) -> Void)?
    private var buttons: [OriChatCatchProfileRecordTab: UIButton] = [:]
    private var selectedTab: OriChatCatchProfileRecordTab = .myPosts

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func select(_ tab: OriChatCatchProfileRecordTab) {
        selectedTab = tab
        OriChatCatchProfileRecordTab.allCases.forEach { update(button: buttons[$0], selected: $0 == tab) }
    }

    private func configureUI() {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8
        row.distribution = .fillEqually
        addSubview(row)
        row.pinEdges(to: self)
        OriChatCatchProfileRecordTab.allCases.forEach { tab in
            let button = UIButton(type: .system)
            button.setTitle(tab.rawValue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
            button.layer.cornerRadius = 16
            button.addAction(UIAction { [weak self] _ in
                self?.selectedTab = tab
                self?.select(tab)
                self?.onSelect?(tab)
            }, for: .touchUpInside)
            buttons[tab] = button
            row.addArrangedSubview(button)
            update(button: button, selected: tab == selectedTab)
        }
        heightAnchor.constraint(equalToConstant: 34).isActive = true
    }

    private func update(button: UIButton?, selected: Bool) {
        button?.backgroundColor = selected ? .white : UIColor.white.withAlphaComponent(0.08)
        button?.setTitleColor(selected ? .black : UIColor.white.withAlphaComponent(0.72), for: .normal)
    }
}
