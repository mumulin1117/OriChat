import Foundation

final class OriChatTrustProfileGateway {
    func fetch(mode: OriChatTrustProfileMode,
               completion: @escaping (Result<OriChatTrustUserProfile, Error>) -> Void) {
        switch mode {
        case .oriaVerifiedanglerCurrentUser:
            OriBuaaAkeForNetTool.OriChatTransmitSignal(
                OriChatEndpoint: "/feptoduvcljynz/nmyktgyu",
                OriChatPayload: [:],
                OriChatOnSuccess: { response in
                    if let profile = OriChatTrustProfileDecoder.decodeCurrentUser(response as Any) {
                        completion(.success(profile))
                    } else {
                        completion(.failure(OriChatTrustProfileError.invalidPayload))
                    }
                },
                OriChatOnFailure: { error in completion(.failure(error)) }
            )
        case .angler:
            completion(.failure(OriChatTrustProfileError.localOnly))
        }
    }
}

enum OriChatTrustProfileError: Error {
    case invalidPayload
    case localOnly
}
