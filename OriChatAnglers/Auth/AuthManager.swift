import Foundation

final class AuthManager {
    private let store: AuthStore
    private let network: NetworkService

    init(store: AuthStore = .shared, network: NetworkService = .shared) {
        self.store = store
        self.network = network
    }

    func signIn(email: String, password: String, agreed: Bool, completion: @escaping (Result<AnglerUser, Error>) -> Void) {
        guard agreed else {
            completion(.failure(AuthError.termsRequired))
            return
        }
        do {
            let user = try store.signIn(email: email, password: password)
            requestAuth(email: user.email, password: password, nickname: user.nickname, type: 1) { remoteUser in
                completion(.success(remoteUser ?? user))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func signUp(nickname: String, email: String, password: String, agreed: Bool, completion: @escaping (Result<AnglerUser, Error>) -> Void) {
        guard agreed else {
            completion(.failure(AuthError.termsRequired))
            return
        }
        do {
            let user = try store.register(email: email, password: password, nickname: nickname)
            requestAuth(email: user.email, password: password, nickname: user.nickname, type: 2) { remoteUser in
                completion(.success(remoteUser ?? user))
            }
        } catch {
            completion(.failure(error))
        }
    }

    private func requestAuth(email: String, password: String, nickname: String, type: Int, completion: @escaping (AnglerUser?) -> Void) {
        let payload: [String: Any] = [
            "birdsnestOria": AppConstants.appId,
            "snarlOria": email,
            "backlashOria": password,
            "spoolOria": nickname,
            "dragwashersOria": type,
            "bailarmOria": "",
            "lineguideOria": ""
        ]
        network.post(endpoint: .emailLogin, payload: payload) { result in
            switch result {
            case .success(let json):
                let profile = RemoteAuthProfile(json: json)
                let user = self.store.mergeRemoteProfile(profile, for: email)
                if user == nil {
                    print("[OriChat][Auth] remote auth parsed but local user was missing for email=\(email)")
                }
                completion(user)
            case .failure(let error):
                print("[OriChat][Auth] remote auth failed: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
