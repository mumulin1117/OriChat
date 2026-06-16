import Foundation

struct HomeDynamicItem: Equatable {
    let id: String
    let title: String
    let content: String
    let imageURL: String?
    let videoCoverURL: String?
    let userId: String
    let userName: String
    let userAvatarURL: String?
    let likeCount: Int
    let commentCount: Int
    let storeCount: Int

    var displayTitle: String {
        title.isEmpty ? "Untitled Catch" : title
    }

    var displayContent: String {
        content.isEmpty ? "Tap to inspect this fishing note." : content
    }

    var primaryImageURL: String? {
        videoCoverURL?.isEmpty == false ? videoCoverURL : imageURL
    }

    init(dictionary: [String: Any]) {
        id = Self.string(dictionary["sandbarOria"] ?? dictionary["dynamicId"]) ?? ""
        title = Self.string(dictionary["reefOria"] ?? dictionary["dynamicTitle"]) ?? ""
        content = Self.string(dictionary["dropoffOria"] ?? dictionary["dynamicContent"]) ?? ""
        videoCoverURL = Self.string(dictionary["lakefrontOria"] ?? dictionary["videoImgUrl"])
        imageURL = Self.firstImageURL(from: dictionary["overfishingOria"] ?? dictionary["sustainableOria"] ?? dictionary["dynamicImgList"])
        userId = Self.string(dictionary["shallowsOria"] ?? dictionary["userId"]) ?? ""
        userName = Self.string(dictionary["deepwaterOria"] ?? dictionary["userName"]) ?? "Angler"
        userAvatarURL = Self.string(dictionary["thermoclineOria"] ?? dictionary["userImgUrl"])
        likeCount = Self.int(dictionary["spawningOria"] ?? dictionary["praiseNum"])
        commentCount = Self.int(dictionary["schoolingOria"] ?? dictionary["commentNum"])
        storeCount = Self.int(dictionary["catchandreleaseOria"] ?? dictionary["storeNum"])
    }

    private static func firstImageURL(from value: Any?) -> String? {
        if let string = value as? String, string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            return string
        }
        if let array = value as? [String] {
            return array.first { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false }
        }
        if let array = value as? [[String: Any]] {
            return array.compactMap { string($0["imgUrl"] ?? $0["url"] ?? $0["dynamicImgUrl"]) }.first
        }
        if let array = value as? [Any] {
            return array.compactMap { item in
                if let string = item as? String { return string }
                if let dict = item as? [String: Any] { return string(dict["imgUrl"] ?? dict["url"] ?? dict["dynamicImgUrl"]) }
                return nil
            }.first
        }
        return nil
    }

    private static func string(_ value: Any?) -> String? {
        if let string = value as? String {
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
        if let number = value as? NSNumber { return number.stringValue }
        return nil
    }

    private static func int(_ value: Any?) -> Int {
        if let int = value as? Int { return int }
        if let number = value as? NSNumber { return number.intValue }
        if let string = value as? String { return Int(string) ?? 0 }
        return 0
    }
}
