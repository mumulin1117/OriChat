import UIKit

final class OriChatCatchRecordCardView: UIView {
    var onAction: ((OriChatCatchProfileRecord) -> Void)?
    private let avatarView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statusLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    private var record: OriChatCatchProfileRecord?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(record: OriChatCatchProfileRecord) {
        self.record = record
        avatarView.image = AppAsset.buddyImage(named: record.avatarAssetName, fallback: AppAsset.buddyAvatarGuest01)
        titleLabel.text = record.title
        subtitleLabel.text = record.subtitle
        statusLabel.text = "  \(record.statusText)  "
        actionButton.setTitle(record.action.rawValue, for: .normal)
        configure(status: record.statusKind)
    }

    private func configureUI() {
        backgroundColor = UIColor(red: 29 / 255, green: 29 / 255, blue: 36 / 255, alpha: 1)
        layer.cornerRadius = 14
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.06).cgColor
        avatarView.contentMode = .scaleAspectFill
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 20
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 13, weight: .heavy)
        titleLabel.numberOfLines = 2
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.48)
        subtitleLabel.font = .systemFont(ofSize: 11, weight: .medium)
        statusLabel.font = .systemFont(ofSize: 10, weight: .bold)
        statusLabel.layer.cornerRadius = 9
        statusLabel.clipsToBounds = true
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        actionButton.backgroundColor = AppConstants.accentColor
        actionButton.layer.cornerRadius = 12
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, statusLabel])
        textStack.axis = .vertical
        textStack.spacing = 5
        textStack.alignment = .leading
        let row = UIStackView(arrangedSubviews: [avatarView, textStack, actionButton])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 10
        addSubview(row)
        row.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 42),
            avatarView.heightAnchor.constraint(equalToConstant: 42),
            actionButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 58),
            actionButton.heightAnchor.constraint(equalToConstant: 34),
            row.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    private func configure(status: OriChatCatchProfileStatusKind) {
        switch status {
        case .recruiting:
            statusLabel.backgroundColor = UIColor(red: 35 / 255, green: 126 / 255, blue: 92 / 255, alpha: 0.38)
            statusLabel.textColor = UIColor(red: 74 / 255, green: 213 / 255, blue: 159 / 255, alpha: 1)
        case .pending:
            statusLabel.backgroundColor = UIColor(red: 128 / 255, green: 89 / 255, blue: 31 / 255, alpha: 0.45)
            statusLabel.textColor = UIColor(red: 238 / 255, green: 177 / 255, blue: 88 / 255, alpha: 1)
        case .upcoming:
            statusLabel.backgroundColor = UIColor(red: 40 / 255, green: 131 / 255, blue: 102 / 255, alpha: 0.42)
            statusLabel.textColor = UIColor(red: 89 / 255, green: 232 / 255, blue: 185 / 255, alpha: 1)
        case .rateBuddies:
            statusLabel.backgroundColor = UIColor(red: 133 / 255, green: 46 / 255, blue: 93 / 255, alpha: 0.46)
            statusLabel.textColor = UIColor(red: 255 / 255, green: 122 / 255, blue: 189 / 255, alpha: 1)
        case .completed:
            statusLabel.backgroundColor = UIColor.white.withAlphaComponent(0.12)
            statusLabel.textColor = UIColor.white.withAlphaComponent(0.68)
        case .canceled:
            statusLabel.backgroundColor = UIColor(red: 109 / 255, green: 45 / 255, blue: 45 / 255, alpha: 0.42)
            statusLabel.textColor = UIColor(red: 255 / 255, green: 132 / 255, blue: 132 / 255, alpha: 1)
        }
        actionButton.backgroundColor = status == .completed ? UIColor.white.withAlphaComponent(0.1) : AppConstants.accentColor
    }

    @objc private func actionTapped() {
        guard let record else { return }
        onAction?(record)
    }
}

final class OriChatCatchProfileEmptyView: UIView {
    var onCreate: (() -> Void)?

    init(message: String, showsCreate: Bool) {
        super.init(frame: .zero)
        configureUI(message: message, showsCreate: showsCreate)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI(message: String, showsCreate: Bool) {
        let addButton = UIButton(type: .system)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = UIColor.white.withAlphaComponent(0.5)
        addButton.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        addButton.layer.cornerRadius = 16
        addButton.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        let title = UILabel()
        title.text = showsCreate ? "Post another trip" : "No records yet"
        title.textColor = .white
        title.font = .systemFont(ofSize: 14, weight: .bold)
        title.textAlignment = .center
        let body = UILabel()
        body.text = message
        body.textColor = UIColor.white.withAlphaComponent(0.55)
        body.font = .systemFont(ofSize: 12)
        body.numberOfLines = 0
        body.textAlignment = .center
        let create = UIButton(type: .system)
        create.setTitle(showsCreate ? "Create a trip" : "Explore trips", for: .normal)
        create.setTitleColor(.white, for: .normal)
        create.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        create.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        create.layer.cornerRadius = 12
        create.isHidden = showsCreate == false
        create.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [addButton, title, body, create])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 9
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 48),
            addButton.heightAnchor.constraint(equalToConstant: 48),
            create.widthAnchor.constraint(greaterThanOrEqualToConstant: 112),
            create.heightAnchor.constraint(equalToConstant: 38),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    @objc private func createTapped() {
        onCreate?()
    }
}
