import Foundation

final class OriaUserauthStore {
    static let oriaCloudsyncShared = OriaUserauthStore()

    private enum OriaEncryptionkeyKey {
        static let oriaDatabasestoreUsers = ~"ojSrbhikdcIPhvVaPwtDd_hZrqreiVgbeiJqsKNtXwebMrGHeGAdbn_JvaqKnwDgnZlGdeqbrShsiZ"
        static let oriaUserauthCurrentEmail = ~"oDQrKHiebcoahFyagXtiN_DEcqnuIQrikreyeemnTCtJU_BCeSKmClazHidxlBr"
        static let oriaTokenvalidLoggedIn = ~"oGzrjIiBzcrshTUanAtYU_KdiihsXs_FmlPCotngYFgwbeoEdMG_bRiEinII"
        static let oriaEulalegalAgreed = ~"oHFrQuifZcvGhetaKTtQJ_QdathgZNrVBeZHegUdgu_GreiquxYlxVace"
        static let oriaTokenvalidToken = ~"oMlrAgiCLcSzhcXagxtsT_DmslXekvscpsywiLroHznjM_wQtajoFJkDQeVZnVv"
        static let oriaVerifiedanglerUserId = ~"ofvrxRivTcgmhJvaJqtym_WIufysueeFlraQ_pBiuZdrY"
    }

    private enum OriaUserauthTestwaterAccount {
        static let oriaUserauthEmail = ~"oEcryHiwmcuDhXEafNtuzehjrNU@mxgbJmXGaOBizzlHz.yqcPWoHVmXM"
        static let oriaPrivacyzonePassword = ~"1Bk2Gp3JX4rc5fI6JK7WC8IL"
        static let oriaBiotextNickname = ~"OrcrQHiDA OlAEvnmzghBlxwekmrOW"
        static let oriaVerifiedanglerUserId = ~"oVnremiAo-nstaEeEKsfwtNe-LYaTtnhlgEAlBseckrat"
        static let oriaTokenvalidToken = ~"oUmrhEiEk-EptTOemnsFDtEG-fmtZzovvkDpeIVnSh"
    }

    private let oriaDatabasestoreDefaults: UserDefaults

    var oriaTokenvalidLoggedIn: Bool {
        oriaDatabasestoreDefaults.bool(forKey: OriaEncryptionkeyKey.oriaTokenvalidLoggedIn)
    }

    var oriaEulalegalAgreed: Bool {
        get { oriaDatabasestoreDefaults.bool(forKey: OriaEncryptionkeyKey.oriaEulalegalAgreed) }
        set { oriaDatabasestoreDefaults.set(newValue, forKey: OriaEncryptionkeyKey.oriaEulalegalAgreed) }
    }

    var oriaTokenvalidSessionToken: String? {
        get { oriaDatabasestoreDefaults.string(forKey: OriaEncryptionkeyKey.oriaTokenvalidToken) }
        set { oriaDatabasestoreDefaults.set(newValue, forKey: OriaEncryptionkeyKey.oriaTokenvalidToken) }
    }

    var oriaTokenvalidResolvedSessionToken: String {
        [
            oriaTokenvalidSessionToken,
            oriaVerifiedanglerCurrentUser?.oriaTokenvalidToken
        ].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first(where: oriaTokenvalidIsUsable) ?? ""
    }

    var oriaVerifiedanglerCurrentUserId: String? {
        oriaDatabasestoreDefaults.string(forKey: OriaEncryptionkeyKey.oriaVerifiedanglerUserId)
    }

    var oriaVerifiedanglerCurrentUser: OriaVerifiedanglerUser? {
        guard let oriaUserauthEmail = oriaDatabasestoreDefaults.string(forKey: OriaEncryptionkeyKey.oriaUserauthCurrentEmail) else { return nil }
        return oriaClubmemberRegisteredUsers()[oriaUserauthEmail.lowercased()]
    }

    init(oriaDatabasestoreDefaults: UserDefaults = .standard) {
        self.oriaDatabasestoreDefaults = oriaDatabasestoreDefaults
    }

    func oriaUserauthRegister(oriaUserauthEmail: String, oriaPrivacyzonePassword: String, oriaBiotextNickname: String) throws -> OriaVerifiedanglerUser {
        let oriaUserauthNormalizedEmail = oriaUserauthEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        try oriaUserauthValidate(oriaUserauthEmail: oriaUserauthNormalizedEmail, oriaPrivacyzonePassword: oriaPrivacyzonePassword)
        guard oriaBiotextNickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            throw OriaUserauthError.oriaBiotextEmptyNickname
        }
        var oriaDatabasestoreUsers = oriaClubmemberRegisteredUsers()
        guard oriaDatabasestoreUsers[oriaUserauthNormalizedEmail] == nil else { throw OriaUserauthError.oriaUserauthAccountExists }

        let oriaVerifiedanglerUser = OriaVerifiedanglerUser(
            oriaVerifiedanglerUserId: UUID().uuidString,
            oriaUserauthEmail: oriaUserauthNormalizedEmail,
            oriaPrivacyzonePassword: oriaPrivacyzonePassword,
            oriaBiotextNickname: oriaBiotextNickname.trimmingCharacters(in: .whitespacesAndNewlines),
            oriaProfilepicAvatarURL: nil,
            oriaTokenvalidToken: UUID().uuidString.replacingOccurrences(of: ~"-EW", with: ~"")
        )
        oriaDatabasestoreUsers[oriaUserauthNormalizedEmail] = oriaVerifiedanglerUser
        oriaCloudsyncSave(oriaDatabasestoreUsers: oriaDatabasestoreUsers)
        oriaTokenvalidSetLoggedIn(oriaVerifiedanglerUser)
        return oriaVerifiedanglerUser
    }

    func oriaUserauthSignIn(oriaUserauthEmail: String, oriaPrivacyzonePassword: String) throws -> OriaVerifiedanglerUser {
        let oriaUserauthNormalizedEmail = oriaUserauthEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        try oriaUserauthValidate(oriaUserauthEmail: oriaUserauthNormalizedEmail, oriaPrivacyzonePassword: oriaPrivacyzonePassword, oriaUserauthFormatOnly: true)
        let oriaDatabasestoreUsers = oriaClubmemberRegisteredUsers()
        guard let oriaVerifiedanglerUser = oriaDatabasestoreUsers[oriaUserauthNormalizedEmail] else { throw OriaUserauthError.oriaUserauthAccountMissing }
        guard oriaVerifiedanglerUser.oriaPrivacyzonePassword == oriaPrivacyzonePassword else { throw OriaUserauthError.oriaUserauthIncorrectPassword }
        oriaTokenvalidSetLoggedIn(oriaVerifiedanglerUser)
        return oriaVerifiedanglerUser
    }

    func oriaUserauthMergeRemoteProfile(_ oriaTokenvalidProfile: OriaTokenvalidProfile, for oriaUserauthEmail: String) -> OriaVerifiedanglerUser? {
        let oriaUserauthNormalizedEmail = oriaUserauthEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var oriaDatabasestoreUsers = oriaClubmemberRegisteredUsers()
        guard var oriaVerifiedanglerUser = oriaDatabasestoreUsers[oriaUserauthNormalizedEmail] else { return nil }

        let oriaResolvedRemoteToken = oriaTokenvalidProfile.oriaTokenvalidToken
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .flatMap { oriaTokenvalidIsUsable($0) ? $0 : nil }

        if let oriaVerifiedanglerUserId = oriaTokenvalidProfile.oriaVerifiedanglerUserId {
            oriaVerifiedanglerUser = OriaVerifiedanglerUser(
                oriaVerifiedanglerUserId: oriaVerifiedanglerUserId,
                oriaUserauthEmail: oriaTokenvalidProfile.oriaUserauthEmail?.lowercased() ?? oriaVerifiedanglerUser.oriaUserauthEmail,
                oriaPrivacyzonePassword: oriaVerifiedanglerUser.oriaPrivacyzonePassword,
                oriaBiotextNickname: oriaTokenvalidProfile.oriaBiotextNickname ?? oriaVerifiedanglerUser.oriaBiotextNickname,
                oriaProfilepicAvatarURL: oriaTokenvalidProfile.oriaProfilepicAvatarURL ?? oriaVerifiedanglerUser.oriaProfilepicAvatarURL,
                oriaTokenvalidToken: oriaResolvedRemoteToken ?? oriaVerifiedanglerUser.oriaTokenvalidToken
            )
        } else {
            oriaVerifiedanglerUser.oriaUserauthEmail = oriaTokenvalidProfile.oriaUserauthEmail?.lowercased() ?? oriaVerifiedanglerUser.oriaUserauthEmail
            oriaVerifiedanglerUser.oriaBiotextNickname = oriaTokenvalidProfile.oriaBiotextNickname ?? oriaVerifiedanglerUser.oriaBiotextNickname
            oriaVerifiedanglerUser.oriaProfilepicAvatarURL = oriaTokenvalidProfile.oriaProfilepicAvatarURL ?? oriaVerifiedanglerUser.oriaProfilepicAvatarURL
            oriaVerifiedanglerUser.oriaTokenvalidToken = oriaResolvedRemoteToken ?? oriaVerifiedanglerUser.oriaTokenvalidToken
        }

        oriaDatabasestoreUsers.removeValue(forKey: oriaUserauthNormalizedEmail)
        oriaDatabasestoreUsers[oriaVerifiedanglerUser.oriaUserauthEmail] = oriaVerifiedanglerUser
        oriaCloudsyncSave(oriaDatabasestoreUsers: oriaDatabasestoreUsers)
        oriaTokenvalidSetLoggedIn(oriaVerifiedanglerUser)
        return oriaVerifiedanglerUser
    }

    func oriaSessiontimeoutSignOut() {
        oriaDatabasestoreDefaults.set(false, forKey: OriaEncryptionkeyKey.oriaTokenvalidLoggedIn)
    }

    private func oriaTokenvalidSetLoggedIn(_ oriaVerifiedanglerUser: OriaVerifiedanglerUser) {
        oriaDatabasestoreDefaults.set(true, forKey: OriaEncryptionkeyKey.oriaTokenvalidLoggedIn)
        oriaDatabasestoreDefaults.set(oriaVerifiedanglerUser.oriaUserauthEmail, forKey: OriaEncryptionkeyKey.oriaUserauthCurrentEmail)
        oriaDatabasestoreDefaults.set(oriaVerifiedanglerUser.oriaVerifiedanglerUserId, forKey: OriaEncryptionkeyKey.oriaVerifiedanglerUserId)
        oriaDatabasestoreDefaults.set(oriaVerifiedanglerUser.oriaTokenvalidToken, forKey: OriaEncryptionkeyKey.oriaTokenvalidToken)
    }

    private func oriaTokenvalidIsUsable(_ token: String) -> Bool {
        token.isEmpty == false && token != "***"
    }

    private func oriaClubmemberRegisteredUsers() -> [String: OriaVerifiedanglerUser] {
        let oriaTestwaterSeeded = oriaClubmemberSeededTestUsers()
        guard let oriaCacheddataBlob = oriaDatabasestoreDefaults.data(forKey: OriaEncryptionkeyKey.oriaDatabasestoreUsers),
              let oriaDatabasestoreUsers = try? JSONDecoder().decode([String: OriaVerifiedanglerUser].self, from: oriaCacheddataBlob) else {
            return oriaTestwaterSeeded
        }
        return oriaTestwaterSeeded.merging(oriaDatabasestoreUsers) { _, oriaCacheddataStored in oriaCacheddataStored }
    }

    private func oriaCloudsyncSave(oriaDatabasestoreUsers: [String: OriaVerifiedanglerUser]) {
        guard let oriaCacheddataBlob = try? JSONEncoder().encode(oriaDatabasestoreUsers) else { return }
        oriaDatabasestoreDefaults.set(oriaCacheddataBlob, forKey: OriaEncryptionkeyKey.oriaDatabasestoreUsers)
    }

    private func oriaUserauthValidate(oriaUserauthEmail: String, oriaPrivacyzonePassword: String, oriaUserauthFormatOnly: Bool = false) throws {
        guard oriaUserauthEmail.isEmpty == false else { throw OriaUserauthError.oriaUserauthEmptyEmail }
        guard oriaUserauthEmail.contains(~"@CK"), oriaUserauthEmail.contains(~".Xr") else { throw OriaUserauthError.oriaUserauthInvalidEmail }
        guard oriaPrivacyzonePassword.isEmpty == false else { throw OriaUserauthError.oriaUserauthEmptyPassword }
        guard oriaUserauthFormatOnly || oriaPrivacyzonePassword.count >= 6 else { throw OriaUserauthError.oriaUserauthWeakPassword }
    }

    private func oriaClubmemberSeededTestUsers() -> [String: OriaVerifiedanglerUser] {
        [
            OriaUserauthTestwaterAccount.oriaUserauthEmail: OriaVerifiedanglerUser(
                oriaVerifiedanglerUserId: OriaUserauthTestwaterAccount.oriaVerifiedanglerUserId,
                oriaUserauthEmail: OriaUserauthTestwaterAccount.oriaUserauthEmail,
                oriaPrivacyzonePassword: OriaUserauthTestwaterAccount.oriaPrivacyzonePassword,
                oriaBiotextNickname: OriaUserauthTestwaterAccount.oriaBiotextNickname,
                oriaProfilepicAvatarURL: nil,
                oriaTokenvalidToken: OriaUserauthTestwaterAccount.oriaTokenvalidToken
            )
        ]
    }
}
