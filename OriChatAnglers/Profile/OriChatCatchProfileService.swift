import Foundation

final class OriChatCatchProfileService {
    private let network: NetworkService
    private let authStore: AuthStore

    init(network: NetworkService = .shared, authStore: AuthStore = .shared) {
        self.network = network
        self.authStore = authStore
    }

    func fetchCurrentUser(completion: @escaping (Result<OriChatCatchProfileSummary, Error>) -> Void) {
        let userId = authStore.currentUserId ?? authStore.currentUser?.userId ?? OriChatBuddyFixtureForge.currentAngler.id
        let payload: [String: Any] = [
            "undertowOria": userId,
            "whirlpoolOria": 1
        ]
        network.post(endpoint: .selectUserInfo, payload: payload) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let json):
                if let profile = self.decodeProfile(from: json, requestedUserId: userId) {
                    completion(.success(profile))
                } else {
                    print("[OriChat][Profile] missing user profile data, fallback to local user. raw=\(json)")
                    completion(.failure(OriChatCatchProfileError.missingData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fallbackSummary() -> OriChatCatchProfileSummary {
        let user = authStore.currentUser
        return OriChatCatchProfileSummary(
            userId: authStore.currentUserId ?? user?.userId ?? OriChatBuddyFixtureForge.currentAngler.id,
            name: user?.nickname.nonEmptyValue ?? "OriChat Angler",
            avatarURL: user?.avatarURL,
            avatarAssetName: AppAsset.buddyAvatarCurrent,
            location: "Local fishing waters",
            brief: "Plan catches, meet reliable anglers, and keep your fishing records close.",
            followingCount: 0,
            postCount: 0,
            followersCount: 0,
            ratingText: "No rating yet",
            hasWalletState: false
        )
    }

    private func decodeProfile(from value: Any, requestedUserId: String) -> OriChatCatchProfileSummary? {
        guard let dict = firstDictionary(in: value) else { return nil }
        let fallback = fallbackSummary()
        let userId = string(dict["algaeOria"] ?? dict["userId"]) ?? requestedUserId
        let name = string(dict["planktonOria"] ?? dict["userName"]) ?? fallback.name
        let avatarURL = string(dict["crustaceanOria"] ?? dict["userImgUrl"])
        let location = string(dict["sardineOria"] ?? dict["userLocation"]) ?? fallback.location
        let brief = string(dict["minnowOria"] ?? dict["userBrief"]) ?? fallback.brief
        let following = int(dict["cricketOria"] ?? dict["userAttention"]) ?? fallback.followingCount
        let followers = int(dict["maggotOria"] ?? dict["userFans"]) ?? fallback.followersCount
        let friends = int(dict["wormOria"] ?? dict["userFriends"]) ?? 0
        let history = int(dict["grasshopperOria"] ?? dict["historyNum"]) ?? 0
        let postCount = max(history, dynamicCount(in: dict["crabOria"] ?? dict["userDynamicVoList"]))
        let hasWallet = dict["crankbaitOria"] != nil || dict["userBalance"] != nil
        print("[OriChat][Profile] parsed userId=\(userId) name=\(name) following=\(following) posts=\(postCount) followers=\(max(followers, friends))")
        return OriChatCatchProfileSummary(
            userId: userId,
            name: name,
            avatarURL: avatarURL,
            avatarAssetName: AppAsset.buddyAvatarCurrent,
            location: location,
            brief: brief,
            followingCount: following,
            postCount: postCount,
            followersCount: max(followers, friends),
            ratingText: fallback.ratingText,
            hasWalletState: hasWallet
        )
    }

    private func firstDictionary(in value: Any) -> [String: Any]? {
        if let dict = value as? [String: Any] {
            if dict["algaeOria"] != nil || dict["planktonOria"] != nil || dict["userId"] != nil || dict["userName"] != nil {
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

    private func dynamicCount(in value: Any?) -> Int {
        if let array = value as? [Any] { return array.count }
        return 0
    }

    private func string(_ value: Any?) -> String? {
        if let text = value as? String, text.isEmpty == false { return text }
        if let number = value as? NSNumber { return number.stringValue }
        return nil
    }

    private func int(_ value: Any?) -> Int? {
        if let int = value as? Int { return int }
        if let number = value as? NSNumber { return number.intValue }
        if let text = value as? String { return Int(text) }
        return nil
    }
}

enum OriChatCatchProfileError: Error {
    case missingData
}

private extension String {
    var nonEmptyValue: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
