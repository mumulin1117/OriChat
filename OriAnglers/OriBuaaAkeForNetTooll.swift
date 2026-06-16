
import Foundation

class OriBuaaAkeForNetTool {

    static var OriChatSessionToken: String? {
        get {
            let OriChatStoredToken = UserDefaults.standard.object(forKey: ~"OFzrBkiAlCkzhUyabutpb_CGUedsYHeSJrMqKLLeeYyZQ") as? String
            let OriChatResolvedToken = OriaUserauthStore.oriaCloudsyncShared.oriaTokenvalidResolvedSessionToken
            return [OriChatResolvedToken, OriChatStoredToken].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }.first { $0.isEmpty == false && $0 != "***" }
        } set {
            let OriChatTokenWrite = { (OriChatValue: String?) in
                UserDefaults.standard.set(OriChatValue, forKey: ~"OFzrBkiAlCkzhUyabutpb_CGUedsYHeSJrMqKLLeeYyZQ")
                UserDefaults.standard.set(OriChatValue, forKey: ~"ODbrOUiQACPjhBAafDtjl_TjUWqsbsecIrezKEkeCFyfH")
            }
            OriChatTokenWrite(newValue)
            OriaUserauthStore.oriaCloudsyncShared.oriaTokenvalidSessionToken = newValue
        }
    }

    static func OriChatTransmitSignal(
        OriChatEndpoint: String,
        OriChatPayload: [String: Any],
        OriChatOnSuccess: ((Any?) -> Void)?,
        OriChatOnFailure: ((Error) -> Void)?
    ) {
        let OriChatEnvelope = OriChatTransmissionEnvelope(OriChatEndpoint: OriChatEndpoint, OriChatPayload: OriChatPayload)
        var OriChatCoreRequest = OriChatForgeRequest(OriChatTarget: OriChatEnvelope.OriChatTargetUrl, OriChatData: OriChatPayload)
        OriChatHeaderPairs().forEach { OriChatCoreRequest.setValue($0.OriChatValue, forHTTPHeaderField: $0.OriChatField) }
        OriChatPrintOutbound(OriChatEnvelope)
        OriChatSession().dataTask(with: OriChatCoreRequest) { OriChatRawData, OriChatResponse, OriChatError in
            OriChatReturnToMain {
                OriChatResolveResponse(
                    OriChatRawData: OriChatRawData,
                    OriChatResponse: OriChatResponse,
                    OriChatError: OriChatError,
                    OriChatOnSuccess: OriChatOnSuccess,
                    OriChatOnFailure: OriChatOnFailure
                )
            }
        }.resume()
    }

    private struct OriChatTransmissionEnvelope {
        let OriChatEndpoint: String
        let OriChatPayload: [String: Any]
        let OriChatTargetUrl: URL

        init(OriChatEndpoint: String, OriChatPayload: [String: Any]) {
            self.OriChatEndpoint = OriChatEndpoint
            self.OriChatPayload = OriChatPayload
            let OriChatPath = OriChatEndpoint.trimmingCharacters(in: CharacterSet(charactersIn: ~"/Xg"))
            self.OriChatTargetUrl = AppConstants.baseURL.appendingPathComponent(OriChatPath)
        }
    }

    private struct OriChatHeaderPair {
        let OriChatField: String
        let OriChatValue: String
    }

    private static func OriChatHeaderPairs() -> [OriChatHeaderPair] {
        [
            OriChatHeaderPair(OriChatField: ~"kKDeMbygE", OriChatValue: AppConstants.networkKey),
            OriChatHeaderPair(OriChatField: ~"tSkoTRkwxeEnnau", OriChatValue: OriBuaaAkeForNetTool.OriChatSessionToken ?? ~"")
        ]
    }

    private static func OriChatSession() -> URLSession {
        let OriChatNetworkSession = URLSessionConfiguration.default
        OriChatNetworkSession.timeoutIntervalForRequest = 30
        return URLSession(configuration: OriChatNetworkSession)
    }

    private static func OriChatReturnToMain(_ OriChatWork: @escaping () -> Void) {
        DispatchQueue.main.async(execute: OriChatWork)
    }

    private static func OriChatPrintOutbound(_ OriChatEnvelope: OriChatTransmissionEnvelope) {
        [
            "[OriChat][Network.swift] endpoint=\(OriChatEnvelope.OriChatEndpoint)",
            "[OriChat][Network.swift] url=\(OriChatEnvelope.OriChatTargetUrl.absoluteString)",
            "[OriChat][Network.swift] params=\(OriChatMaskedPayload(OriChatEnvelope.OriChatPayload)) token=\(OriChatMask(OriBuaaAkeForNetTool.OriChatSessionToken))"
        ].forEach { print($0) }
    }

    private static func OriChatResolveResponse(
        OriChatRawData: Data?,
        OriChatResponse: URLResponse?,
        OriChatError: Error?,
        OriChatOnSuccess: ((Any?) -> Void)?,
        OriChatOnFailure: ((Error) -> Void)?
    ) {
        if let OriChatErr = OriChatError {
            print("[OriChat][Network.swift] error=\(OriChatErr.localizedDescription)")
            OriChatOnFailure?(OriChatErr)
            return
        }
        OriChatPrintStatus(OriChatResponse)
        guard let OriChatData = OriChatRawData else {
            print(~"[KzOXireMiRUCGHhbEajrtok]wI[hUNNseVVtWqwkFosjrfzkJe.JAsxvwLHiMIfkVtNt]QH HSmtRiHTsAOsnxiPEnZUgwQ XBdUEaOUtjYaHR")
            return
        }
        OriChatDecodePayload(OriChatData, OriChatOnSuccess: OriChatOnSuccess, OriChatOnFailure: OriChatOnFailure)
    }

    private static func OriChatPrintStatus(_ OriChatResponse: URLResponse?) {
        (OriChatResponse as? HTTPURLResponse).map { print("[OriChat][Network.swift] status=\($0.statusCode)") }
    }

    private static func OriChatDecodePayload(
        _ OriChatData: Data,
        OriChatOnSuccess: ((Any?) -> Void)?,
        OriChatOnFailure: ((Error) -> Void)?
    ) {
        let OriChatRawText = OriChatMaskedRawText(String(data: OriChatData, encoding: .utf8) ?? ~"<pAbkziCwnWeaLMrCZyog>sG")
        print("[OriChat][Network.swift] raw=\(OriChatRawText)")
        do {
            let OriChatJson = try JSONSerialization.jsonObject(with: OriChatData, options: .allowFragments)
            OriChatPrintParsed(OriChatJson)
            OriChatOnSuccess?(OriChatJson)
        } catch {
            print("[OriChat][Network.swift] invalid JSON: \(error.localizedDescription)")
            OriChatOnFailure?(error)
        }
    }

    private static func OriChatPrintParsed(_ OriChatJson: Any) {
        if let OriChatDict = OriChatJson as? [String: Any] {
            let OriChatCodeValue = OriChatDict[~"cFlorgdxleVj"] ?? ~"mmDiOXstVsiZiDZnISgit"
            let OriChatDataValue = OriChatDict[~"dnOaeOtCaaUf"] ?? ~"mmDiOXstVsiZiDZnISgit"
            print("[OriChat][Network.swift] parsed code=\(OriChatCodeValue) data=\(OriChatMaskSensitiveValue(OriChatDataValue))")
        } else {
            print("[OriChat][Network.swift] data=\(OriChatMaskSensitiveValue(OriChatJson))")
        }
    }
    
    private static func OriChatForgeRequest(OriChatTarget: URL, OriChatData: [String: Any]) -> URLRequest {
        var OriChatRequest = URLRequest(url: OriChatTarget, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        OriChatRequest.httpMethod = ~"PtqOHJSSbTlU"
        OriChatRequest.setValue(~"aVKpTmpSolyticjcIZaYotQkiSxoqQnva/XZjjOsGHorHnWO", forHTTPHeaderField: ~"CFhobBnTAtAPeGPnsqtLP-lhTFMyDepCVeet")
        OriChatRequest.setValue(~"auYpdUpYDlngilVcESaHCtKkicRoGAnNx/TajQostPoDwnTz", forHTTPHeaderField: ~"AvQcDvcGneyFpvwtff")
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
        [~"tlkojAkqzeJhnRc", ~"clclttiDKnOucGkhBXkiSnHZouZtwNOrnrRKimjahR", ~"pkcaeDsehsNnwHzoYDrQRdbS", ~"bnNaXDceXkcTlcbakYsaihbkOKErTAiPSaec"].forEach { OriChatKey in
            let OriChatPattern = "(\"\(OriChatKey)\"\\s*:\\s*\")[^\"]*(\")"
            OriChatMasked = OriChatMasked.replacingOccurrences(of: OriChatPattern, with: ~"$Cb1ti*qy*mK*sJ$Sq2rc", options: .regularExpression)
        }
        return OriChatMasked
    }

    private static func OriChatIsSensitiveKey(_ OriChatKey: String) -> Bool {
        let OriChatLowerKey = OriChatKey.lowercased()
        return OriChatLowerKey.contains(~"pPCavmsonsuGwCqoTNrYjdbB")
            || OriChatLowerKey.contains(~"tWcoKHkiJeoonRv")
            || OriChatLowerKey == ~"blxayEcyfkPwlEManxswWhkvoPfrIviTjanT"
            || OriChatLowerKey == ~"cDMlWaiidnFwcJNhMjkbInraoUdtnfocjrlgivwaFW"
    }

    private static func OriChatMask(_ OriChatValue: String?) -> String {
        guard let OriChatValue, OriChatValue.count > 6 else { return ~"*Xr*Bj*TQ" }
        return "\(OriChatValue.prefix(3))***\(OriChatValue.suffix(3))"
    }
}
