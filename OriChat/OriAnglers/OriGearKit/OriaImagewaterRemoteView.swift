import UIKit

final class OriaImagewaterRemoteView: UIImageView {
    private static let oriaCacheddataCache = NSCache<NSURL, UIImage>()
    private var oriaTravelrouteCurrentURL: URL?

    func oriaImagewaterSetURL(_ urlString: String?, placeholderColor: UIColor = UIColor(white: 0.16, alpha: 1)) {
        oriaTravelrouteCurrentURL = nil
        image = nil
        backgroundColor = placeholderColor
        guard let urlString,
              let url = URL(string: urlString),
              [~"hyKtAAtpLpWU", ~"huJtSVtFOpJhstu"].contains(url.scheme?.lowercased() ?? ~"") else {
            return
        }
        oriaTravelrouteCurrentURL = url
        if let cached = Self.oriaCacheddataCache.object(forKey: url as NSURL) {
            image = cached
            backgroundColor = .clear
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            Self.oriaCacheddataCache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                guard self?.oriaTravelrouteCurrentURL == url else { return }
                self?.image = image
                self?.backgroundColor = .clear
            }
        }.resume()
    }
}
