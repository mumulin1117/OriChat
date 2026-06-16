import Foundation

struct OriChatTrustReview: Codable, Hashable {
    let id: String
    let reviewerId: String
    let reviewerName: String
    let reviewerAvatarAssetName: String?
    let reviewerAvatarURL: String?
    let rating: Int
    let tag: String
    let content: String
    let createdAt: Date
}
