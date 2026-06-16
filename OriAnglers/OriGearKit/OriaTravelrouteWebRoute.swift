import Foundation

enum OriaTravelrouteWebRoute {
    case oriaPopularcatchDetail
    case oriaRiggingguideDetail
    case oriaMasterfishSettings
    case oriaProfilepicEdit
    case oriaVirtualcurrencyWallet
    case oriaFollowerfishFollowing
    case oriaFananglingFollowers
    case oriaProfilepicHomepage
    case oriaReplymessagePrivate
    case oriaTermsconditions
    case oriaPrivacypolicyEula
    case oriaBugreport
    case oriaSystemtideNotifications
    case oriaFishbuddyAiExpert

    private var path: String {
        switch self {
        case .oriaPopularcatchDetail:
            return ~"pIWalqgtWeXKsDP/odDcCybAnwSaSbmDEinncWGDfZeZstfSaBPiUgljMsAH/wSihhnDIdJjeiHxFF?fUdPayzqnlGaWlmRWiTscjmItmdDB=eR"
        case .oriaRiggingguideDetail:
            return ~"pBqaNggBGeGAsbM/oAALbrkJogRmfjaJKtTjhnkeZHrWDaEsphkyuJDWdeUBtFzaTZiMmlVXsIy/MDiYyneTdtfegUxoD?ChdZPyxLnbPatVmWDiTfccuIHBdKv=eh"
        case .oriaMasterfishSettings:
            return ~"pVVadUgMGeOJsMS/KpSPUeEVtWOUGVpkN/yTitynGhdYdenGxbi?no"
        case .oriaProfilepicEdit:
            return ~"prUaRTgPveBRskT/NSEnodERivStGmDkRalNtjKawh/mWiBxniwdVIebDxcN?PK"
        case .oriaVirtualcurrencyWallet:
            return ~"plBaXBgWmeUhswM/nkwcFabQlpwlgxeGutoa/JciUSnXtdNjeZpxgP?kO"
        case .oriaFollowerfishFollowing:
            return ~"pYfaCCgVVekSsDs/ofasntTNtDeezRnDKtwuitnoFunSvLUviqnsAqtQn/ANiCGnYkdaLeXcxNm?HNttCyjZpvHeoj=MC1wN"
        case .oriaFananglingFollowers:
            return ~"pueaingSueVZsPz/NoaZktDztKDeMhnnetgpivFoJPnbuLAziCEsHStJi/ZNiiznoBdSOeBTxEf?OltLcymJpzteYe=xI2ZC"
        case .oriaProfilepicHomepage:
            return ~"pZMatZgbUeOKsIN/KAhpgofEmjbetbpNqaVxgUleym/BQiSnnIUdwdeDLxJf?sFuzvsmCeuarzBINddAM=ap"
        case .oriaReplymessagePrivate:
            return ~"peCaMOgwaenwsOv/DUpPzrHEiSnvWAaQrtJgedbCzehwYaiitsi/jziZYnFTdvOeubxnn?EWuuPsOjeeWrKdILUdcJ=Zz"
        case .oriaTermsconditions:
            return ~"pHCaaXgiSexGsim/iHAvJgqcrOXetMedemuTeBhnNStFv/CbiosnItdCUeVrxQF?wgtbJyWSpWSeLQ=eM1mS"
        case .oriaPrivacypolicyEula:
            return ~"pVWakRggUelYsqX/bFAZOgmkrlzeANelwmMveXqnMXtEH/urihonGtdfYeZmxHL?bdtGlyFQpDSexP=Eo2XN"
        case .oriaBugreport:
            return ~"psUadVgBeemxsJk/HvrgCeCmpVcoQnrMatdN/EXiIKnCSdSZejZxAI?FD"
        case .oriaSystemtideNotifications:
            return ~"palahsgozevGsCN/JUiQbnXifepolwrsDmzKaGRtNYiUfobmnit/pAiwHnDOdKVeRcxYj?fq"
        case .oriaFishbuddyAiExpert:
            return ~"palahsgozevGsCN/JUAQbIXieepxlwpsDezKrGRtNY/UfibmnitdpAewHxDO?KV"
        }
    }

    func oriaTravelrouteFinalURL(oriaDataanglingExtraQuery: String? = nil, authStore: OriaUserauthStore = .oriaCloudsyncShared) -> URL? {
        var path = self.path
        if let oriaDataanglingExtraQuery, oriaDataanglingExtraQuery.isEmpty == false {
            if path.hasSuffix(~"=Qk") {
                path += Self.oriaEncryptionkeyPercentEncode(oriaDataanglingExtraQuery)
            } else {
                let separator = path.contains(~"?Gb") && path.hasSuffix(~"?uL") == false ? ~"&im" : ~""
                path += "\(separator)\(oriaDataanglingExtraQuery)"
            }
        }
        let separator = path.contains(~"?Pr") && path.hasSuffix(~"?KR") == false ? ~"&kw" : ~""
        path += "\(separator)token=\(authStore.oriaTokenvalidResolvedSessionToken)&appID=\(AppConstants.appId)"
        let urlString = AppConstants.webBaseURL.absoluteString + path
        print("[OriChat][Web] route=\(self) url=\(oriaPrivacyzoneMask(urlString))")
        return URL(string: urlString)
    }

    private func oriaPrivacyzoneMask(_ text: String) -> String {
        guard let tokenRange = text.range(of: ~"tfwovMkLkeCYnaI=Dh") else { return text }
        let prefix = text[..<tokenRange.upperBound]
        let suffixStart = text[tokenRange.upperBound...].firstIndex(of: Character(~"&bl")) ?? text.endIndex
        if tokenRange.upperBound == suffixStart {
            return "\(prefix)<missing>\(text[suffixStart...])"
        }
        return "\(prefix)***\(text[suffixStart...])"
    }

    private static func oriaEncryptionkeyPercentEncode(_ text: String) -> String {
        text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? text
    }
}
