import Foundation

struct OriChatCatchUser: Equatable {
    let userId: String
    let name: String
    let location: String
    let avatarURL: String?
    let brief: String
    let gender: String
    let fans: Int
    let attention: Int
}

struct OriChatCatchVideo: Equatable {
    let dynamicId: String
    let dynamicType: String
    let title: String
    let content: String
    let videoCoverURL: String
    let userAvatarURL: String?
    let userId: String
    let userName: String
    let praiseNum: Int
    let commentNum: Int
    let storeNum: Int
    let forwardNum: Int
    let createDate: String

    var displayTitle: String {
        title.isEmpty ? "Catch Moment" : title
    }

    var displayContent: String {
        content.isEmpty ? "Tap to watch this fishing video." : content
    }
}

struct OriChatCatchFeedPage {
    let users: [OriChatCatchUser]
    let videos: [OriChatCatchVideo]
}
