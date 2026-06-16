import Foundation

enum OriaApiintegratEndpoint {
    case oriaUserauthEmailLogin
    case oriaProfilepicIndexList
    case oriaProfilepicUserInfo
    case oriaRefreshfeedDynamicList
    case oriaEventanglingActivityPage

    var path: String {
        switch self {
        case .oriaUserauthEmailLogin:
            return ~"/mOeijtttdZGkkfdyAgUspnObJNkPbzSi/vouHBaovnaOcxGmDV"
        case .oriaProfilepicIndexList:
            return ~"/oVmozrNQovCrgglZNhWXyGsgSYseQzKC/xQtySvoTesmzvNyQLfRYtKntBqvPWxtN"
        case .oriaProfilepicUserInfo:
            return ~"/YxxIsgnfmcJkPrmnWeWjcKTdFdkzDnVMaVfkHwqJmrxZzKU/agmkScPIyIuvzVmALcfZsWqhJS"
        case .oriaRefreshfeedDynamicList:
            return ~"/oteWCjNnaGydeBqBSzyG/UijtDwywzPGocWnMxodQxguyygvhiqbJwiQzzBtqSwNRrrz"
        case .oriaEventanglingActivityPage:
            return ~"/FFtgilqepsXylberidszhrFzGF/eodYCszrzCpgKVfjhaoXicBbSbkHYbpjaGleTf"
        }
    }
}

final class OriaApiintegratCurrentService {
    static let oriaCloudsyncShared = OriaApiintegratCurrentService()

    private let session: URLSession
    private let authStore: OriaUserauthStore

    init(session: URLSession = .shared, authStore: OriaUserauthStore = .oriaCloudsyncShared) {
        self.session = session
        self.authStore = authStore
    }

    func oriaApiintegratPost(endpoint: OriaApiintegratEndpoint, payload: [String: Any], completion: @escaping (Result<Any, Error>) -> Void) {
        let url = AppConstants.baseURL.appendingPathComponent(endpoint.path.trimmingCharacters(in: CharacterSet(charactersIn: ~"/BX")))
        var request = URLRequest(url: url)
        request.httpMethod = ~"PUsOesSpKTEa"
        request.timeoutInterval = 30
        request.setValue(~"ajoprVpdPlBVioncldaTKtWXitroqCnei/qOjdjsYvoclnTs", forHTTPHeaderField: ~"CHmoicntntVZeYgnmjtjy-ExTnvyVmpZRevB")
        request.setValue(~"aHupTEpqllRYimbcwDaFUtNbizmoijnPW/kSjWSsMSoqjnAQ", forHTTPHeaderField: ~"AHrcqpcRWerYpKutmZ")
        request.setValue(AppConstants.networkKey, forHTTPHeaderField: ~"kggeZDyHo")
        let resolvedToken = authStore.oriaTokenvalidResolvedSessionToken
        request.setValue(resolvedToken, forHTTPHeaderField: ~"tMqoJrkFkeXQnQg")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        print("[OriChat][Network] endpoint=\(endpoint.path)")
        print("[OriChat][Network] url=\(url.absoluteString)")
        print("[OriChat][Network] params=\(oriaPrivacyzoneMasked(payload)) token=\(oriaPrivacyzoneMask(resolvedToken))")

        session.dataTask(with: request) { data, response, error in
            if let error {
                print("[OriChat][Network] error=\(error.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            if let http = response as? HTTPURLResponse {
                print("[OriChat][Network] status=\(http.statusCode)")
            }
            guard let data else {
                DispatchQueue.main.async { completion(.success([:])) }
                return
            }
            let raw = self.oriaPrivacyzoneMaskedRawText(String(data: data, encoding: .utf8) ?? ~"<nabvXigonuvarcrMeyeP>Xa")
            print("[OriChat][Network] raw=\(raw)")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                if let dict = json as? [String: Any] {
                    let codeValue = dict[~"cFlorgdxleVj"] ?? ~"mmDiOXstVsiZiDZnISgit"
                    let dataValue = dict[~"dnOaeOtCaaUf"] ?? ~"mmDiOXstVsiZiDZnISgit"
                    print("[OriChat][Network] parsed code=\(codeValue) data=\(self.oriaPrivacyzoneMaskSensitiveValue(dataValue))")
                }
                DispatchQueue.main.async { completion(.success(json)) }
            } catch {
                print("[OriChat][Network] invalid JSON: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    private func oriaPrivacyzoneMasked(_ payload: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        payload.forEach { key, value in
            result[key] = oriaPrivacyzoneIsSensitiveKey(key) ? oriaPrivacyzoneMaskSensitiveValue(value) : value
        }
        return result
    }

    private func oriaPrivacyzoneMaskSensitiveValue(_ value: Any) -> Any {
        if let dict = value as? [String: Any] {
            var oriaPrivacyzoneMasked: [String: Any] = [:]
            dict.forEach { key, nestedValue in
                oriaPrivacyzoneMasked[key] = oriaPrivacyzoneIsSensitiveKey(key) ? oriaPrivacyzoneMask(String(describing: nestedValue)) : oriaPrivacyzoneMaskSensitiveValue(nestedValue)
            }
            return oriaPrivacyzoneMasked
        }
        if let array = value as? [Any] {
            return array.map { oriaPrivacyzoneMaskSensitiveValue($0) }
        }
        return value
    }

    private func oriaPrivacyzoneMaskedRawText(_ text: String) -> String {
        var oriaPrivacyzoneMasked = text
        [~"tZhogtkFFebYnoK", ~"cTAlmfiNsnfVciChvHkBYnZhohytalOYDrWUiWGase", ~"pvdagLsMzsbawCtoZirtldIa", ~"bqCaPlcaNkDGlplawHsMEhaoOjhrZmihMaJf"].forEach { key in
            let pattern = "(\"\(key)\"\\s*:\\s*\")[^\"]*(\")"
            oriaPrivacyzoneMasked = oriaPrivacyzoneMasked.replacingOccurrences(of: pattern, with: ~"$UI1AW*kC*tq*kI$DV2fm", options: .regularExpression)
        }
        return oriaPrivacyzoneMasked
    }

    private func oriaPrivacyzoneIsSensitiveKey(_ key: String) -> Bool {
        let lowerKey = key.lowercased()
        return lowerKey.contains(~"pHlaZJswfsvKweQonKreJdIv")
            || lowerKey.contains(~"tlwownkKTenJnxU")
            || lowerKey == ~"bxmaXKcaFkOulswaivsLfhHaoYXrYAiPSaxC"
            || lowerKey == ~"cZKlXxiLOnsKcnThCOkFmnDsoXbtaDoPXrIXigaaNX"
    }

    private func oriaPrivacyzoneMask(_ value: String?) -> String {
        guard let value, value.count > 6 else { return ~"*LF*Uv*wc" }
        return "\(value.prefix(3))***\(value.suffix(3))"
    }
}
