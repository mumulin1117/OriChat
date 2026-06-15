import Foundation

struct AnglerUser: Codable, Equatable {
    let userId: String
    var email: String
    var password: String
    var nickname: String
    var avatarURL: String?
    var token: String
}

struct RemoteAuthProfile {
    let userId: String?
    let token: String?
    let email: String?
    let nickname: String?
    let avatarURL: String?

    init(json: Any) {
        let dict = Self.firstDictionary(in: json) ?? [:]
        userId = Self.string(dict["liplesscrankOria"] ?? dict["userId"])
        token = Self.string(dict["clinchknotOria"] ?? dict["token"])
        email = Self.string(dict["flytyingOria"] ?? dict["userEmail"])
        nickname = Self.string(dict["hairjigOria"] ?? dict["userName"])
        avatarURL = Self.string(dict["featherjigOria"] ?? dict["userImgUrl"])
        print("[OriChat][Auth] parsed remote userId=\(userId ?? "missing") token=\(Self.mask(token)) email=\(email ?? "missing")")
    }

    private static func firstDictionary(in value: Any) -> [String: Any]? {
        if let dict = value as? [String: Any] {
            if dict["liplesscrankOria"] != nil || dict["clinchknotOria"] != nil || dict["userId"] != nil || dict["token"] != nil {
                return dict
            }
            for nested in dict.values {
                if let found = firstDictionary(in: nested) {
                    return found
                }
            }
        }
        if let array = value as? [Any] {
            for nested in array {
                if let found = firstDictionary(in: nested) {
                    return found
                }
            }
        }
        return nil
    }

    private static func string(_ value: Any?) -> String? {
        if let string = value as? String, string.isEmpty == false { return string }
        if let number = value as? NSNumber { return number.stringValue }
        return nil
    }

    private static func mask(_ value: String?) -> String {
        guard let value, value.count > 6 else { return "***" }
        return "\(value.prefix(3))***\(value.suffix(3))"
    }
}

enum AuthError: LocalizedError {
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case weakPassword
    case emptyNickname
    case accountExists
    case accountMissing
    case incorrectPassword
    case termsRequired

    var errorDescription: String? {
        switch self {
        case .emptyEmail:
            return "Please enter your email."
        case .emptyPassword:
            return "Please enter your password."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be at least 6 characters."
        case .emptyNickname:
            return "Please enter your name."
        case .accountExists:
            return "Account already exists."
        case .accountMissing:
            return "Account does not exist."
        case .incorrectPassword:
            return "Incorrect password."
        case .termsRequired:
            return "Please agree to the Terms and Privacy Policy."
        }
    }
}
