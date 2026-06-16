import Foundation

enum OriChatBuddySearchState: Equatable {
    case idle
    case showingSuggestions
    case showingResults(query: String, count: Int)
    case empty(query: String)
}

final class OriChatBuddySearchViewModel {
    private let store: OriChatBuddyHarborStore
    private let index: OriChatBuddySearchIndex
    private let memory: OriChatBuddySearchMemory

    private(set) var query = ""
    private(set) var matches: [OriChatBuddySearchMatch] = []
    private(set) var state: OriChatBuddySearchState = .showingSuggestions

    let popularTerms = ["Trout", "Steelhead", "Sea rockfish", "Bass", "Fly fishing"]
    let emptySuggestions = ["Bass", "Lure", "Beginner", "Carpool"]

    init(store: OriChatBuddyHarborStore,
         index: OriChatBuddySearchIndex = OriChatBuddySearchIndex(),
         memory: OriChatBuddySearchMemory = OriChatBuddySearchMemory()) {
        self.store = store
        self.index = index
        self.memory = memory
    }

    func recentTerms() -> [String] {
        memory.recentTerms()
    }

    func clearRecent() {
        memory.clear()
    }

    func setQuery(_ text: String) {
        query = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard query.isEmpty == false else {
            matches = []
            state = .showingSuggestions
            return
        }
        store.reload()
        matches = index.search(query, in: store.trips)
        state = matches.isEmpty ? .empty(query: query) : .showingResults(query: query, count: matches.count)
    }

    func recordCurrentQuery() {
        memory.record(term: query)
    }

    func refresh() {
        setQuery(query)
    }
}
