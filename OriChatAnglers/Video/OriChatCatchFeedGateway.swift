import Foundation

final class OriChatCatchFeedGateway {
    private enum Endpoint {
        static let users = "/mrorlhygsz/tvezyfttvx"
        static let dynamics = "/ejadqz/jwzonoxyvqwztwr"
    }

    private let decoder: OriChatCatchFeedDecoder
    private let authStore: AuthStore

    init(decoder: OriChatCatchFeedDecoder = OriChatCatchFeedDecoder(), authStore: AuthStore = .shared) {
        self.decoder = decoder
        self.authStore = authStore
    }

    func loadUsers(completion: @escaping (Result<[OriChatCatchUser], Error>) -> Void) {
        syncNetworkToken()
        let payload: [String: Any] = [
            "lureOria": AppConstants.appId
        ]
        Network.OriChatTransmitSignal(
            OriChatEndpoint: Endpoint.users,
            OriChatPayload: payload,
            OriChatOnSuccess: { [decoder] json in
                let users = decoder.users(from: json ?? [:])
                print("[OriChat][CatchFeed] users count=\(users.count)")
                completion(.success(users))
            },
            OriChatOnFailure: { error in
                print("[OriChat][CatchFeed] users failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        )
    }

    func loadVideos(page: Int, pageSize: Int, completion: @escaping (Result<[OriChatCatchVideo], Error>) -> Void) {
        syncNetworkToken()
        let payload: [String: Any] = [
            "tidelineOria": page,
            "currentOria": pageSize,
            "freshwaterOria": AppConstants.appId
        ]
        Network.OriChatTransmitSignal(
            OriChatEndpoint: Endpoint.dynamics,
            OriChatPayload: payload,
            OriChatOnSuccess: { [decoder] json in
                let videos = decoder.videos(from: json ?? [:])
                print("[OriChat][CatchFeed] videos page=\(page) videoCoverCount=\(videos.count)")
               let eralREaslu = videos.filter { OriChatCatchVideo in
                    OriChatCatchVideo.videoCoverURL != ""
                }
                completion(.success(eralREaslu))
            },
            OriChatOnFailure: { error in
                print("[OriChat][CatchFeed] videos failed page=\(page): \(error.localizedDescription)")
                completion(.failure(error))
            }
        )
    }

    private func syncNetworkToken() {
        Network.OriChatSessionToken = authStore.sessionToken
    }
}
