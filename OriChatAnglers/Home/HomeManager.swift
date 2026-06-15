import Foundation

struct HomeSnapshot {
    let featured: [HomeDynamicItem]
    let guides: [HomeDynamicItem]
}

final class HomeManager {
    private enum DynamicClassify {
        static let catchSpots = 1
        static let anglerGuides = 2
    }

    private let network: NetworkService
    private let authStore: AuthStore

    init(network: NetworkService = .shared, authStore: AuthStore = .shared) {
        self.network = network
        self.authStore = authStore
    }

    func loadHome(completion: @escaping (Result<HomeSnapshot, Error>) -> Void) {
        let group = DispatchGroup()
        var featured: [HomeDynamicItem] = []
        var guides: [HomeDynamicItem] = []
        var firstError: Error?

        group.enter()
        loadDynamicList(classify: 5) { result in
            if case .success(let items) = result { featured = items }
            if case .failure(let error) = result { firstError = firstError ?? error }
            group.leave()
        }

        group.enter()
        loadDynamicList(classify: 4) { result in
            if case .success(let items) = result { guides = items }
            if case .failure(let error) = result { firstError = firstError ?? error }
            group.leave()
        }

        group.notify(queue: .main) {
            if featured.isEmpty, guides.isEmpty, let firstError {
                completion(.failure(firstError))
            } else {
                completion(.success(HomeSnapshot(featured: featured, guides: guides)))
            }
        }
    }

    private func loadDynamicList(classify: Int, completion: @escaping (Result<[HomeDynamicItem], Error>) -> Void) {
        let payload: [String: Any] = [
            "freshwaterOria": AppConstants.appId,
            "tidelineOria": 1,
            "currentOria": 10,
            "backwaterOria": classify,
            "saltwaterOria": 1,
           
            "estuaryOria": 2
        ]
        network.post(endpoint: .selectDynamicList, payload: payload) { result in
            switch result {
            case .success(let json):
                let items = self.parseItems(from: json)
                print("[OriChat][Home] dynamicList classify=\(classify) count=\(items.count)")
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func parseItems(from json: Any) -> [HomeDynamicItem] {
        let candidates = arrays(in: json)
        let best = candidates.max(by: { $0.count < $1.count }) ?? []
        return best.compactMap { $0 as? [String: Any] }
            .map(HomeDynamicItem.init)
            .filter { $0.id.isEmpty == false || $0.title.isEmpty == false || $0.content.isEmpty == false || $0.primaryImageURL != nil }
    }

    private func arrays(in value: Any) -> [[Any]] {
        if let array = value as? [Any] {
            return [array]
        }
        if let dict = value as? [String: Any] {
            return dict.values.flatMap { arrays(in: $0) }
        }
        return []
    }
}
