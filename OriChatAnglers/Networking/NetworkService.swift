import Foundation

enum ObfuscatedEndpoint: String {
    case emailLogin = "/etdkdgpbkz/uancm"
    case selectUserIndexList = "/mrorlhygsz/tvezyfttvx"
    case selectUserInfo = "/xgmkmecdknakqrz/mcyvmcsh"
    case selectDynamicList = "/ejadqz/jwzonoxyvqwztwr"
    case selectActivityPage = "/tlpyedhz/dszgfaibkbae"
}

final class NetworkService {
    static let shared = NetworkService()

    private let session: URLSession
    private let authStore: AuthStore

    init(session: URLSession = .shared, authStore: AuthStore = .shared) {
        self.session = session
        self.authStore = authStore
    }

    func post(endpoint: ObfuscatedEndpoint, payload: [String: Any], completion: @escaping (Result<Any, Error>) -> Void) {
        let url = AppConstants.baseURL.appendingPathComponent(endpoint.rawValue.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(AppConstants.networkKey, forHTTPHeaderField: "key")
        request.setValue(authStore.sessionToken ?? "", forHTTPHeaderField: "token")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        print("[OriChat][Network] endpoint=\(endpoint.rawValue)")
        print("[OriChat][Network] url=\(url.absoluteString)")
        print("[OriChat][Network] params=\(masked(payload)) token=\(mask(authStore.sessionToken))")

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
            let raw = self.maskedRawText(String(data: data, encoding: .utf8) ?? "<binary>")
            print("[OriChat][Network] raw=\(raw)")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                if let dict = json as? [String: Any] {
                    print("[OriChat][Network] parsed code=\(dict["code"] ?? "missing") data=\(self.maskSensitiveValue(dict["data"] ?? "missing"))")
                }
                DispatchQueue.main.async { completion(.success(json)) }
            } catch {
                print("[OriChat][Network] invalid JSON: \(error.localizedDescription)")
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
    }

    private func masked(_ payload: [String: Any]) -> [String: Any] {
        var result: [String: Any] = [:]
        payload.forEach { key, value in
            result[key] = isSensitiveKey(key) ? maskSensitiveValue(value) : value
        }
        return result
    }

    private func maskSensitiveValue(_ value: Any) -> Any {
        if let dict = value as? [String: Any] {
            var masked: [String: Any] = [:]
            dict.forEach { key, nestedValue in
                masked[key] = isSensitiveKey(key) ? mask(String(describing: nestedValue)) : maskSensitiveValue(nestedValue)
            }
            return masked
        }
        if let array = value as? [Any] {
            return array.map { maskSensitiveValue($0) }
        }
        return value
    }

    private func maskedRawText(_ text: String) -> String {
        var masked = text
        ["token", "clinchknotOria", "password", "backlashOria"].forEach { key in
            let pattern = "(\"\(key)\"\\s*:\\s*\")[^\"]*(\")"
            masked = masked.replacingOccurrences(of: pattern, with: "$1***$2", options: .regularExpression)
        }
        return masked
    }

    private func isSensitiveKey(_ key: String) -> Bool {
        let lowerKey = key.lowercased()
        return lowerKey.contains("password")
            || lowerKey.contains("token")
            || lowerKey == "backlashoria"
            || lowerKey == "clinchknotoria"
    }

    private func mask(_ value: String?) -> String {
        guard let value, value.count > 6 else { return "***" }
        return "\(value.prefix(3))***\(value.suffix(3))"
    }
}
