import Foundation

enum OriChatTrustProfileDecoder {
    static func decodeCurrentUser(_ value: Any) -> OriChatTrustUserProfile? {
        guard let dict = firstDictionary(in: value) else { return nil }
        let userId = string(dict["liplesscrankOria"] ?? dict["userId"]) ?? AuthStore.shared.currentUserId ?? OriChatBuddyFixtureForge.currentAngler.id
        let name = string(dict["hairjigOria"] ?? dict["userName"]) ?? AuthStore.shared.currentUser?.nickname ?? "You"
        let avatarURL = string(dict["featherjigOria"] ?? dict["userImgUrl"])
        let location = string(dict["wetflyOria"] ?? dict["userLocation"]) ?? "Unknown spot"
        let brief = string(dict["streamerOria"] ?? dict["userBrief"]) ?? "Local angler"
        return OriChatTrustUserProfile(
            userId: userId,
            name: name,
            avatarURL: avatarURL,
            avatarAssetName: nil,
            location: location,
            brief: brief,
            isVerified: true,
            averageReplyMinutes: 6
        )
    }

    private static func firstDictionary(in value: Any) -> [String: Any]? {
        if let dict = value as? [String: Any] {
            if dict["liplesscrankOria"] != nil || dict["hairjigOria"] != nil || dict["userId"] != nil {
                return dict
            }
            for nested in dict.values {
                if let found = firstDictionary(in: nested) { return found }
            }
        }
        if let array = value as? [Any] {
            for nested in array {
                if let found = firstDictionary(in: nested) { return found }
            }
        }
        return nil
    }

    private static func string(_ value: Any?) -> String? {
        if let string = value as? String, string.isEmpty == false { return string }
        if let number = value as? NSNumber { return number.stringValue }
        return nil
    }
}
