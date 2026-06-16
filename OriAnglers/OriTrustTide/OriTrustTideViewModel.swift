import Foundation

final class OriChatTrustProfileViewModel {
    private let mode: OriChatTrustProfileMode
    private let buddyStore: OriChatBuddyHarborStore
    private let gateway: OriChatTrustProfileGateway
    private let metricsBuilder: OriChatTrustProfileMetricsBuilder
    private let authStore: OriaUserauthStore
    private let localProfile: OriChatTrustUserProfile?

    init(mode: OriChatTrustProfileMode,
         buddyStore: OriChatBuddyHarborStore,
         gateway: OriChatTrustProfileGateway = OriChatTrustProfileGateway(),
         metricsBuilder: OriChatTrustProfileMetricsBuilder = OriChatTrustProfileMetricsBuilder(),
         authStore: OriaUserauthStore = .oriaCloudsyncShared,
         localProfile: OriChatTrustUserProfile? = nil) {
        self.mode = mode
        self.buddyStore = buddyStore
        self.gateway = gateway
        self.metricsBuilder = metricsBuilder
        self.authStore = authStore
        self.localProfile = localProfile
    }

    func load(completion: @escaping (OriChatTrustProfileState) -> Void) {
        buddyStore.reload()
        let fallback = buildViewData(profile: fallbackProfile())
        completion(.partial(fallback, warning: nil))
        gateway.fetch(mode: mode) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    completion(.loaded(self.buildViewData(profile: self.merge(remote: profile, fallback: fallback.profile))))
                case .failure(let error):
                    let message: String?
                    if case OriChatTrustProfileError.localOnly = error {
                        message = nil
                    } else {
                        message = "Using local profile while remote data is unavailable."
                    }
                    completion(.partial(fallback, warning: message))
                }
            }
        }
    }

    private func buildViewData(profile: OriChatTrustUserProfile) -> OriChatTrustProfileViewData {
        let metrics = metricsBuilder.build(userId: profile.userId, profile: profile, trips: buddyStore.trips, reviews: [])
        return OriChatTrustProfileViewData(profile: profile, metrics: metrics)
    }

    private func fallbackProfile() -> OriChatTrustUserProfile {
        switch mode {
        case .oriaVerifiedanglerCurrentUser:
            let user = authStore.oriaVerifiedanglerCurrentUser
            return OriChatTrustUserProfile(
                userId: user?.oriaVerifiedanglerUserId ?? OriChatBuddyFixtureForge.currentAngler.id,
                name: user?.oriaBiotextNickname.nonEmpty ?? "OriChat Angler",
                avatarURL: user?.oriaProfilepicAvatarURL,
                avatarAssetName: AppAsset.loginFish,
                location: "Local fishing waters",
                brief: "Fishing buddy profile is ready for your next trip.",
                isVerified: true,
                averageReplyMinutes: 6
            )
        case .angler(let userId):
            if let localProfile { return localProfile }
            if let angler = findAngler(userId: userId) {
                return profile(from: angler)
            }
            return OriChatTrustUserProfile(
                userId: userId,
                name: "OriChat Angler",
                avatarURL: nil,
                avatarAssetName: AppAsset.loginFish,
                location: "Fishing waters",
                brief: "This angler has not completed a public profile yet.",
                isVerified: false,
                averageReplyMinutes: 10
            )
        }
    }

    private func merge(remote: OriChatTrustUserProfile, fallback: OriChatTrustUserProfile) -> OriChatTrustUserProfile {
        OriChatTrustUserProfile(
            userId: remote.userId.nonEmpty ?? fallback.userId,
            name: remote.name.nonEmpty ?? fallback.name,
            avatarURL: remote.avatarURL?.nonEmpty ?? fallback.avatarURL,
            avatarAssetName: fallback.avatarAssetName,
            location: remote.location.nonEmpty ?? fallback.location,
            brief: remote.brief.nonEmpty ?? fallback.brief,
            isVerified: remote.isVerified || fallback.isVerified,
            averageReplyMinutes: remote.averageReplyMinutes ?? fallback.averageReplyMinutes
        )
    }

    private func findAngler(userId: String) -> OriChatBuddyAngler? {
        for trip in buddyStore.trips {
            if trip.organizer.id == userId { return trip.organizer }
            if let attendee = trip.attendees.first(where: { $0.id == userId }) { return attendee }
        }
        return nil
    }

    private func profile(from angler: OriChatBuddyAngler) -> OriChatTrustUserProfile {
        OriChatTrustUserProfile(
            userId: angler.id,
            name: angler.name,
            avatarURL: nil,
            avatarAssetName: angler.avatarAssetName,
            location: angler.location,
            brief: angler.brief,
            isVerified: angler.isVerified,
            averageReplyMinutes: 10
        )
    }
}

private extension String {
    var nonEmpty: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
