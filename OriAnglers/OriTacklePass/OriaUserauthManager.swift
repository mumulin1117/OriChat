import Foundation

final class OriaUserauthManager {
    private let oriaDatabasestoreStore: OriaUserauthStore
    private let oriaNetworkpingService: OriaApiintegratCurrentService

    init(oriaDatabasestoreStore: OriaUserauthStore = .oriaCloudsyncShared, oriaNetworkpingService: OriaApiintegratCurrentService = .oriaCloudsyncShared) {
        self.oriaDatabasestoreStore = oriaDatabasestoreStore
        self.oriaNetworkpingService = oriaNetworkpingService
    }

    func oriaUserauthSignIn(email: String, password: String, agreed: Bool, completion: @escaping (Result<OriaVerifiedanglerUser, Error>) -> Void) {
        guard agreed else {
            completion(.failure(OriaUserauthError.oriaEulalegalTermsRequired))
            return
        }
        do {
            let user = try oriaDatabasestoreStore.oriaUserauthSignIn(oriaUserauthEmail: email, oriaPrivacyzonePassword: password)
            oriaUserauthRequestAuth(email: user.oriaUserauthEmail, password: password, nickname: user.oriaBiotextNickname, type: 1) { remoteUser in
                completion(.success(remoteUser ?? user))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func oriaUserauthSignUp(nickname: String, email: String, password: String, agreed: Bool, completion: @escaping (Result<OriaVerifiedanglerUser, Error>) -> Void) {
        guard agreed else {
            completion(.failure(OriaUserauthError.oriaEulalegalTermsRequired))
            return
        }
        do {
            let user = try oriaDatabasestoreStore.oriaUserauthRegister(oriaUserauthEmail: email, oriaPrivacyzonePassword: password, oriaBiotextNickname: nickname)
            oriaUserauthRequestAuth(email: user.oriaUserauthEmail, password: password, nickname: user.oriaBiotextNickname, type: 2) { remoteUser in
                completion(.success(remoteUser ?? user))
            }
        } catch {
            completion(.failure(error))
        }
    }

    private func oriaUserauthRequestAuth(email: String, password: String, nickname: String, type: Int, completion: @escaping (OriaVerifiedanglerUser?) -> Void) {
        let payload: [String: Any] = [
            ~"baNixlrtEdRsslLnlweCOsultcmOCZrZgiocaoB": AppConstants.appId,
            ~"sVZnacaGmrKElAdOGDrzQiGcazd": email,
            ~"baKaWNcMZksNlfGaEwsFphGIOQOrJuiIjaHp": password,
            ~"svYpDbozSoiwlFuOVqrnziDxaeM": nickname,
            ~"dfordZaUkgOnwVraBSsUUhkGerbrWDsjoOdorxiihoaZw": type,
            ~"bDwaeFibilTOadDrxsmAROferYOiueaag": ~"",
            ~"llbizTnnSeKPgAKuGfiHadWjehgOlNrUCiCmahI": ~""
        ]
        oriaNetworkpingService.oriaApiintegratPost(endpoint: .oriaUserauthEmailLogin, payload: payload) { result in
            switch result {
            case .success(let json):
                let profile = OriaTokenvalidProfile(json: json)
                let user = self.oriaDatabasestoreStore.oriaUserauthMergeRemoteProfile(profile, for: email)
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
