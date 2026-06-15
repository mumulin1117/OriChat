import Foundation

struct OriChatBuddyTripDraft: Codable {
    var title: String = ""
    var method: OriChatBuddyMethod = .lure
    var startDate: Date? = Date().addingTimeInterval(2 * 86_400)
    var endDate: Date? = Date().addingTimeInterval(2 * 86_400 + 7_200)
    var locationTitle: String = "Hagg reservoir"
    var locationSubtitle: String = "Meet by the north parking lot"
    var capacity: Int = 4
    var cost: OriChatBuddyCostFilter = .aa
    var experience: OriChatBuddyExperienceFilter = .beginner
    var tags: [String] = ["Weekend", "Lure", "Quiet trip", "Carpool", "Beginner", "Gear share"]
    var targetFish: String = "Bass"
    var aboutText: String = "A relaxed local fishing plan for reliable anglers."
    var goodToKnow: String = "Bring water, hat, and a small tackle box."
    var isCarpoolAvailable: Bool = true
    var opensTemporaryChat: Bool = true
    var verifiedOnly: Bool = false
}

final class OriChatBuddyDraftLedger {
    private let defaults: UserDefaults
    private let key = "OriChat.orichat.buddy.publish.draft.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> OriChatBuddyTripDraft? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(OriChatBuddyTripDraft.self, from: data)
    }

    func save(_ draft: OriChatBuddyTripDraft) {
        guard let data = try? JSONEncoder().encode(draft) else { return }
        defaults.set(data, forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}

enum OriChatBuddyPublishFactory {
    static func trip(from draft: OriChatBuddyTripDraft, id: String = "created-\(UUID().uuidString)", status: OriChatBuddyTripStatus = .recruiting) -> OriChatBuddyTrip {
        let host = OriChatBuddyFixtureForge.currentAngler
        let start = draft.startDate ?? Date().addingTimeInterval(2 * 86_400)
        let end = draft.endDate ?? start.addingTimeInterval(7_200)
        let category = category(for: draft.method)
        let tagSet = Array(Set(draft.tags + [draft.method.rawValue, draft.cost.rawValue, draft.experience.rawValue]))
        return OriChatBuddyTrip(
            id: id,
            title: draft.title.isEmpty ? "Sunday lure & coffee at the reservoir" : draft.title,
            category: category,
            status: status,
            coverAssetName: AppAsset.buddyCoverDockMorning,
            dateText: dateFormatter.string(from: start),
            startTimeText: timeFormatter.string(from: start),
            endTimeText: timeFormatter.string(from: end),
            locationTitle: draft.locationTitle.isEmpty ? "Hagg reservoir" : draft.locationTitle,
            locationSubtitle: draft.locationSubtitle.isEmpty ? "Meet by the north parking lot" : draft.locationSubtitle,
            distanceText: "Nearby",
            distanceValue: 1.4,
            startDate: start,
            createdAt: Date(),
            capacity: draft.capacity,
            attendeeIds: [host.id],
            waitlistIds: [],
            costTitle: costTitle(draft.cost),
            costSubtitle: costSubtitle(draft.cost),
            targetFish: draft.targetFish.isEmpty ? "Bass" : draft.targetFish,
            skillText: experienceTitle(draft.experience),
            gearNote: draft.isCarpoolAvailable ? "Carpool available. Bring your favorite lure." : "Bring your favorite lure.",
            aboutText: draft.aboutText,
            goodToKnow: [draft.goodToKnow],
            tags: tagSet,
            organizer: host,
            attendees: [host],
            isSaved: true,
            isHidden: false,
            isReported: false,
            isCreatedByCurrentUser: true,
            isCarpoolAvailable: draft.isCarpoolAvailable,
            opensTemporaryChat: draft.opensTemporaryChat,
            verifiedOnly: draft.verifiedOnly,
            applicantIds: ["noah", "mason", "ava"]
        )
    }

    static func draft(from trip: OriChatBuddyTrip) -> OriChatBuddyTripDraft {
        OriChatBuddyTripDraft(
            title: trip.title,
            method: method(for: trip.category),
            startDate: trip.startDate,
            endDate: trip.startDate.addingTimeInterval(7_200),
            locationTitle: trip.locationTitle,
            locationSubtitle: trip.locationSubtitle,
            capacity: trip.capacity,
            cost: cost(for: trip.costTitle),
            experience: experience(for: trip.skillText),
            tags: trip.tags,
            targetFish: trip.targetFish,
            aboutText: trip.aboutText,
            goodToKnow: trip.goodToKnow.first ?? "",
            isCarpoolAvailable: trip.isCarpoolAvailable,
            opensTemporaryChat: trip.opensTemporaryChat,
            verifiedOnly: trip.verifiedOnly
        )
    }

    static func category(for method: OriChatBuddyMethod) -> OriChatBuddyCategory {
        switch method {
        case .lure: return .lure
        case .sea, .boat: return .sea
        case .night: return .night
        case .fly: return .fly
        case .wild: return .lake
        }
    }

    private static func method(for category: OriChatBuddyCategory) -> OriChatBuddyMethod {
        switch category {
        case .lure: return .lure
        case .sea: return .sea
        case .night: return .night
        case .fly: return .fly
        case .nearby, .lake: return .wild
        }
    }

    private static func costTitle(_ cost: OriChatBuddyCostFilter) -> String {
        switch cost {
        case .aa: return "AA"
        case .hostPays: return "Host pays"
        case .free: return "Free"
        case .gearProvided: return "Free"
        }
    }

    private static func costSubtitle(_ cost: OriChatBuddyCostFilter) -> String {
        switch cost {
        case .aa: return "Split bait and gas"
        case .hostPays: return "Host covers basics"
        case .free: return "No shared cost"
        case .gearProvided: return "Gear provided"
        }
    }

    private static func cost(for title: String) -> OriChatBuddyCostFilter {
        title == "Free" ? .free : title == "Host pays" ? .hostPays : .aa
    }

    private static func experienceTitle(_ experience: OriChatBuddyExperienceFilter) -> String {
        switch experience {
        case .beginner: return "Beginner friendly"
        case .experienced: return "Experienced only"
        case .knowsSpot: return "Some experience"
        }
    }

    private static func experience(for text: String) -> OriChatBuddyExperienceFilter {
        text.contains("Experienced") ? .experienced : text.contains("Some") ? .knowsSpot : .beginner
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE · MMM d"
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}
