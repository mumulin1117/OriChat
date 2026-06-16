import Foundation

class OriBuaaAkeForNetTool {
    static var OriChatSessionToken: String? {
        get { OriChatTokenBridge().OriChatRead() }
        set { OriChatTokenBridge().OriChatWrite(newValue) }
    }

    static func OriChatTransmitSignal(
        OriChatEndpoint: String,
        OriChatPayload: [String: Any],
        OriChatOnSuccess: ((Any?) -> Void)?,
        OriChatOnFailure: ((Error) -> Void)?
    ) {
        let OriChatParcel = OriChatRequestParcel(OriChatEndpoint: OriChatEndpoint, OriChatPayload: OriChatPayload)
        let OriChatExecutor = OriChatRequestExecutor(
            OriChatParcel: OriChatParcel,
            OriChatOnSuccess: OriChatOnSuccess,
            OriChatOnFailure: OriChatOnFailure
        )
        OriChatExecutor.OriChatRun()
    }

    private struct OriChatTokenBridge {
        func OriChatRead() -> String? {
            let OriChatStoredToken = UserDefaults.standard.object(forKey: ~"OFzrBkiAlCkzhUyabutpb_CGUedsYHeSJrMqKLLeeYyZQ") as? String
            let OriChatResolvedToken = OriaUserauthStore.oriaCloudsyncShared.oriaTokenvalidResolvedSessionToken
            return [OriChatResolvedToken, OriChatStoredToken]
                .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
                .first { $0.isEmpty == false && $0 != "***" }
        }

        func OriChatWrite(_ OriChatValue: String?) {
            [~"OFzrBkiAlCkzhUyabutpb_CGUedsYHeSJrMqKLLeeYyZQ", ~"ODbrOUiQACPjhBAafDtjl_TjUWqsbsecIrezKEkeCFyfH"].forEach {
                UserDefaults.standard.set(OriChatValue, forKey: $0)
            }
            OriaUserauthStore.oriaCloudsyncShared.oriaTokenvalidSessionToken = OriChatValue
        }
    }

    private struct OriChatRequestExecutor {
        let OriChatParcel: OriChatRequestParcel
        let OriChatOnSuccess: ((Any?) -> Void)?
        let OriChatOnFailure: ((Error) -> Void)?

        func OriChatRun() {
            let OriChatRequest = OriChatRequestFactory(OriChatParcel: OriChatParcel).OriChatRequest()
            OriChatConsole.Outbound(OriChatParcel: OriChatParcel).OriChatPrint()
            OriChatSessionBox().OriChatSession.dataTask(with: OriChatRequest) { OriChatRawData, OriChatResponse, OriChatError in
                OriChatMainQueueBox {
                    OriChatResponseGate(
                        OriChatRawData: OriChatRawData,
                        OriChatResponse: OriChatResponse,
                        OriChatError: OriChatError,
                        OriChatOnSuccess: OriChatOnSuccess,
                        OriChatOnFailure: OriChatOnFailure
                    ).OriChatResolve()
                }.OriChatDispatch()
            }.resume()
        }
    }

    private struct OriChatRequestParcel {
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

    private struct OriChatRequestFactory {
        let OriChatParcel: OriChatRequestParcel

        func OriChatRequest() -> URLRequest {
            var OriChatRequest = URLRequest(url: OriChatParcel.OriChatTargetUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
            OriChatRequest.httpMethod = ~"PtqOHJSSbTlU"
            OriChatHeaderBox().OriChatHeaders.forEach {
                OriChatRequest.setValue($0.OriChatValue, forHTTPHeaderField: $0.OriChatField)
            }
            OriChatRequest.httpBody = try? JSONSerialization.data(withJSONObject: OriChatParcel.OriChatPayload)
            return OriChatRequest
        }
    }

    private struct OriChatHeaderBox {
        var OriChatHeaders: [OriChatHeaderPair] {
            [
                OriChatHeaderPair(OriChatField: ~"CFhobBnTAtAPeGPnsqtLP-lhTFMyDepCVeet", OriChatValue: ~"aVKpTmpSolyticjcIZaYotQkiSxoqQnva/XZjjOsGHorHnWO"),
                OriChatHeaderPair(OriChatField: ~"AvQcDvcGneyFpvwtff", OriChatValue: ~"auYpdUpYDlngilVcESaHCtKkicRoGAnNx/TajQostPoDwnTz"),
                OriChatHeaderPair(OriChatField: ~"kKDeMbygE", OriChatValue: AppConstants.networkKey),
                OriChatHeaderPair(OriChatField: ~"tSkoTRkwxeEnnau", OriChatValue: OriBuaaAkeForNetTool.OriChatSessionToken ?? ~"")
            ]
        }
    }

    private struct OriChatHeaderPair {
        let OriChatField: String
        let OriChatValue: String
    }

    private struct OriChatSessionBox {
        var OriChatSession: URLSession {
            let OriChatNetworkSession = URLSessionConfiguration.default
            OriChatNetworkSession.timeoutIntervalForRequest = 30
            return URLSession(configuration: OriChatNetworkSession)
        }
    }

    private struct OriChatMainQueueBox {
        let OriChatWork: () -> Void

        init(_ OriChatWork: @escaping () -> Void) {
            self.OriChatWork = OriChatWork
        }

        func OriChatDispatch() {
            DispatchQueue.main.async(execute: OriChatWork)
        }
    }

    private struct OriChatResponseGate {
        let OriChatRawData: Data?
        let OriChatResponse: URLResponse?
        let OriChatError: Error?
        let OriChatOnSuccess: ((Any?) -> Void)?
        let OriChatOnFailure: ((Error) -> Void)?

        func OriChatResolve() {
            if let OriChatErr = OriChatError {
                print("[OriChat][Network.swift] error=\(OriChatErr.localizedDescription)")
                OriChatOnFailure?(OriChatErr)
                return
            }
            OriChatConsole.Status(OriChatResponse: OriChatResponse).OriChatPrint()
            guard let OriChatData = OriChatRawData else {
                print(~"[KzOXireMiRUCGHhbEajrtok]wI[hUNNseVVtWqwkFosjrfzkJe.JAsxvwLHiMIfkVtNt]QH HSmtRiHTsAOsnxiPEnZUgwQ XBdUEaOUtjYaHR")
                return
            }
            OriChatPayloadDecoder(
                OriChatData: OriChatData,
                OriChatOnSuccess: OriChatOnSuccess,
                OriChatOnFailure: OriChatOnFailure
            ).OriChatDecode()
        }
    }

    private struct OriChatPayloadDecoder {
        let OriChatData: Data
        let OriChatOnSuccess: ((Any?) -> Void)?
        let OriChatOnFailure: ((Error) -> Void)?

        func OriChatDecode() {
            let OriChatRawText = OriChatRedaction.RawText(OriChatText: String(data: OriChatData, encoding: .utf8) ?? ~"<pAbkziCwnWeaLMrCZyog>sG").OriChatMasked()
            print("[OriChat][Network.swift] raw=\(OriChatRawText)")
            do {
                let OriChatJson = try JSONSerialization.jsonObject(with: OriChatData, options: .allowFragments)
                OriChatConsole.Parsed(OriChatJson: OriChatJson).OriChatPrint()
                OriChatOnSuccess?(OriChatJson)
            } catch {
                print("[OriChat][Network.swift] invalid JSON: \(error.localizedDescription)")
                OriChatOnFailure?(error)
            }
        }
    }

    private enum OriChatConsole {
        struct Outbound {
            let OriChatParcel: OriChatRequestParcel

            func OriChatPrint() {
                [
                    "[OriChat][Network.swift] endpoint=\(OriChatParcel.OriChatEndpoint)",
                    "[OriChat][Network.swift] url=\(OriChatParcel.OriChatTargetUrl.absoluteString)",
                    "[OriChat][Network.swift] params=\(OriChatRedaction.Payload(OriChatPayload: OriChatParcel.OriChatPayload).OriChatMasked()) token=\(OriChatRedaction.Token(OriChatValue: OriBuaaAkeForNetTool.OriChatSessionToken).OriChatMasked())"
                ].forEach { print($0) }
            }
        }

        struct Status {
            let OriChatResponse: URLResponse?

            func OriChatPrint() {
                (OriChatResponse as? HTTPURLResponse).map { print("[OriChat][Network.swift] status=\($0.statusCode)") }
            }
        }

        struct Parsed {
            let OriChatJson: Any

            func OriChatPrint() {
                if let OriChatDict = OriChatJson as? [String: Any] {
                    let OriChatCodeValue = OriChatDict[~"cFlorgdxleVj"] ?? ~"mmDiOXstVsiZiDZnISgit"
                    let OriChatDataValue = OriChatDict[~"dnOaeOtCaaUf"] ?? ~"mmDiOXstVsiZiDZnISgit"
                    print("[OriChat][Network.swift] parsed code=\(OriChatCodeValue) data=\(OriChatRedaction.SensitiveValue(OriChatValue: OriChatDataValue).OriChatMasked())")
                } else {
                    print("[OriChat][Network.swift] data=\(OriChatRedaction.SensitiveValue(OriChatValue: OriChatJson).OriChatMasked())")
                }
            }
        }
    }

    private enum OriChatRedaction {
        struct Payload {
            let OriChatPayload: [String: Any]

            func OriChatMasked() -> [String: Any] {
                OriChatPayload.reduce(into: [String: Any]()) { OriChatResult, OriChatEntry in
                    OriChatResult[OriChatEntry.key] = Key(OriChatKey: OriChatEntry.key).OriChatSensitive ? SensitiveValue(OriChatValue: OriChatEntry.value).OriChatMasked() : OriChatEntry.value
                }
            }
        }

        struct SensitiveValue {
            let OriChatValue: Any

            func OriChatMasked() -> Any {
                if let OriChatDict = OriChatValue as? [String: Any] {
                    return OriChatDict.reduce(into: [String: Any]()) { OriChatMasked, OriChatPair in
                        OriChatMasked[OriChatPair.key] = Key(OriChatKey: OriChatPair.key).OriChatSensitive ? Token(OriChatValue: String(describing: OriChatPair.value)).OriChatMasked() : SensitiveValue(OriChatValue: OriChatPair.value).OriChatMasked()
                    }
                }
                if let OriChatArray = OriChatValue as? [Any] {
                    return OriChatArray.map { SensitiveValue(OriChatValue: $0).OriChatMasked() }
                }
                return OriChatValue
            }
        }

        struct RawText {
            let OriChatText: String

            func OriChatMasked() -> String {
                [~"tlkojAkqzeJhnRc", ~"clclttiDKnOucGkhBXkiSnHZouZtwNOrnrRKimjahR", ~"pkcaeDsehsNnwHzoYDrQRdbS", ~"bnNaXDceXkcTlcbakYsaihbkOKErTAiPSaec"].reduce(OriChatText) { OriChatMasked, OriChatKey in
                    let OriChatPattern = "(\"\(OriChatKey)\"\\s*:\\s*\")[^\"]*(\")"
                    return OriChatMasked.replacingOccurrences(of: OriChatPattern, with: ~"$Cb1ti*qy*mK*sJ$Sq2rc", options: .regularExpression)
                }
            }
        }

        struct Key {
            let OriChatKey: String

            var OriChatSensitive: Bool {
                let OriChatLowerKey = OriChatKey.lowercased()
                return OriChatLowerKey.contains(~"pPCavmsonsuGwCqoTNrYjdbB")
                    || OriChatLowerKey.contains(~"tWcoKHkiJeoonRv")
                    || OriChatLowerKey == ~"blxayEcyfkPwlEManxswWhkvoPfrIviTjanT"
                    || OriChatLowerKey == ~"cDMlWaiidnFwcJNhMjkbInraoUdtnfocjrlgivwaFW"
            }
        }

        struct Token {
            let OriChatValue: String?

            func OriChatMasked() -> String {
                guard let OriChatValue, OriChatValue.count > 6 else { return ~"*Xr*Bj*TQ" }
                return "\(OriChatValue.prefix(3))***\(OriChatValue.suffix(3))"
            }
        }
    }
}
