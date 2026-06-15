import UIKit

final class OriChatBuddyPublishedController: UIViewController {
    var onUpdate: ((OriChatBuddyTrip) -> Void)?
    private var trip: OriChatBuddyTrip

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
        let checkWrap = UIView()
        checkWrap.backgroundColor = AppConstants.accentColor
        checkWrap.layer.cornerRadius = 42
        let check = UIImageView(image: UIImage(systemName: "checkmark"))
        check.tintColor = .white
        checkWrap.addSubview(check)
        check.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            check.centerXAnchor.constraint(equalTo: checkWrap.centerXAnchor),
            check.centerYAnchor.constraint(equalTo: checkWrap.centerYAnchor),
            check.widthAnchor.constraint(equalToConstant: 34),
            check.heightAnchor.constraint(equalToConstant: 34),
            checkWrap.widthAnchor.constraint(equalToConstant: 84),
            checkWrap.heightAnchor.constraint(equalTo: checkWrap.widthAnchor)
        ])
        let title = label("Your card is live", 28, .bold, .white)
        title.textAlignment = .center
        let subtitle = label("Anglers can now find and apply to your trip. We'll notify you when applications arrive.", 15, .medium, UIColor.white.withAlphaComponent(0.62))
        subtitle.textAlignment = .center
        subtitle.numberOfLines = 0
        let manage = GradientButton(type: .system)
        manage.setTitle("Manage applicants", for: .normal)
        manage.addTarget(self, action: #selector(manageTapped), for: .touchUpInside)
        let share = secondary("Share", #selector(shareTapped))
        let market = secondary("Market", #selector(marketTapped))
        let stack = UIStackView(arrangedSubviews: [checkWrap, title, subtitle, manage, share, market])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 18
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            manage.widthAnchor.constraint(equalTo: stack.widthAnchor),
            manage.heightAnchor.constraint(equalToConstant: 52),
            share.widthAnchor.constraint(equalTo: stack.widthAnchor),
            share.heightAnchor.constraint(equalToConstant: 48),
            market.widthAnchor.constraint(equalTo: stack.widthAnchor),
            market.heightAnchor.constraint(equalToConstant: 48)
        ])
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

    private func label(_ text: String, _ size: CGFloat, _ weight: UIFont.Weight, _ color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }

    @objc private func manageTapped() {
        let applicants = UIAlertController(title: "Applicants", message: "Noah, Mason, and Ava are interested.", preferredStyle: .actionSheet)
        let localApplicants = [
            OriChatBuddyAngler(id: "noah", name: "Noah", avatarAssetName: AppAsset.buddyAvatarNoah, location: "Pine Dock", brief: "Night fly fan.", rating: 4.6, pigeonRate: 4, trips: 19, isVerified: true),
            OriChatBuddyAngler(id: "mason", name: "Mason", avatarAssetName: AppAsset.buddyAvatarMason, location: "Blue Lake", brief: "Patient bass angler.", rating: 4.7, pigeonRate: 3, trips: 28, isVerified: true),
            OriChatBuddyAngler(id: "ava", name: "Ava", avatarAssetName: AppAsset.buddyAvatarAva, location: "Harbor West", brief: "Pier fishing organizer.", rating: 4.9, pigeonRate: 2, trips: 37, isVerified: true)
        ]
        localApplicants.forEach { applicant in
            applicants.addAction(UIAlertAction(title: "Approve \(applicant.name)", style: .default, handler: { [weak self] _ in
                guard let self else { return }
                if self.trip.attendeeIds.contains(applicant.id) == false && self.trip.openSpots > 0 {
                    self.trip.attendeeIds.append(applicant.id)
                    self.trip.attendees.append(applicant)
                    self.trip.applicantIds.removeAll { $0 == applicant.id }
                    self.onUpdate?(self.trip)
                }
                Toast.show("Applicant approved locally.", in: self)
            }))
        }
        ["Decline Noah", "Decline Mason", "Decline Ava"].forEach { title in
            applicants.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
                guard let self else { return }
                Toast.show("Applicant declined locally.", in: self)
            }))
        }
        applicants.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(applicants, animated: true)
    }

    @objc private func shareTapped() {
        present(UIActivityViewController(activityItems: ["Join my OriChat fishing trip: \(trip.title)."], applicationActivities: nil), animated: true)
    }

    @objc private func marketTapped() {
        Toast.show("Promotion tools are coming soon.", in: self)
    }
}
