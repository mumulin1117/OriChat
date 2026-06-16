import UIKit

final class OriChatBuddyMessageListController: UIViewController {
    private let scrollView = UIScrollView()
    private let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .black
        navigationController?.setNavigationBarHidden(true, animated: false)

        view.addSubview(scrollView)
        scrollView.pinEdges(to: view.safeAreaLayoutGuide)
        scrollView.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 26
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            stack.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor, constant: -56)
        ])

        stack.addArrangedSubview(header())
        stack.addArrangedSubview(sectionTitle())
        stack.addArrangedSubview(notificationCard())
        stack.addArrangedSubview(emptyState())
    }

    private func header() -> UIView {
        let container = UIView()
        let back = UIButton(type: .system)
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .white
        back.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 38 / 255, alpha: 1)
        back.layer.cornerRadius = 29
        back.layer.borderWidth = 1
        back.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        let title = UILabel()
        title.text = "Chats"
        title.textColor = .white
        title.font = .systemFont(ofSize: 29, weight: .bold)

        [back, title].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 70),
            back.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            back.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            back.widthAnchor.constraint(equalToConstant: 58),
            back.heightAnchor.constraint(equalToConstant: 58),
            title.leadingAnchor.constraint(equalTo: back.trailingAnchor, constant: 16),
            title.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            title.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -24)
        ])
        return container
    }

    private func sectionTitle() -> UIView {
        let label = UILabel()
        label.text = "MESSAGES"
        label.textColor = UIColor.white.withAlphaComponent(0.48)
        label.font = .systemFont(ofSize: 17, weight: .heavy)
        label.letterSpacing(1.2)

        let container = UIView()
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 22),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }

    private func notificationCard() -> UIView {
        let card = UIControl()
        card.backgroundColor = .black
        card.layer.cornerRadius = 28
        card.layer.borderWidth = 1.5
        card.layer.borderColor = UIColor(red: 1, green: 64 / 255, blue: 126 / 255, alpha: 1).cgColor
        card.addTarget(self, action: #selector(notificationsTapped), for: .touchUpInside)

        let badge = UIView()
        badge.backgroundColor = UIColor(red: 239 / 255, green: 64 / 255, blue: 123 / 255, alpha: 1)
        badge.layer.cornerRadius = 48

        let bell = UIImageView(image: UIImage(systemName: "bell.fill"))
        bell.tintColor = .white
        bell.contentMode = .scaleAspectFit

        let title = UILabel()
        title.text = "Notifications"
        title.textColor = UIColor(red: 1, green: 64 / 255, blue: 126 / 255, alpha: 1)
        title.font = .systemFont(ofSize: 24, weight: .bold)

        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = UIColor(red: 1, green: 64 / 255, blue: 126 / 255, alpha: 1)
        arrow.contentMode = .scaleAspectFit

        [badge, title, arrow].forEach {
            card.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        badge.addSubview(bell)
        bell.translatesAutoresizingMaskIntoConstraints = false

        let wrapper = UIView()
        wrapper.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            wrapper.heightAnchor.constraint(equalToConstant: 146),
            card.topAnchor.constraint(equalTo: wrapper.topAnchor),
            card.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -24),
            card.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
            badge.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            badge.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            badge.widthAnchor.constraint(equalToConstant: 96),
            badge.heightAnchor.constraint(equalToConstant: 96),
            bell.centerXAnchor.constraint(equalTo: badge.centerXAnchor),
            bell.centerYAnchor.constraint(equalTo: badge.centerYAnchor),
            bell.widthAnchor.constraint(equalToConstant: 38),
            bell.heightAnchor.constraint(equalToConstant: 38),
            title.leadingAnchor.constraint(equalTo: badge.trailingAnchor, constant: 24),
            title.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            title.trailingAnchor.constraint(lessThanOrEqualTo: arrow.leadingAnchor, constant: -16),
            arrow.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -22),
            arrow.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 18),
            arrow.heightAnchor.constraint(equalToConstant: 24)
        ])
        return wrapper
    }

    private func emptyState() -> UIView {
        let container = UIView()
        let iconWrap = UIView()
        iconWrap.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        iconWrap.layer.cornerRadius = 32

        let icon = UIImageView(image: UIImage(systemName: "message.fill"))
        icon.tintColor = UIColor.white.withAlphaComponent(0.42)
        icon.contentMode = .scaleAspectFit

        let title = UILabel()
        title.text = "No friend messages yet"
        title.textColor = .white
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.textAlignment = .center

        let body = UILabel()
        body.text = "Private chats will appear here after you share a trip."
        body.textColor = UIColor.white.withAlphaComponent(0.45)
        body.font = .systemFont(ofSize: 15, weight: .medium)
        body.textAlignment = .center
        body.numberOfLines = 0

        let column = UIStackView(arrangedSubviews: [iconWrap, title, body])
        column.axis = .vertical
        column.alignment = .center
        column.spacing = 14

        iconWrap.addSubview(icon)
        container.addSubview(column)
        icon.translatesAutoresizingMaskIntoConstraints = false
        column.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 260),
            iconWrap.widthAnchor.constraint(equalToConstant: 64),
            iconWrap.heightAnchor.constraint(equalToConstant: 64),
            icon.centerXAnchor.constraint(equalTo: iconWrap.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: iconWrap.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 28),
            icon.heightAnchor.constraint(equalToConstant: 28),
            column.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            column.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            column.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 34),
            column.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -34),
            body.widthAnchor.constraint(lessThanOrEqualTo: container.widthAnchor, constant: -68)
        ])
        return container
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func notificationsTapped() {
        openWeb(entryName: "Buddy Message Notifications", route: .oriaSystemtideNotifications)
    }

    private func openWeb(entryName: String, route: OriaTravelrouteWebRoute) {
        guard let url = route.oriaTravelrouteFinalURL() else {
            print("[OriChat][Click] \(entryName) route=\(route) invalid URL")
            return
        }
        print("[OriChat][Click] entry=\(entryName) route=\(route) oriaTravelrouteFinalURL=\(mask(url.absoluteString))")
        let web = OriaSdkconnectPortalController(url: url)
        web.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(web, animated: true)
    }

    private func mask(_ text: String) -> String {
        guard let tokenRange = text.range(of: "token=") else { return text }
        let prefix = text[..<tokenRange.upperBound]
        let suffixStart = text[tokenRange.upperBound...].firstIndex(of: "&") ?? text.endIndex
        if tokenRange.upperBound == suffixStart {
            return "\(prefix)<missing>\(text[suffixStart...])"
        }
        return "\(prefix)***\(text[suffixStart...])"
    }
}

private extension UILabel {
    func letterSpacing(_ value: CGFloat) {
        guard let text else { return }
        attributedText = NSAttributedString(string: text, attributes: [.kern: value])
    }
}
