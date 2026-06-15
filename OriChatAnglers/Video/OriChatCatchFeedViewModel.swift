import Foundation

final class OriChatCatchFeedViewModel {
    enum State {
        case idle
        case loading
        case loaded
        case empty
        case failed(String)
    }

    private let gateway: OriChatCatchFeedGateway
    private let pageSize = 12
    private var page = 1
    private var canLoadMore = true
    private var loadingMore = false
    private var knownDynamicIds = Set<String>()

    private(set) var users: [OriChatCatchUser] = []
    private(set) var videos: [OriChatCatchVideo] = []

    var onUpdate: (() -> Void)?
    var onStateChange: ((State) -> Void)?

    init(gateway: OriChatCatchFeedGateway = OriChatCatchFeedGateway()) {
        self.gateway = gateway
    }

    func loadInitial() {
        page = 1
        canLoadMore = true
        knownDynamicIds.removeAll()
        onStateChange?(.loading)

        let group = DispatchGroup()
        var videoError: Error?
        var nextUsers: [OriChatCatchUser] = []
        var nextVideos: [OriChatCatchVideo] = []

        group.enter()
        gateway.loadUsers { result in
            if case .success(let users) = result { nextUsers = users }
            group.leave()
        }

        group.enter()
        gateway.loadVideos(page: page, pageSize: pageSize) { result in
            if case .success(let videos) = result { nextVideos = videos }
            if case .failure(let error) = result { videoError = error }
            group.leave()
        }

        group.notify(queue: .main) {
            self.users = nextUsers
            self.videos = self.uniqueVideos(nextVideos)
            self.canLoadMore = nextVideos.isEmpty == false
            self.onUpdate?()
            if self.videos.isEmpty, let videoError {
                self.onStateChange?(.failed(videoError.localizedDescription))
            } else if self.videos.isEmpty {
                self.onStateChange?(.empty)
            } else {
                self.onStateChange?(.loaded)
            }
        }
    }

    func loadMoreIfNeeded(currentIndex: Int) {
        guard canLoadMore, loadingMore == false, currentIndex >= videos.count - 3 else { return }
        loadingMore = true
        let nextPage = page + 1
        gateway.loadVideos(page: nextPage, pageSize: pageSize) { result in
            DispatchQueue.main.async {
                self.loadingMore = false
                switch result {
                case .success(let videos):
                    let unique = self.uniqueVideos(videos)
                    self.canLoadMore = videos.isEmpty == false && unique.isEmpty == false
                    self.page = nextPage
                    self.videos.append(contentsOf: unique)
                    self.onUpdate?()
                case .failure(let error):
                    print("[OriChat][CatchFeed] loadMore failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func uniqueVideos(_ items: [OriChatCatchVideo]) -> [OriChatCatchVideo] {
        var result: [OriChatCatchVideo] = []
        for item in items {
            let key = item.dynamicId.isEmpty ? "\(item.videoCoverURL)-\(item.userId)" : item.dynamicId
            guard knownDynamicIds.contains(key) == false else { continue }
            knownDynamicIds.insert(key)
            result.append(item)
        }
        return result
    }
}
