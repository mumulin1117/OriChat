import Foundation

enum OriChatTrustProfileMode {
    case oriaVerifiedanglerCurrentUser
    case angler(userId: String)
}

struct OriChatTrustUserProfile: Equatable {
    var userId: String
    var name: String
    var avatarURL: String?
    var avatarAssetName: String?
    var location: String
    var brief: String
    var isVerified: Bool
    var averageReplyMinutes: Int?
}

struct OriChatTrustProfileMetrics: Equatable {
    var reliabilityScore: Double?
    var pigeonRateText: String
    var completedCount: Int
    var cancelsLast30Days: Int
    var organizedCount: Int
    var joinedCount: Int
    var averageReplyText: String
    var buddyTags: [String]
    var reviews: [OriChatTrustReview]
}

struct OriChatTrustProfileViewData: Equatable {
    var profile: OriChatTrustUserProfile
    var metrics: OriChatTrustProfileMetrics
}

enum OriChatTrustProfileState {
    case loading
    case loaded(OriChatTrustProfileViewData)
    case partial(OriChatTrustProfileViewData, warning: String?)
    case empty
    case failed(String)
}
