import Foundation

final class OriChatBuddyFilterEngine {
    func apply(trips: [OriChatBuddyTrip],
               filter: OriChatBuddyFilterState,
               sort: OriChatBuddySortOption,
               query: String?,
               category: OriChatBuddyCategory?) -> [OriChatBuddyTrip] {
        var next = trips.filter { $0.isHidden == false && $0.status != .canceled && $0.status != .draft }
        if let category {
            if category == .nearby {
                next.sort { $0.distanceValue < $1.distanceValue }
            } else {
                next = next.filter { $0.category == category }
            }
        }
        if let query, query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            next = next.filter { $0.contains(query) }
        }
        next = next.filter { trip in
            matchesWhen(trip, filter.when) &&
            matchesMethods(trip, filter.methods) &&
            matchesGroupSize(trip, filter.groupSize) &&
            matchesCost(trip, filter.costs) &&
            matchesExperience(trip, filter.experiences) &&
            matchesTrust(trip, filter.trusts)
        }
        return sorted(next, by: sort)
    }

    func resultCount(trips: [OriChatBuddyTrip], filter: OriChatBuddyFilterState, category: OriChatBuddyCategory?) -> Int {
        apply(trips: trips, filter: filter, sort: .soonestFirst, query: nil, category: category).count
    }

    private func matchesWhen(_ trip: OriChatBuddyTrip, _ when: OriChatBuddyWhenFilter?) -> Bool {
        guard let when else { return true }
        let haystack = [trip.dateText, trip.startTimeText].joined(separator: " ").lowercased()
        switch when {
        case .today: return haystack.contains("today")
        case .tomorrow: return haystack.contains("tomorrow")
        case .thisWeekend: return haystack.contains("sat") || haystack.contains("sun") || haystack.contains("weekend")
        case .custom: return true
        }
    }

    private func matchesMethods(_ trip: OriChatBuddyTrip, _ methods: Set<OriChatBuddyMethod>) -> Bool {
        guard methods.isEmpty == false else { return true }
        let haystack = tripText(trip)
        return methods.contains { method in
            switch method {
            case .lure: return trip.category == .lure || haystack.contains("lure")
            case .sea: return trip.category == .sea || haystack.contains("sea") || haystack.contains("pier") || haystack.contains("rock")
            case .wild: return haystack.contains("river") || haystack.contains("wild") || haystack.contains("creek")
            case .night: return trip.category == .night || haystack.contains("night")
            case .fly: return trip.category == .fly || haystack.contains("fly")
            case .boat: return haystack.contains("boat") || haystack.contains("harbor")
            }
        }
    }

    private func matchesGroupSize(_ trip: OriChatBuddyTrip, _ size: OriChatBuddyGroupSize?) -> Bool {
        guard let size else { return true }
        switch size {
        case .oneSpot: return trip.openSpots == 1
        case .twoThree: return (2...3).contains(trip.openSpots)
        case .fourPlus: return trip.openSpots >= 4 || trip.capacity >= 4
        }
    }

    private func matchesCost(_ trip: OriChatBuddyTrip, _ costs: Set<OriChatBuddyCostFilter>) -> Bool {
        guard costs.isEmpty == false else { return true }
        let haystack = tripText(trip)
        return costs.contains { cost in
            switch cost {
            case .aa: return trip.costTitle == "AA" || haystack.contains("split")
            case .hostPays: return haystack.contains("host pays")
            case .free: return trip.costTitle == "Free" || haystack.contains("free")
            case .gearProvided: return haystack.contains("gear") || haystack.contains("rod")
            }
        }
    }

    private func matchesExperience(_ trip: OriChatBuddyTrip, _ experiences: Set<OriChatBuddyExperienceFilter>) -> Bool {
        guard experiences.isEmpty == false else { return true }
        let haystack = tripText(trip)
        return experiences.contains { experience in
            switch experience {
            case .beginner: return haystack.contains("beginner")
            case .experienced: return haystack.contains("experienced")
            case .knowsSpot: return haystack.contains("guide") || haystack.contains("regular") || haystack.contains("spot")
            }
        }
    }

    private func matchesTrust(_ trip: OriChatBuddyTrip, _ trusts: Set<OriChatBuddyTrustFilter>) -> Bool {
        guard trusts.isEmpty == false else { return true }
        return trusts.allSatisfy { trust in
            switch trust {
            case .highReliability: return trip.organizer.rating >= 4.7
            case .lowPigeonRate: return trip.organizer.pigeonRate <= 5
            case .verifiedOnly: return trip.organizer.isVerified
            }
        }
    }

    private func sorted(_ trips: [OriChatBuddyTrip], by option: OriChatBuddySortOption) -> [OriChatBuddyTrip] {
        switch option {
        case .soonestFirst: return trips.sorted { $0.startDate < $1.startDate }
        case .nearestToMe: return trips.sorted { $0.distanceValue < $1.distanceValue }
        case .mostSpotsLeft: return trips.sorted { $0.openSpots > $1.openSpots }
        case .highestReliability: return trips.sorted { $0.organizer.rating > $1.organizer.rating }
        case .newestPosted: return trips.sorted { $0.createdAt > $1.createdAt }
        }
    }

    private func tripText(_ trip: OriChatBuddyTrip) -> String {
        ([trip.title, trip.category.rawValue, trip.costTitle, trip.costSubtitle, trip.targetFish, trip.skillText, trip.gearNote, trip.aboutText, trip.locationTitle, trip.locationSubtitle, trip.organizer.brief] + trip.tags + trip.goodToKnow)
            .joined(separator: " ")
            .lowercased()
    }
}
