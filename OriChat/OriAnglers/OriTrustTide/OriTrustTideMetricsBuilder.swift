import Foundation

final class OriChatTrustProfileMetricsBuilder {
    func build(userId: String,
               profile: OriChatTrustUserProfile?,
               trips: [OriChatBuddyTrip],
               reviews: [OriChatTrustReview]) -> OriChatTrustProfileMetrics {
        let aliases = Set([userId, OriChatBuddyFixtureForge.currentAngler.id].filter { $0.isEmpty == false })
        let related = trips.filter { trip in
            aliases.contains(trip.organizer.id) || trip.isCreatedByCurrentUser || trip.attendeeIds.contains { aliases.contains($0) }
        }
        let organized = trips.filter { aliases.contains($0.organizer.id) || $0.isCreatedByCurrentUser }
        let joined = trips.filter { trip in
            trip.attendeeIds.contains { aliases.contains($0) } && (aliases.contains(trip.organizer.id) == false || trip.isCreatedByCurrentUser == false)
        }
        let canceled = related.filter { $0.status == .canceled }
        let completed = related.filter { $0.status != .canceled && $0.status != .draft && $0.startDate < Date() }
        let canceledLast30 = canceled.filter { ($0.canceledAt ?? .distantPast) > Date().addingTimeInterval(-30 * 86_400) }
        let pigeonRate = Double(canceled.count) / Double(max(completed.count + canceled.count, 1))
        let stableReviews = reviews.isEmpty ? generatedReviews(for: related) : reviews
        let reviewAverage = stableReviews.isEmpty ? 0 : Double(stableReviews.map(\.rating).reduce(0, +)) / Double(stableReviews.count)
        let cancelPenalty = min(Double(canceledLast30.count) * 0.15, 0.8)
        let pigeonPenalty = min(pigeonRate * 0.8, 0.5)
        let reviewBonus = reviewAverage >= 4.8 ? 0.1 : 0
        let score = related.isEmpty ? nil : max(0, min(5, 5.0 - cancelPenalty - pigeonPenalty + reviewBonus))
        let tags = buildTags(from: related, reviews: stableReviews)
        let reply = profile?.averageReplyMinutes.map { "~\($0) min" } ?? "~6 min"
        return OriChatTrustProfileMetrics(
            reliabilityScore: score,
            pigeonRateText: "\(Int(round(pigeonRate * 100)))%",
            completedCount: completed.count,
            cancelsLast30Days: canceledLast30.count,
            organizedCount: organized.count,
            joinedCount: joined.count,
            averageReplyText: reply,
            buddyTags: tags,
            reviews: stableReviews
        )
    }

    private func generatedReviews(for trips: [OriChatBuddyTrip]) -> [OriChatTrustReview] {
        guard trips.isEmpty == false else { return [] }
        return [
            OriChatTrustReview(id: "trust-review-noah", reviewerId: "noah", reviewerName: "Noah", reviewerAvatarAssetName: AppAsset.loginFish, reviewerAvatarURL: nil, rating: 5, tag: "On time", content: "Great company and super reliable. Brought spare tackle for everyone.", createdAt: Date(timeIntervalSince1970: 1_718_200_000)),
            OriChatTrustReview(id: "trust-review-mia", reviewerId: "mia", reviewerName: "Mia", reviewerAvatarAssetName: AppAsset.loginFish, reviewerAvatarURL: nil, rating: 5, tag: "Friendly", content: "Made a beginner feel totally welcome. Would fish again anytime.", createdAt: Date(timeIntervalSince1970: 1_718_100_000)),
            OriChatTrustReview(id: "trust-review-leo", reviewerId: "leo", reviewerName: "Leo", reviewerAvatarAssetName: AppAsset.loginFish, reviewerAvatarURL: nil, rating: 5, tag: "Well prepared", content: "Knew the spot well, good calls on where to cast.", createdAt: Date(timeIntervalSince1970: 1_718_000_000))
        ]
    }

    private func buildTags(from trips: [OriChatBuddyTrip], reviews: [OriChatTrustReview]) -> [String] {
        let reviewTags = reviews.map(\.tag)
        let tripTags = trips.flatMap(\.tags).filter { ["Lure", "Fly", "Beginner", "Carpool", "Gear share"].contains($0) }
        let unique = Array(NSOrderedSet(array: reviewTags + tripTags)) as? [String] ?? []
        return unique.isEmpty ? ["First trip pending"] : Array(unique.prefix(6))
    }
}
