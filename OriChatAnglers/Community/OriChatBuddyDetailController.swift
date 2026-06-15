import UIKit
import MapKit

final class OriChatBuddyDetailController: UIViewController {
    var onUpdate: ((OriChatBuddyTrip) -> Void)?
    var onPreviewPublish: (() -> Void)?

    private var trip: OriChatBuddyTrip
    private let previewActions: Bool
    private let scrollView = UIScrollView()
    private let stack = UIStackView()
    private let saveButton = UIButton(type: .system)
    private let actionButton = GradientButton(type: .system)

    init(trip: OriChatBuddyTrip, previewActions: Bool = false) {
        self.trip = trip
        self.previewActions = previewActions
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        render()
    }

    private func configureUI() {
        view.backgroundColor = UIColor(red: 13 / 255, green: 13 / 255, blue: 15 / 255, alpha: 1)
        view.addSubview(scrollView)
        view.addSubview(actionButton)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -14),
            actionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            actionButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)

        scrollView.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -18),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func render() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        stack.addArrangedSubview(hero())
        stack.addArrangedSubview(padded(organizerCard()))
        stack.addArrangedSubview(padded(infoGrid()))
        stack.addArrangedSubview(padded(addressCard()))
        stack.addArrangedSubview(padded(textSection("About this trip", trip.aboutText, chips: trip.tags.map { "#\($0)" })))
        stack.addArrangedSubview(padded(textSection("Good to know", trip.goodToKnow.joined(separator: "\n"), chips: [])))
        stack.addArrangedSubview(padded(attendeesView()))
        updateActionButton()
    }

    private func hero() -> UIView {
        let container = UIView()
        let image = UIImageView(image: UIImage(named: trip.coverAssetName))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.78).cgColor]
        gradient.locations = [0.45, 1]
        let shade = UIView()
        shade.layer.addSublayer(gradient)
        shade.layoutSubviewsCallback { gradient.frame=shade.bounds }

        let back = roundButton("chevron.left", #selector(backTapped))
        let share = roundButton("square.and.arrow.up", #selector(shareTapped))
        saveButton.setImage(UIImage(systemName: trip.isSaved ? "bookmark.fill" : "bookmark"), for: .normal)
        saveButton.tintColor = trip.isSaved ? AppConstants.accentColor : .white
        saveButton.backgroundColor = UIColor.black.withAlphaComponent(0.44)
        saveButton.layer.cornerRadius = 20
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        let more = roundButton("ellipsis", #selector(moreTapped))

        let tag = capsule("\(trip.category.rawValue)  ·  \(statusText())", color: trip.status == .recruiting ? UIColor(red: 75 / 255, green: 201 / 255, blue: 170 / 255, alpha: 1) : AppConstants.accentColor)
        let title = UILabel()
        title.text = trip.title
        title.textColor = .white
        title.font = .systemFont(ofSize: 28, weight: .bold)
        title.numberOfLines = 2

        [image, shade, back, share, saveButton, more, tag, title].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 390),
            image.topAnchor.constraint(equalTo: container.topAnchor),
            image.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            shade.topAnchor.constraint(equalTo: image.topAnchor),
            shade.leadingAnchor.constraint(equalTo: image.leadingAnchor),
            shade.trailingAnchor.constraint(equalTo: image.trailingAnchor),
            shade.bottomAnchor.constraint(equalTo: image.bottomAnchor),
            back.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 14),
            back.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 18),
            back.widthAnchor.constraint(equalToConstant: 40),
            back.heightAnchor.constraint(equalToConstant: 40),
            more.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -18),
            more.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            more.widthAnchor.constraint(equalTo: back.widthAnchor),
            more.heightAnchor.constraint(equalTo: back.heightAnchor),
            saveButton.trailingAnchor.constraint(equalTo: more.leadingAnchor, constant: -10),
            saveButton.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            saveButton.widthAnchor.constraint(equalTo: back.widthAnchor),
            saveButton.heightAnchor.constraint(equalTo: back.heightAnchor),
            share.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -10),
            share.centerYAnchor.constraint(equalTo: back.centerYAnchor),
            share.widthAnchor.constraint(equalTo: back.widthAnchor),
            share.heightAnchor.constraint(equalTo: back.heightAnchor),
            tag.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            tag.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -12),
            title.leadingAnchor.constraint(equalTo: tag.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            title.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -28)
        ])
        return container
    }

    private func roundButton(_ symbol: String, _ action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: symbol), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.44)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    private func capsule(_ text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = "  \(text)  "
        label.textColor = .black
        label.backgroundColor = color
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.layer.cornerRadius = 13
        label.clipsToBounds = true
        label.heightAnchor.constraint(equalToConstant: 26).isActive = true
        return label
    }

    private func organizerCard() -> UIView {
        let card = cardView()
        let avatar = UIImageView(image: UIImage(named: trip.organizer.avatarAssetName))
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.layer.cornerRadius = 24
        let name = UILabel()
        name.text = "\(trip.organizer.name) · Verified"
        name.textColor = .white
        name.font = .systemFont(ofSize: 17, weight: .bold)
        let detail = UILabel()
        detail.text = "Organizer · \(trip.organizer.location) · replies ~10 min"
        detail.textColor = UIColor.white.withAlphaComponent(0.58)
        detail.font = .systemFont(ofSize: 13)
        let stats = UILabel()
        stats.text = String(format: "Reliability %.1f     No-show 2%%     Trips %d", trip.organizer.rating, trip.organizer.trips)
        stats.textColor = UIColor.white.withAlphaComponent(0.74)
        stats.font = .systemFont(ofSize: 12, weight: .semibold)
        [avatar, name, detail, stats].forEach {
            card.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            avatar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            avatar.widthAnchor.constraint(equalToConstant: 48),
            avatar.heightAnchor.constraint(equalToConstant: 48),
            name.topAnchor.constraint(equalTo: avatar.topAnchor),
            name.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 12),
            name.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            detail.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            detail.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            detail.trailingAnchor.constraint(equalTo: name.trailingAnchor),
            stats.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 14),
            stats.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stats.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stats.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(organizerTapped)))
        return card
    }

    private func infoGrid() -> UIView {
        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 10
        let row1 = UIStackView()
        let row2 = UIStackView()
        [row1, row2].forEach {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
            grid.addArrangedSubview($0)
        }
        let when = OriChatBuddyInfoTileView(title: "WHEN")
        when.configure(value: trip.dateText, subtitle: "\(trip.startTimeText) – \(trip.endTimeText)")
        let anglers = OriChatBuddyInfoTileView(title: "ANGLERS")
        anglers.configure(value: "\(trip.joinedCount) / \(trip.capacity)", subtitle: "\(trip.openSpots) spots left")
        let cost = OriChatBuddyInfoTileView(title: "COST")
        cost.configure(value: trip.costTitle, subtitle: trip.costSubtitle)
        let target = OriChatBuddyInfoTileView(title: "TARGET")
        target.configure(value: trip.targetFish, subtitle: trip.skillText)
        [when, anglers].forEach { row1.addArrangedSubview($0) }
        [cost, target].forEach { row2.addArrangedSubview($0) }
        return grid
    }

    private func addressCard() -> UIView {
        let card = textSection(trip.locationTitle, "\(trip.locationSubtitle) · \(trip.distanceText)", chips: [])
        card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addressTapped)))
        return card
    }

    private func textSection(_ title: String, _ body: String, chips: [String]) -> UIView {
        let card = cardView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        let bodyLabel = UILabel()
        bodyLabel.text = body
        bodyLabel.textColor = UIColor.white.withAlphaComponent(0.68)
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 0
        let chipLabel = UILabel()
        chipLabel.text = chips.joined(separator: "  ")
        chipLabel.textColor = AppConstants.accentColor
        chipLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        chipLabel.numberOfLines = 0
        let inner = UIStackView(arrangedSubviews: chips.isEmpty ? [titleLabel, bodyLabel] : [titleLabel, bodyLabel, chipLabel])
        inner.axis = .vertical
        inner.spacing = 10
        card.addSubview(inner)
        inner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inner.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            inner.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            inner.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            inner.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        return card
    }

    private func attendeesView() -> UIView {
        let card = cardView()
        let title = UILabel()
        title.text = "Who's going"
        title.textColor = .white
        title.font = .systemFont(ofSize: 18, weight: .bold)
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 12
        for angler in trip.attendees.prefix(trip.capacity) {
            row.addArrangedSubview(attendee(name: angler.name, asset: angler.avatarAssetName, host: angler.id == trip.organizer.id))
        }
        if trip.openSpots > 0 {
            row.addArrangedSubview(openSpot())
        }
        [title, row].forEach {
            card.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            row.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 14),
            row.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            row.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -16),
            row.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        return card
    }

    private func attendee(name: String, asset: String, host: Bool) -> UIView {
        let image = UIImageView(image: UIImage(named: asset))
        image.layer.cornerRadius = 24
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        let label = UILabel()
        label.text = host ? "Host" : name
        label.textColor = UIColor.white.withAlphaComponent(0.62)
        label.font = .systemFont(ofSize: 11)
        label.textAlignment = .center
        let stack = UIStackView(arrangedSubviews: [image, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 6
        image.widthAnchor.constraint(equalToConstant: 48).isActive = true
        image.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return stack
    }

    private func openSpot() -> UIView {
        let label = UILabel()
        label.text = "+\nOpen"
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 2
        label.layer.cornerRadius = 24
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.withAlphaComponent(0.32).cgColor
        label.widthAnchor.constraint(equalToConstant: 48).isActive = true
        label.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return label
    }

    private func cardView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 28 / 255, green: 28 / 255, blue: 38 / 255, alpha: 1)
        view.layer.cornerRadius = 20
        return view
    }

    private func padded(_ view: UIView) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: wrapper.topAnchor),
            view.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor, constant: 20),
            view.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor, constant: -20),
            view.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor)
        ])
        return wrapper
    }

    private func updateActionButton() {
        switch trip.status {
        case .recruiting:
            actionButton.setTitle("Apply to join", for: .normal)
        case .joined:
            actionButton.setTitle("Joined", for: .normal)
        case .full:
            actionButton.setTitle("Join waitlist · \(trip.waitlistIds.count + 1) ahead", for: .normal)
        case .waitlist:
            let position = (trip.waitlistIds.firstIndex(of: OriChatBuddyFixtureForge.currentAngler.id) ?? trip.waitlistIds.count) + 1
            actionButton.setTitle("On waitlist · position \(position)", for: .normal)
        case .canceled:
            actionButton.setTitle("Trip canceled", for: .normal)
        case .draft:
            actionButton.setTitle(previewActions ? "Publish trip" : "Draft preview", for: .normal)
        }
    }

    private func statusText() -> String {
        switch trip.status {
        case .recruiting: return "Recruiting"
        case .joined: return "Joined"
        case .full: return "Full"
        case .waitlist: return "Waitlist"
        case .canceled: return "Canceled"
        case .draft: return "Draft"
        }
    }

    private func commit(_ toast: String? = nil) {
        onUpdate?(trip)
        render()
        if let toast { Toast.show(toast, in: self) }
    }

    @objc private func actionTapped() {
        if previewActions {
            onPreviewPublish?()
            return
        }
        let current = OriChatBuddyFixtureForge.currentAngler
        switch trip.status {
        case .recruiting:
            if trip.openSpots > 0 {
                if trip.attendeeIds.contains(current.id) == false {
                    trip.attendeeIds.append(current.id)
                    trip.attendees.append(current)
                }
                trip.status = .joined
                commit("You're in! Trip saved to your buddy list.")
            }
        case .joined:
            let alert = UIAlertController(title: "Leave this trip?", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { [weak self] _ in
                guard let self else { return }
                self.trip.attendeeIds.removeAll { $0 == current.id }
                self.trip.attendees.removeAll { $0.id == current.id }
                self.trip.status = self.trip.openSpots == 0 ? .full : .recruiting
                self.commit()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
        case .full:
            if trip.waitlistIds.contains(current.id) == false { trip.waitlistIds.append(current.id) }
            trip.status = .waitlist
            commit("You're on the waitlist.")
        case .waitlist:
            Toast.show("You're on the waitlist.", in: self)
        case .canceled:
            Toast.show("This trip has been canceled.", in: self)
        case .draft:
            Toast.show("This is a preview.", in: self)
        }
    }

    @objc private func saveTapped() {
        trip.isSaved.toggle()
        commit(trip.isSaved ? "Saved to your buddy list." : "Removed from saved trips.")
    }

    @objc private func shareTapped() {
        let text = "Join me on OriChat: \(trip.title) at \(trip.locationTitle)."
        present(UIActivityViewController(activityItems: [text], applicationActivities: nil), animated: true)
    }

    @objc private func moreTapped() {
        let alert = UIAlertController(title: "More", message: nil, preferredStyle: .actionSheet)
        if trip.isCreatedByCurrentUser || trip.organizer.id == OriChatBuddyFixtureForge.currentAngler.id {
            alert.addAction(UIAlertAction(title: "Edit trip", style: .default, handler: { [weak self] _ in
                guard let self else { return }
                let edit = OriChatBuddyEditController(trip: self.trip)
                edit.onSave = { [weak self] updated in
                    self?.trip = updated
                    self?.commit("Trip updated.")
                }
                edit.onCanceled = { [weak self] canceled in
                    self?.trip = canceled
                    self?.commit()
                }
                self.navigationController?.pushViewController(edit, animated: true)
            }))
        }
        alert.addAction(UIAlertAction(title: "Report", style: .destructive, handler: { [weak self] _ in
            self?.trip.isReported = true
            self?.commit("Thanks, we'll review this trip.")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func organizerTapped() {
        let profile = OriChatTrustUserProfile(
            userId: trip.organizer.id,
            name: trip.organizer.name,
            avatarURL: nil,
            avatarAssetName: trip.organizer.avatarAssetName,
            location: trip.organizer.location,
            brief: trip.organizer.brief,
            isVerified: trip.organizer.isVerified,
            averageReplyMinutes: 10
        )
        let controller = OriChatTrustProfileController(
            mode: .angler(userId: trip.organizer.id),
            buddyStore: OriChatBuddyHarborStore(),
            localProfile: profile
        )
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func addressTapped() {
        let alert = UIAlertController(title: trip.locationTitle, message: trip.locationSubtitle, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Copy Location", style: .default, handler: { [weak self] _ in
            UIPasteboard.general.string = self?.trip.locationTitle
        }))
        alert.addAction(UIAlertAction(title: "Open in Maps", style: .default, handler: { _ in
            MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 45.5, longitude: -122.6))).openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

private final class CallbackView: UIView {
    var callback: (() -> Void)?
    override func layoutSubviews() {
        super.layoutSubviews()
        callback?()
    }
}

private extension UIView {
    func layoutSubviewsCallback(_ callback: @escaping () -> Void) {
        let view = CallbackView(frame: bounds)
        view.callback = callback
        view.isUserInteractionEnabled = false
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
