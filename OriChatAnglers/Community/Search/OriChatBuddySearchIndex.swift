import Foundation

struct OriChatBuddySearchMatch {
    let trip: OriChatBuddyTrip
    let score: Int
}

final class OriChatBuddySearchIndex {
    func search(_ query: String, in trips: [OriChatBuddyTrip]) -> [OriChatBuddySearchMatch] {
        let terms = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .split(whereSeparator: { $0.isWhitespace })
            .map(String.init)
        guard terms.isEmpty == false else { return [] }

        return trips
            .filter { $0.isHidden == false && $0.status != .canceled && $0.status != .draft }
            .compactMap { trip in
                let score = score(trip, terms: terms)
                return score > 0 ? OriChatBuddySearchMatch(trip: trip, score: score) : nil
            }
            .sorted { left, right in
                if left.score == right.score {
                    return left.trip.dateText.localizedCaseInsensitiveCompare(right.trip.dateText) == .orderedAscending
                }
                return left.score > right.score
            }
    }

    private func score(_ trip: OriChatBuddyTrip, terms: [String]) -> Int {
        var total = 0
        for term in terms {
            let titleScore = match(term, in: [trip.title]) ? 120 : 0
            let categoryScore = match(term, in: [trip.category.rawValue, trip.targetFish]) ? 80 : 0
            let locationScore = match(term, in: [trip.locationTitle, trip.locationSubtitle]) ? 55 : 0
            let detailScore = match(term, in: [trip.organizer.name, trip.skillText, trip.costTitle, trip.costSubtitle, trip.aboutText, trip.dateText]) ? 42 : 0
            let tagScore = match(term, in: trip.tags + trip.goodToKnow) ? 30 : 0
            let best = max(titleScore, categoryScore, locationScore, detailScore, tagScore)
            guard best > 0 else { return 0 }
            total += best
        }
        return total
    }

    private func match(_ term: String, in values: [String]) -> Bool {
        values.contains { $0.lowercased().contains(term) }
    }
}
