import UIKit

final class OriChatBuddyTripCanceledController: UIViewController {
    var onPostAgain: ((OriChatBuddyTripDraft) -> Void)?
    private let trip: OriChatBuddyTrip

    init(trip: OriChatBuddyTrip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 15 / 255, alpha: 1)
        let back = UIButton(type: .system)
        back.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        back.tintColor = .white
        back.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(back)
        back.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            back.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            back.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            back.widthAnchor.constraint(equalToConstant: 42),
            back.heightAnchor.constraint(equalTo: back.widthAnchor)
        ])
        let icon = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
        icon.tintColor = UIColor(red: 255 / 255, green: 77 / 255, blue: 94 / 255, alpha: 1)
        let title = label("Trip canceled", 28, .bold, .white)
        let subtitle = label("\(max(0, trip.joinedCount - 1)) angler was notified and the temporary group chat was closed.", 15, .medium, UIColor.white.withAlphaComponent(0.62))
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
        let close = secondary("Back", #selector(backTapped))
        let oriaApiintegratPost = GradientButton(type: .system)
        oriaApiintegratPost.setTitle("Post again", for: .normal)
        oriaApiintegratPost.addTarget(self, action: #selector(postAgainTapped), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [icon, title, subtitle, close, oriaApiintegratPost])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 18
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 72),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            close.widthAnchor.constraint(equalTo: stack.widthAnchor),
            close.heightAnchor.constraint(equalToConstant: 48),
            oriaApiintegratPost.widthAnchor.constraint(equalTo: stack.widthAnchor),
            oriaApiintegratPost.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func label(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }

    private func secondary(_ title: String, _ action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        button.layer.cornerRadius = 24
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    @objc private func backTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func postAgainTapped() {
        let draft = OriChatBuddyPublishFactory.draft(from: trip)
        OriChatBuddyDraftLedger().save(draft)
        onPostAgain?(draft)
    }
}
