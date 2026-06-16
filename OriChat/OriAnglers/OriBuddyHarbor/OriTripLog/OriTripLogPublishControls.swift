import UIKit

final class OriChatBuddyOptionChipView: UIButton {
    override var isSelected: Bool {
        didSet { refresh() }
    }

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 13, weight: .bold)
        layer.cornerRadius = 18
        layer.borderWidth = 1
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14)
        refresh()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func refresh() {
        backgroundColor = isSelected ? UIColor(red: 246 / 255, green: 61 / 255, blue: 122 / 255, alpha: 0.22) : UIColor(red: 26 / 255, green: 26 / 255, blue: 36 / 255, alpha: 1)
        layer.borderColor = (isSelected ? AppConstants.accentColor : UIColor(red: 45 / 255, green: 45 / 255, blue: 57 / 255, alpha: 1)).cgColor
        setTitleColor(isSelected ? .white : UIColor.white.withAlphaComponent(0.70), for: .normal)
    }
}

final class OriChatBuddyStepperRowView: UIView {
    var onChange: ((Int) -> Void)?
    private let valueLabel = UILabel()
    private var value: Int
    private let minimum: Int

    init(value: Int, minimum: Int = 1) {
        self.value = value
        self.minimum = minimum
        super.init(frame: .zero)
        configureUI()
        refresh()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValue(_ next: Int) {
        value = max(minimum, min(8, next))
        refresh()
    }

    private func configureUI() {
        let minus = button("minus")
        let plus = button("plus")
        minus.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        plus.addTarget(self, action: #selector(increase), for: .touchUpInside)
        valueLabel.textColor = .white
        valueLabel.font = .systemFont(ofSize: 17, weight: .bold)
        valueLabel.textAlignment = .center
        [minus, valueLabel, plus].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 36),
            minus.leadingAnchor.constraint(equalTo: leadingAnchor),
            minus.centerYAnchor.constraint(equalTo: centerYAnchor),
            minus.widthAnchor.constraint(equalToConstant: 36),
            minus.heightAnchor.constraint(equalTo: minus.widthAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: minus.trailingAnchor, constant: 10),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 28),
            plus.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 10),
            plus.trailingAnchor.constraint(equalTo: trailingAnchor),
            plus.centerYAnchor.constraint(equalTo: centerYAnchor),
            plus.widthAnchor.constraint(equalTo: minus.widthAnchor),
            plus.heightAnchor.constraint(equalTo: minus.heightAnchor)
        ])
    }

    private func button(_ symbol: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        button.layer.cornerRadius = 18
        return button
    }

    private func refresh() {
        valueLabel.text = "\(value)"
        onChange?(value)
    }

    @objc private func decrease() { setValue(value - 1) }
    @objc private func increase() { setValue(value + 1) }
}
