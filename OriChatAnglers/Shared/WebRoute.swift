import Foundation

enum WebRoute: String {
    case catchDetail = "pages/DynamicDetails/index?dynamicId="
    case guideDetail = "pages/AromatherapyDetails/index?dynamicId="
    case settings = "pages/SetUp/index?"
    case editProfile = "pages/EditData/index?"
    case wallet = "pages/wallet/index?"
    case following = "pages/attentionList/index?type=1"
    case followers = "pages/attentionList/index?type=2"
    case userHomepage = "pages/homepage/index?userId="
    case privateChat = "pages/privateChat/index?userId="
    case terms = "pages/Agreement/index?type=1"
    case privacy = "pages/Agreement/index?type=2"
    case report = "pages/report/index?"

    func finalURL(extraQuery: String? = nil, authStore: AuthStore = .shared) -> URL? {
        var path = rawValue
        if let extraQuery, extraQuery.isEmpty == false {
            if path.last == "=" {
                path += Self.percentEncode(extraQuery)
            } else {
                let separator = path.contains("?") && path.last != "?" ? "&" : ""
                path += "\(separator)\(extraQuery)"
            }
        }
        let separator = path.contains("?") && path.last != "?" ? "&" : ""
        path += "\(separator)token=\(authStore.sessionToken ?? "")&appID=\(AppConstants.appId)"
        let urlString = AppConstants.webBaseURL.absoluteString + path
        print("[OriChat][Web] route=\(self) url=\(mask(urlString))")
        return URL(string: urlString)
    }

    private func mask(_ text: String) -> String {
        guard let tokenRange = text.range(of: "token=") else { return text }
        let prefix = text[..<tokenRange.upperBound]
        let suffixStart = text[tokenRange.upperBound...].firstIndex(of: "&") ?? text.endIndex
        return "\(prefix)***\(text[suffixStart...])"
    }

    private static func percentEncode(_ text: String) -> String {
        text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? text
    }
}
