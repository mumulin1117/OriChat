import UIKit

final class RemoteImageView: UIImageView {
    private static let cache = NSCache<NSURL, UIImage>()
    private var currentURL: URL?

    func setImageURL(_ urlString: String?, placeholderColor: UIColor = UIColor(white: 0.16, alpha: 1)) {
        currentURL = nil
        image = nil
        backgroundColor = placeholderColor
        guard let urlString,
              let url = URL(string: urlString),
              ["http", "https"].contains(url.scheme?.lowercased() ?? "") else {
            return
        }
        currentURL = url
        if let cached = Self.cache.object(forKey: url as NSURL) {
            image = cached
            backgroundColor = .clear
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            Self.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                guard self?.currentURL == url else { return }
                self?.image = image
                self?.backgroundColor = .clear
            }
        }.resume()
    }
}
