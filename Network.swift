
import Foundation

class Network {

    static var OriChatSessionToken: String? {
        get {
            return AuthStore.shared.sessionToken ?? UserDefaults.standard.object(forKey: "OriChat_UserKey") as? String
        } set {
            UserDefaults.standard.set(newValue, forKey: "OriChat_UserKey")
            AuthStore.shared.sessionToken = newValue
        }
    }
    static func OriChatTransmitSignal(
        OriChatEndpoint: String,
        OriChatPayload: [String: Any],
        OriChatOnSuccess: ((Any?) -> Void)?,
        OriChatOnFailure: ((Error) -> Void)?
    ) {//baseurl + "/backone"
        let OriChatPath = OriChatEndpoint.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let OriChatTargetUrl = AppConstants.baseURL.appendingPathComponent(OriChatPath)
        
        var OriChatCoreRequest = OriChatForgeRequest(OriChatTarget: OriChatTargetUrl, OriChatData: OriChatPayload)
        let OriChatHeaders = ["key": AppConstants.networkKey, "token": Network.OriChatSessionToken ?? ""]
        OriChatHeaders.forEach { OriChatCoreRequest.setValue($1, forHTTPHeaderField: $0) }

        print("[OriChat][Network.swift] endpoint=\(OriChatEndpoint)")
        print("[OriChat][Network.swift] url=\(OriChatTargetUrl.absoluteString)")
        print("[OriChat][Network.swift] params=\(OriChatMaskedPayload(OriChatPayload)) token=\(OriChatMask(Network.OriChatSessionToken))")
        
        let OriChatNetworkSession = URLSessionConfiguration.default
        OriChatNetworkSession.timeoutIntervalForRequest = 30
        
        URLSession(configuration: OriChatNetworkSession).dataTask(with: OriChatCoreRequest) { OriChatRawData, OriChatResponse, OriChatError in
            DispatchQueue.main.async {
                if let OriChatErr = OriChatError {
                    print("[OriChat][Network.swift] error=\(OriChatErr.localizedDescription)")
                    OriChatOnFailure?(OriChatErr)
                    return
                }
                if let OriChatHTTP = OriChatResponse as? HTTPURLResponse {
                    print("[OriChat][Network.swift] status=\(OriChatHTTP.statusCode)")
                }
                guard let OriChatData = OriChatRawData else {
                    print("[OriChat][Network.swift] missing data")
                    return
                }
                let OriChatRawText = OriChatMaskedRawText(String(data: OriChatData, encoding: .utf8) ?? "<binary>")
                print("[OriChat][Network.swift] raw=\(OriChatRawText)")
                do {
                    let OriChatJson = try JSONSerialization.jsonObject(with: OriChatData, options: .allowFragments)
                    if let OriChatDict = OriChatJson as? [String: Any] {
                        print("[OriChat][Network.swift] parsed code=\(OriChatDict["code"] ?? "missing") data=\(OriChatMaskSensitiveValue(OriChatDict["data"] ?? "missing"))")
                    } else {
                        print("[OriChat][Network.swift] data=\(OriChatMaskSensitiveValue(OriChatJson))")
                    }
                    OriChatOnSuccess?(OriChatJson)
                } catch {
                    print("[OriChat][Network.swift] invalid JSON: \(error.localizedDescription)")
                    OriChatOnFailure?(error)
                }
            }
        }.resume()
    }
    
    private static func OriChatForgeRequest(OriChatTarget: URL, OriChatData: [String: Any]) -> URLRequest {
        var OriChatRequest = URLRequest(url: OriChatTarget, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        OriChatRequest.httpMethod = "POST"
        OriChatRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        OriChatRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        OriChatRequest.httpBody = try? JSONSerialization.data(withJSONObject: OriChatData)
        return OriChatRequest
    }

    private static func OriChatMaskedPayload(_ OriChatPayload: [String: Any]) -> [String: Any] {
        var OriChatResult: [String: Any] = [:]
        OriChatPayload.forEach { OriChatKey, OriChatValue in
            OriChatResult[OriChatKey] = OriChatIsSensitiveKey(OriChatKey) ? OriChatMaskSensitiveValue(OriChatValue) : OriChatValue
        }
        return OriChatResult
    }

    private static func OriChatMaskSensitiveValue(_ OriChatValue: Any) -> Any {
        if let OriChatDict = OriChatValue as? [String: Any] {
            var OriChatMasked: [String: Any] = [:]
            OriChatDict.forEach { OriChatKey, OriChatNestedValue in
                OriChatMasked[OriChatKey] = OriChatIsSensitiveKey(OriChatKey) ? OriChatMask(String(describing: OriChatNestedValue)) : OriChatMaskSensitiveValue(OriChatNestedValue)
            }
            return OriChatMasked
        }
        if let OriChatArray = OriChatValue as? [Any] {
            return OriChatArray.map { OriChatMaskSensitiveValue($0) }
        }
        return OriChatValue
    }

    private static func OriChatMaskedRawText(_ OriChatText: String) -> String {
        var OriChatMasked = OriChatText
        ["token", "clinchknotOria", "password", "backlashOria"].forEach { OriChatKey in
            let OriChatPattern = "(\"\(OriChatKey)\"\\s*:\\s*\")[^\"]*(\")"
            OriChatMasked = OriChatMasked.replacingOccurrences(of: OriChatPattern, with: "$1***$2", options: .regularExpression)
        }
        return OriChatMasked
    }

    private static func OriChatIsSensitiveKey(_ OriChatKey: String) -> Bool {
        let OriChatLowerKey = OriChatKey.lowercased()
        return OriChatLowerKey.contains("password")
            || OriChatLowerKey.contains("token")
            || OriChatLowerKey == "backlashoria"
            || OriChatLowerKey == "clinchknotoria"
    }

    private static func OriChatMask(_ OriChatValue: String?) -> String {
        guard let OriChatValue, OriChatValue.count > 6 else { return "***" }
        return "\(OriChatValue.prefix(3))***\(OriChatValue.suffix(3))"
    }
}
