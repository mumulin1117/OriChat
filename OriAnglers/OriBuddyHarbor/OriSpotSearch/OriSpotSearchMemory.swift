import Foundation

final class OriChatBuddySearchMemory {
    private let defaults: UserDefaults
    private let key = "OriChat.orichat.buddy.search.recent.v1"
    private let defaultsTerms = ["Lakeside lure", "Night catfish", "Beginner", "Carpool"]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func recentTerms() -> [String] {
        let saved = defaults.stringArray(forKey: key) ?? []
        return saved.isEmpty ? defaultsTerms : saved
    }

    func record(term: String) {
        let clean = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard clean.isEmpty == false else { return }
        let stored = String(clean.prefix(40))
        var items = defaults.stringArray(forKey: key) ?? []
        items.removeAll { $0.caseInsensitiveCompare(stored) == .orderedSame }
        items.insert(stored, at: 0)
        defaults.set(Array(items.prefix(8)), forKey: key)
    }

    func clear() {
        defaults.set([], forKey: key)
    }
}
