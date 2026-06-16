import Foundation

struct OriaVerifiedanglerUser: Codable, Equatable {
    let oriaVerifiedanglerUserId: String
    var oriaUserauthEmail: String
    var oriaPrivacyzonePassword: String
    var oriaBiotextNickname: String
    var oriaProfilepicAvatarURL: String?
    var oriaTokenvalidToken: String

    private enum CodingKeys: String, CodingKey {
        case oriaVerifiedanglerUserId
        case oriaUserauthEmail = "email"
        case oriaPrivacyzonePassword = "password"
        case oriaBiotextNickname = "nickname"
        case oriaProfilepicAvatarURL
        case oriaTokenvalidToken = "token"
    }
}

struct OriaTokenvalidProfile {
    let oriaVerifiedanglerUserId: String?
    let oriaTokenvalidToken: String?
    let oriaUserauthEmail: String?
    let oriaBiotextNickname: String?
    let oriaProfilepicAvatarURL: String?

    init(json oriaNetworkpingJSON: Any) {
        let oriaDatabasestoreDict = Self.oriaDatabasestoreFirstDictionary(in: oriaNetworkpingJSON) ?? [:]
        oriaVerifiedanglerUserId = Self.oriaCopyrighttextString(oriaDatabasestoreDict[~"lEbiJMpJqladeNVsDmslWcfPrzvaGonrvkgWOwhrKoiENaZq"] ?? oriaDatabasestoreDict[~"uZxssseaSrcdINVdsS"])
        oriaTokenvalidToken = Self.oriaCopyrighttextString(oriaDatabasestoreDict[~"ckIlzSiionRfcYohhmksMnzyodstHKOYOroWiVwaLl"] ?? oriaDatabasestoreDict[~"tRGoknkHselenge"])
        oriaUserauthEmail = Self.oriaCopyrighttextString(oriaDatabasestoreDict[~"fIWlqlyagtyayePiRlngughGOaVrmuiZNaij"] ?? oriaDatabasestoreDict[~"uEPsaAeOqrvYEHUmzKaJFiFplUb"])
        oriaBiotextNickname = Self.oriaCopyrighttextString(oriaDatabasestoreDict[~"hDwaYziDlrMdjkyiNtgEFOYOrfrijoaNy"] ?? oriaDatabasestoreDict[~"uEAsRTeYnrCBNcwadqmzqepH"])
        oriaProfilepicAvatarURL = Self.oriaCopyrighttextString(oriaDatabasestoreDict[~"fuWeFsazxtuBhLgehDrlGjRciSxgBjOsUrnriLJaKK"] ?? oriaDatabasestoreDict[~"uctscxenSruVInCmTzgTgUrzrAxlnU"])
        print("[OriChat][Auth] parsed remote oriaVerifiedanglerUserId=\(oriaVerifiedanglerUserId ?? ~"mmDiOXstVsiZiDZnISgit") token=\(Self.oriaPrivacyzoneMask(oriaTokenvalidToken)) email=\(oriaUserauthEmail ?? ~"mmDiOXstVsiZiDZnISgit")")
    }

    private static func oriaDatabasestoreFirstDictionary(in oriaRawPayload: Any) -> [String: Any]? {
        if let oriaDatabasestoreDict = oriaRawPayload as? [String: Any] {
            if oriaDatabasestoreDict[~"lZeivnpqrlsHezLsYBsQfcxEriwaQgnQrkspOTHrPxiOcavn"] != nil || oriaDatabasestoreDict[~"cuFlHBiwxnCNctChkPkRRngPoPhtDDOVQrFzibPazK"] != nil || oriaDatabasestoreDict[~"uTzsFEeuLrBbIhrdnR"] != nil || oriaDatabasestoreDict[~"tGdoAkkwneffnOZ"] != nil {
                return oriaDatabasestoreDict
            }
            for oriaNestedPayload in oriaDatabasestoreDict.values {
                if let oriaFoundDictionary = oriaDatabasestoreFirstDictionary(in: oriaNestedPayload) {
                    return oriaFoundDictionary
                }
            }
        }
        if let oriaDatabasestoreArray = oriaRawPayload as? [Any] {
            for oriaNestedPayload in oriaDatabasestoreArray {
                if let oriaFoundDictionary = oriaDatabasestoreFirstDictionary(in: oriaNestedPayload) {
                    return oriaFoundDictionary
                }
            }
        }
        return nil
    }

    private static func oriaCopyrighttextString(_ oriaRawValue: Any?) -> String? {
        if let oriaCopyrighttextString = oriaRawValue as? String, oriaCopyrighttextString.isEmpty == false { return oriaCopyrighttextString }
        if let oriaNumberValue = oriaRawValue as? NSNumber { return oriaNumberValue.stringValue }
        return nil
    }

    private static func oriaPrivacyzoneMask(_ oriaTokenvalidValue: String?) -> String {
        guard let oriaTokenvalidValue, oriaTokenvalidValue.count > 6 else { return ~"*bA*Gp*fu" }
        return "\(oriaTokenvalidValue.prefix(3))***\(oriaTokenvalidValue.suffix(3))"
    }
}

enum OriaUserauthError: LocalizedError {
    case oriaUserauthEmptyEmail
    case oriaUserauthEmptyPassword
    case oriaUserauthInvalidEmail
    case oriaUserauthWeakPassword
    case oriaBiotextEmptyNickname
    case oriaUserauthAccountExists
    case oriaUserauthAccountMissing
    case oriaUserauthIncorrectPassword
    case oriaEulalegalTermsRequired

    var errorDescription: String? {
        oriaErroralertDescription
    }

    var oriaErroralertDescription: String? {
        switch self {
        case .oriaUserauthEmptyEmail:
            return ~"PaglHPeDFaDmsWZeYQ qzeCBnBitEoesIrlR jBykFoCSujprMw JoeRymBvaXNiKelBx.Pw"
        case .oriaUserauthEmptyPassword:
            return ~"PeGlrQeBNalWsEOeaZ GbeRQnhvtGxekFrDT clyTgoKnunArjC vDpvsazzsBRsSmwtsoIQrEKdZI.Ct"
        case .oriaUserauthInvalidEmail:
            return ~"PYHlYdeasaypsaxeLQ yieSMnpAttweklrAB WtawE fCvGoasllABiTTdFq tLejQmzLanIiVwljY EzaxedvJdPcrlheAjsmEsTH.aC"
        case .oriaUserauthWeakPassword:
            return ~"PrCaUNsWysVqwhXoCRrOLdyS wKmfyuhpsGdtYJ TlbRHeUL ePaElttw OTluUeGBaRtsbUtfy Xq6Tq smcsShzxaxXrdRahOcYttzFeSarjGsvG.Ad"
        case .oriaBiotextEmptyNickname:
            return ~"PmrlcKeSfaTTsMKeZC CgemXnFbtQYesErXu bryiaoVYuEArCS dgncwaVXmmDeKk.Nb"
        case .oriaUserauthAccountExists:
            return ~"AuacPxcFiocpuCEnoutcE ofaeylSerESeyialrdevypB TjehRxefiLtsRhtEnsoO.UT"
        case .oriaUserauthAccountMissing:
            return ~"AJCcfIcokoBeurlnnMtIu uhdojoUrercsQw yWnoUozhtOX vMeMNxgaiJqsRftaz.tT"
        case .oriaUserauthIncorrectPassword:
            return ~"IIRnixcHnoWHrPGrhGepYcHftpU ABpvHaDgsrJskOwxDoULrTudHh.yj"
        case .oriaEulalegalTermsRequired:
            return ~"PkClbkeksaKXswJeJC nTauOgMrrvretteOD gltccoyZ cXtaNheBeXT yQTkteIbrnSmeAsvk ZQanWnFRdze nCPaCrAhiGMvneavrcGzyaZ gvPaeobIlHciOzcsPyhB.Uv"
        }
    }
}
