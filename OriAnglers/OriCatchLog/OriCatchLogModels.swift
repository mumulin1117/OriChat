import Foundation

struct OriChatCatchProfileSummary: Equatable {
    var userId: String
    var name: String
    var avatarURL: String?
    var avatarAssetName: String
    var location: String
    var brief: String
    var followingCount: Int
    var postCount: Int
    var followersCount: Int
    var ratingText: String
    var hasWalletState: Bool
}

enum OriChatCatchProfileRecordTab: String, CaseIterable {
    case myPosts = "My posts"
    case applied = "Applied"
    case joined = "Joined"
    case history = "History"
}

enum OriChatCatchProfileRecordAction: String {
    case view = "View"
    case review = "Review"
    case chat = "Chat"
}

struct OriChatCatchProfileRecord: Equatable {
    var id: String
    var title: String
    var subtitle: String
    var statusText: String
    var statusKind: OriChatCatchProfileStatusKind
    var avatarAssetName: String
    var action: OriChatCatchProfileRecordAction
    var trip: OriChatBuddyTrip
}

enum OriChatCatchProfileStatusKind: Equatable {
    case recruiting
    case pending
    case upcoming
    case rateBuddies
    case completed
    case canceled
}

struct OriChatCatchProfileViewState: Equatable {
    var summary: OriChatCatchProfileSummary
    var selectedTab: OriChatCatchProfileRecordTab
    var records: [OriChatCatchProfileRecord]
}
