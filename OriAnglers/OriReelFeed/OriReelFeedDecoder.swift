import Foundation

final class OriChatCatchFeedDecoder {
    func users(from json: Any) -> [OriChatCatchUser] {
        arrayDictionaries(in: json).map { dict in
            OriChatCatchUser(
                userId: string(dict["anglerOria"] ?? dict["userId"]) ?? "",
                name: string(dict["castingOria"] ?? dict["userName"]) ?? "Angler",
                location: string(dict["hooksetOria"] ?? dict["userLocation"]) ?? "",
                avatarURL: string(dict["reelOria"] ?? dict["userImgUrl"]),
                brief: string(dict["tackleOria"] ?? dict["userBrief"]) ?? "",
                gender: string(dict["swivelOria"] ?? dict["userGender"]) ?? "",
                fans: int(dict["baitcastingOria"] ?? dict["userFans"]),
                attention: int(dict["flyfishingOria"] ?? dict["userAttention"])
            )
        }.filter { $0.userId.isEmpty == false || $0.avatarURL != nil || $0.name != "Angler" }
    }

    func videos(from json: Any) -> [OriChatCatchVideo] {
        arrayDictionaries(in: json).compactMap { dict in
            guard let cover = string(dict["lakefrontOria"] ?? dict["videoImgUrl"]) else { return nil }
            return OriChatCatchVideo(
                dynamicId: string(dict["sandbarOria"] ?? dict["dynamicId"]) ?? "",
                dynamicType: string(dict["dockOria"] ?? dict["dynamicType"]) ?? "",
                title: string(dict["reefOria"] ?? dict["dynamicTitle"]) ?? "",
                content: string(dict["dropoffOria"] ?? dict["dynamicContent"]) ?? "",
                videoCoverURL: cover,
                userAvatarURL: string(dict["thermoclineOria"] ?? dict["userImgUrl"]),
                userId: string(dict["shallowsOria"] ?? dict["userId"]) ?? "",
                userName: string(dict["deepwaterOria"] ?? dict["userName"]) ?? "Angler",
                praiseNum: int(dict["spawningOria"] ?? dict["praiseNum"]),
                commentNum: int(dict["schoolingOria"] ?? dict["commentNum"]),
                storeNum: int(dict["catchandreleaseOria"] ?? dict["storeNum"]),
                forwardNum: int(dict["feedingfrenzyOria"] ?? dict["forwardNum"]),
                createDate: string(dict["sizeboundOria"] ?? dict["createDate"]) ?? ""
            )
        }
    }

    private func arrayDictionaries(in value: Any) -> [[String: Any]] {
        arrays(in: value)
            .max(by: { $0.count < $1.count })?
            .compactMap { $0 as? [String: Any] } ?? []
    }

    private func arrays(in value: Any) -> [[Any]] {
        if let array = value as? [Any] {
            return [array]
        }
        if let dict = value as? [String: Any] {
            return dict.values.flatMap { arrays(in: $0) }
        }
        return []
    }

    private func string(_ value: Any?) -> String? {
        if let string = value as? String {
            let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? nil : trimmed
        }
        if let number = value as? NSNumber {
            return number.stringValue
        }
        return nil
    }

    private func int(_ value: Any?) -> Int {
        if let int = value as? Int { return int }
        if let number = value as? NSNumber { return number.intValue }
        if let string = value as? String { return Int(string) ?? 0 }
        return 0
    }
}
