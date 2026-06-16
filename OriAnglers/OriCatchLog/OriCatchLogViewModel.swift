import Foundation

final class OriChatCatchProfileViewModel {
    private let service: OriChatCatchProfileService
    private let buddyStore: OriChatBuddyHarborStore
    private let authStore: OriaUserauthStore
    private var summary: OriChatCatchProfileSummary
    private(set) var selectedTab: OriChatCatchProfileRecordTab = .myPosts

    init(service: OriChatCatchProfileService = OriChatCatchProfileService(),
         buddyStore: OriChatBuddyHarborStore = OriChatBuddyHarborStore(),
         authStore: OriaUserauthStore = .oriaCloudsyncShared) {
        self.service = service
        self.buddyStore = buddyStore
        self.authStore = authStore
        self.summary = service.fallbackSummary()
    }

    func load(completion: @escaping (OriChatCatchProfileViewState) -> Void) {
        buddyStore.reload()
        completion(state(using: summary))
        service.fetchCurrentUser { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let remote):
                self.summary = self.merge(remote)
            case .failure(let error):
                print("[OriChat][Profile] user detail fallback error=\(error)")
                self.summary = self.merge(self.service.fallbackSummary())
            }
            completion(self.state(using: self.summary))
        }
    }

    func select(tab: OriChatCatchProfileRecordTab) -> OriChatCatchProfileViewState {
        selectedTab = tab
        return state(using: summary)
    }

    private func merge(_ remote: OriChatCatchProfileSummary) -> OriChatCatchProfileSummary {
        var merged = remote
        let localPosts = records(for: .myPosts, summary: remote).count
        merged.postCount = max(remote.postCount, localPosts)
        return merged
    }

    private func state(using summary: OriChatCatchProfileSummary) -> OriChatCatchProfileViewState {
        OriChatCatchProfileViewState(
            summary: summary,
            selectedTab: selectedTab,
            records: records(for: selectedTab, summary: summary)
        )
    }

    private func records(for tab: OriChatCatchProfileRecordTab, summary: OriChatCatchProfileSummary) -> [OriChatCatchProfileRecord] {
        buddyStore.trips
            .filter { matches($0, tab: tab, userId: summary.userId) }
            .sorted { $0.startDate > $1.startDate }
            .map { record(from: $0, tab: tab) }
    }

    private func matches(_ trip: OriChatBuddyTrip, tab: OriChatCatchProfileRecordTab, userId: String) -> Bool {
        let ids = Set([userId, authStore.oriaVerifiedanglerCurrentUserId, authStore.oriaVerifiedanglerCurrentUser?.oriaVerifiedanglerUserId, OriChatBuddyFixtureForge.currentAngler.id].compactMap { $0 })
        let isMine = trip.isCreatedByCurrentUser || ids.contains(trip.organizer.id)
        let isAttendee = trip.attendeeIds.contains { ids.contains($0) }
        let isApplicant = trip.applicantIds.contains { ids.contains($0) } || trip.waitlistIds.contains { ids.contains($0) }
        let isHistory = trip.status == .canceled || trip.startDate < Date()
        switch tab {
        case .myPosts:
            return isMine
        case .applied:
            return isApplicant && isAttendee == false && isMine == false
        case .joined:
            return isAttendee && isMine == false && isHistory == false
        case .history:
            return isHistory && (isMine || isAttendee || isApplicant)
        }
    }

    private func record(from trip: OriChatBuddyTrip, tab: OriChatCatchProfileRecordTab) -> OriChatCatchProfileRecord {
        let status = status(for: trip, tab: tab)
        let action = action(for: trip, tab: tab)
        return OriChatCatchProfileRecord(
            id: trip.id,
            title: trip.title,
            subtitle: "\(trip.dateText) · \(trip.startTimeText)",
            statusText: status.text,
            statusKind: status.kind,
            avatarAssetName: trip.organizer.avatarAssetName,
            action: action,
            trip: trip
        )
    }

    private func status(for trip: OriChatBuddyTrip, tab: OriChatCatchProfileRecordTab) -> (text: String, kind: OriChatCatchProfileStatusKind) {
        if trip.status == .canceled { return ("Canceled", .canceled) }
        if trip.startDate < Date() { return (tab == .joined ? "Rate buddies" : "Completed", tab == .joined ? .rateBuddies : .completed) }
        switch tab {
        case .myPosts:
            return (trip.applicantIds.isEmpty ? "Recruiting" : "Recruiting", .recruiting)
        case .applied:
            return ("Pending", .pending)
        case .joined:
            return ("Upcoming", .upcoming)
        case .history:
            return ("Completed", .completed)
        }
    }

    private func action(for trip: OriChatBuddyTrip, tab: OriChatCatchProfileRecordTab) -> OriChatCatchProfileRecordAction {
        if trip.status == .canceled || trip.startDate < Date() { return .review }
        switch tab {
        case .myPosts:
            return trip.applicantIds.isEmpty ? .view : .review
        case .applied:
            return .view
        case .joined:
            return .chat
        case .history:
            return .review
        }
    }
}
