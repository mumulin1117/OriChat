import Foundation

final class AuthStore {
    static let shared = AuthStore()

    private enum Key {
        static let users = "orichat_registered_anglers"
        static let currentEmail = "orichat_current_email"
        static let isLoggedIn = "orichat_is_logged_in"
        static let agreedEULA = "orichat_agreed_eula"
        static let token = "orichat_session_token"
        static let userId = "orichat_user_id"
    }

    private let defaults: UserDefaults

    var isLoggedIn: Bool {
        defaults.bool(forKey: Key.isLoggedIn)
    }

    var agreedEULA: Bool {
        get { defaults.bool(forKey: Key.agreedEULA) }
        set { defaults.set(newValue, forKey: Key.agreedEULA) }
    }

    var sessionToken: String? {
        get { defaults.string(forKey: Key.token) }
        set { defaults.set(newValue, forKey: Key.token) }
    }

    var currentUserId: String? {
        defaults.string(forKey: Key.userId)
    }

    var currentUser: AnglerUser? {
        guard let email = defaults.string(forKey: Key.currentEmail) else { return nil }
        return registeredUsers()[email.lowercased()]
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func register(email: String, password: String, nickname: String) throws -> AnglerUser {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        try validate(email: normalizedEmail, password: password)
        guard nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            throw AuthError.emptyNickname
        }
        var users = registeredUsers()
        guard users[normalizedEmail] == nil else { throw AuthError.accountExists }

        let user = AnglerUser(
            userId: UUID().uuidString,
            email: normalizedEmail,
            password: password,
            nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
            avatarURL: nil,
            token: UUID().uuidString.replacingOccurrences(of: "-", with: "")
        )
        users[normalizedEmail] = user
        save(users: users)
        setLoggedIn(user)
        return user
    }

    func signIn(email: String, password: String) throws -> AnglerUser {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        try validate(email: normalizedEmail, password: password, requireFormatOnly: true)
        let users = registeredUsers()
        guard let user = users[normalizedEmail] else { throw AuthError.accountMissing }
        guard user.password == password else { throw AuthError.incorrectPassword }
        setLoggedIn(user)
        return user
    }

    func mergeRemoteProfile(_ profile: RemoteAuthProfile, for email: String) -> AnglerUser? {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var users = registeredUsers()
        guard var user = users[normalizedEmail] else { return nil }

        if let userId = profile.userId {
            user = AnglerUser(
                userId: userId,
                email: profile.email?.lowercased() ?? user.email,
                password: user.password,
                nickname: profile.nickname ?? user.nickname,
                avatarURL: profile.avatarURL ?? user.avatarURL,
                token: profile.token ?? user.token
            )
        } else {
            user.email = profile.email?.lowercased() ?? user.email
            user.nickname = profile.nickname ?? user.nickname
            user.avatarURL = profile.avatarURL ?? user.avatarURL
            user.token = profile.token ?? user.token
        }

        users.removeValue(forKey: normalizedEmail)
        users[user.email] = user
        save(users: users)
        setLoggedIn(user)
        return user
    }

    func signOut() {
        defaults.set(false, forKey: Key.isLoggedIn)
    }

    private func setLoggedIn(_ user: AnglerUser) {
        defaults.set(true, forKey: Key.isLoggedIn)
        defaults.set(user.email, forKey: Key.currentEmail)
        defaults.set(user.userId, forKey: Key.userId)
        defaults.set(user.token, forKey: Key.token)
    }

    private func registeredUsers() -> [String: AnglerUser] {
        guard let data = defaults.data(forKey: Key.users),
              let users = try? JSONDecoder().decode([String: AnglerUser].self, from: data) else {
            return [:]
        }
        return users
    }

    private func save(users: [String: AnglerUser]) {
        guard let data = try? JSONEncoder().encode(users) else { return }
        defaults.set(data, forKey: Key.users)
    }

    private func validate(email: String, password: String, requireFormatOnly: Bool = false) throws {
        guard email.isEmpty == false else { throw AuthError.emptyEmail }
        guard email.contains("@"), email.contains(".") else { throw AuthError.invalidEmail }
        guard password.isEmpty == false else { throw AuthError.emptyPassword }
        guard requireFormatOnly || password.count >= 6 else { throw AuthError.weakPassword }
    }
}
