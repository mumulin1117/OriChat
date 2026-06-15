import Foundation

enum OriChatBuddyWhenFilter: String, Codable, CaseIterable {
    case today = "Today"
    case tomorrow = "Tomorrow"
    case thisWeekend = "This weekend"
    case custom = "Custom"
}

enum OriChatBuddyMethod: String, Codable, CaseIterable, Hashable {
    case lure = "Lure"
    case sea = "Sea"
    case wild = "Wild"
    case night = "Night"
    case fly = "Fly"
    case boat = "Boat"
}

enum OriChatBuddyGroupSize: String, Codable, CaseIterable {
    case oneSpot = "1 spot"
    case twoThree = "2-3"
    case fourPlus = "4+"
}

enum OriChatBuddyCostFilter: String, Codable, CaseIterable, Hashable {
    case aa = "AA"
    case hostPays = "Host pays"
    case free = "Free"
    case gearProvided = "Gear provided"
}

enum OriChatBuddyExperienceFilter: String, Codable, CaseIterable, Hashable {
    case beginner = "Beginner friendly"
    case experienced = "Experienced"
    case knowsSpot = "Knows the spot"
}

enum OriChatBuddyTrustFilter: String, Codable, CaseIterable, Hashable {
    case highReliability = "High reliability"
    case lowPigeonRate = "Low pigeon rate"
    case verifiedOnly = "Verified only"
}

enum OriChatBuddySortOption: String, Codable, CaseIterable {
    case soonestFirst = "Soonest first"
    case nearestToMe = "Nearest to me"
    case mostSpotsLeft = "Most spots left"
    case highestReliability = "Highest reliability"
    case newestPosted = "Newest posted"
}

struct OriChatBuddyFilterState: Codable, Equatable {
    var when: OriChatBuddyWhenFilter?
    var methods: Set<OriChatBuddyMethod> = []
    var groupSize: OriChatBuddyGroupSize?
    var costs: Set<OriChatBuddyCostFilter> = []
    var experiences: Set<OriChatBuddyExperienceFilter> = []
    var trusts: Set<OriChatBuddyTrustFilter> = []

    var isEmpty: Bool {
        when == nil && methods.isEmpty && groupSize == nil && costs.isEmpty && experiences.isEmpty && trusts.isEmpty
    }

    var activeCount: Int {
        (when == nil ? 0 : 1) + methods.count + (groupSize == nil ? 0 : 1) + costs.count + experiences.count + trusts.count
    }
}

final class OriChatBuddyFilterMemory {
    private let defaults: UserDefaults
    private let filterKey = "OriChat.orichat.buddy.filter.state.v1"
    private let sortKey = "OriChat.orichat.buddy.sort.option.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadFilter() -> OriChatBuddyFilterState {
        guard let data = defaults.data(forKey: filterKey),
              let state = try? JSONDecoder().decode(OriChatBuddyFilterState.self, from: data) else {
            return OriChatBuddyFilterState()
        }
        return state
    }

    func saveFilter(_ state: OriChatBuddyFilterState) {
        guard let data = try? JSONEncoder().encode(state) else { return }
        defaults.set(data, forKey: filterKey)
    }

    func clearFilter() {
        defaults.removeObject(forKey: filterKey)
    }

    func loadSort() -> OriChatBuddySortOption {
        guard let raw = defaults.string(forKey: sortKey),
              let option = OriChatBuddySortOption(rawValue: raw) else {
            return .soonestFirst
        }
        return option
    }

    func saveSort(_ option: OriChatBuddySortOption) {
        defaults.set(option.rawValue, forKey: sortKey)
    }
}
