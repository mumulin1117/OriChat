import Foundation

final class OriChatBuddyStateLedger {
    static let shared = OriChatBuddyStateLedger()

    private let defaults: UserDefaults
    private let authStore: AuthStore

    init(defaults: UserDefaults = .standard, authStore: AuthStore = .shared) {
        self.defaults = defaults
        self.authStore = authStore
    }

    func loadTrips() -> [OriChatBuddyTrip] {
        guard let data = defaults.data(forKey: key),
              let trips = try? JSONDecoder().decode([OriChatBuddyTrip].self, from: data) else {
            let trips = OriChatBuddyFixtureForge.trips()
            save(trips)
            return trips
        }
        let migratedTrips = migrateLegacyAssets(in: trips)
        if migratedTrips != trips {
            save(migratedTrips)
        }
        return migratedTrips
    }

    func save(_ trips: [OriChatBuddyTrip]) {
        guard let data = try? JSONEncoder().encode(trips) else { return }
        defaults.set(data, forKey: key)
    }

    func update(_ trip: OriChatBuddyTrip) {
        var trips = loadTrips()
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
        } else {
            trips.insert(trip, at: 0)
        }
        save(trips)
    }

    func insertCreated(_ trip: OriChatBuddyTrip) {
        var trips = loadTrips()
        trips.insert(trip, at: 0)
        save(trips)
    }

    private var key: String {
        let owner = authStore.currentUserId ?? authStore.currentUser?.email ?? "guest"
        return "OriChat.orichat.buddy.trips.v1.\(owner)"
    }

    private func migrateLegacyAssets(in trips: [OriChatBuddyTrip]) -> [OriChatBuddyTrip] {
        trips.map { trip in
            var migrated = trip
            if migrated.coverAssetName == AppAsset.authBackground {
                migrated.coverAssetName = coverAsset(for: migrated.id)
            }
            migrated.organizer = migrate(angler: migrated.organizer)
            migrated.attendees = migrated.attendees.map { migrate(angler: $0) }
            return migrated
        }
    }

    private func migrate(angler: OriChatBuddyAngler) -> OriChatBuddyAngler {
        var migrated = angler
        if migrated.avatarAssetName == AppAsset.loginFish || migrated.avatarAssetName == AppAsset.brandLogo {
            migrated.avatarAssetName = avatarAsset(for: migrated.id)
        }
        return migrated
    }

    private func avatarAsset(for id: String) -> String {
        switch id {
        case "orichat-current-angler": return AppAsset.buddyAvatarCurrent
        case "leo": return AppAsset.buddyAvatarLeo
        case "lizzie": return AppAsset.buddyAvatarLizzie
        case "mason": return AppAsset.buddyAvatarMason
        case "noah": return AppAsset.buddyAvatarNoah
        case "ava": return AppAsset.buddyAvatarAva
        case "river": return AppAsset.buddyAvatarRiver
        case "callie": return AppAsset.buddyAvatarCallie
        case "finn": return AppAsset.buddyAvatarFinn
        default: return AppAsset.buddyAvatarGuest01
        }
    }

    private func coverAsset(for id: String) -> String {
        switch id {
        case "buddy-001": return AppAsset.buddyCoverLakesideLure
        case "buddy-002": return AppAsset.buddyCoverCannonRocks
        case "buddy-003": return AppAsset.buddyCoverBlueLake
        case "buddy-004": return AppAsset.buddyCoverPineNight
        case "buddy-005": return AppAsset.buddyCoverHarborTrout
        case "buddy-006": return AppAsset.buddyCoverPierCrew
        case "buddy-007": return AppAsset.buddyCoverWillowSunset
        case "buddy-008": return AppAsset.buddyCoverRiverBass
        default: return AppAsset.buddyCoverDockMorning
        }
    }
}

final class OriChatBuddyHarborStore {
    private let ledger: OriChatBuddyStateLedger
    private(set) var trips: [OriChatBuddyTrip]

    init(ledger: OriChatBuddyStateLedger = .shared) {
        self.ledger = ledger
        self.trips = ledger.loadTrips()
    }

    func reload() {
        trips = ledger.loadTrips()
    }

    func upsert(_ trip: OriChatBuddyTrip) {
        if let index = trips.firstIndex(where: { $0.id == trip.id }) {
            trips[index] = trip
        } else {
            trips.insert(trip, at: 0)
        }
        ledger.save(trips)
    }

    func create(_ trip: OriChatBuddyTrip) {
        trips.insert(trip, at: 0)
        ledger.save(trips)
    }
}
