import UIKit

final class OriChatCatchFeedNavigator {
    private weak var navigationController: UINavigationController?
    private let authStore: AuthStore

    init(navigationController: UINavigationController?, authStore: AuthStore = .shared) {
        self.navigationController = navigationController
        self.authStore = authStore
    }

    func openPostVideo() {
        open(route: .OriChatUserCore, query: "", entry: "Catch Feed Post Video")
    }

    func openVideoDetail(_ item: OriChatCatchVideo) {
        open(route: .OriChatPostArticle, query: item.dynamicId, entry: "Catch Feed Video Detail")
    }

    func openUserHome(userId: String) {
        guard userId.isEmpty == false else { return }
        open(route: .OriChatReportNode, query: userId, entry: "Catch Feed User Home")
    }

    func openReport(for item: OriChatCatchVideo) {
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "dynamicId", value: item.dynamicId),
            URLQueryItem(name: "userId", value: item.userId),
            URLQueryItem(name: "source", value: "catchFeed"),
            URLQueryItem(name: "type", value: "video")
        ]
        let query = components.percentEncodedQuery ?? ""
        open(route: .OriChatAuthVerify, query: query, entry: "Catch Feed Report")
    }

    private func open(route: OriChatVibeRoute, query: String, entry: String) {
        Network.OriChatSessionToken = authStore.sessionToken
        let path = route.OriChatConstructFinalPath(OriChatQuery: query)
        print("[OriChat][Click] entry=\(entry) route=\(route) finalURL=\(mask(path))")
        guard let url = URL(string: path) else {
            print("[OriChat][Click] entry=\(entry) route=\(route) invalid URL")
            return
        }
        navigationController?.pushViewController(WebPortalViewController(url: url), animated: true)
    }

    private func mask(_ text: String) -> String {
        guard let tokenRange = text.range(of: "token=") else { return text }
        let prefix = text[..<tokenRange.upperBound]
        let suffixStart = text[tokenRange.upperBound...].firstIndex(of: "&") ?? text.endIndex
        return "\(prefix)***\(text[suffixStart...])"
    }
}
