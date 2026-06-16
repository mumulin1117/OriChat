import UIKit

final class OriChatTrustAvatarPipeline {
    func load(into imageView: OriaImagewaterRemoteView, profile: OriChatTrustUserProfile) {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        if let avatarURL = profile.avatarURL, avatarURL.isEmpty == false {
            imageView.oriaImagewaterSetURL(avatarURL, placeholderColor: UIColor.white.withAlphaComponent(0.08))
            return
        }
        if let assetName = profile.avatarAssetName, let image = UIImage(named: assetName) {
            imageView.image = image
            imageView.backgroundColor = .clear
            return
        }
        imageView.image = initialsImage(for: profile.name)
    }

    private func initialsImage(for name: String) -> UIImage? {
        let size = CGSize(width: 96, height: 96)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            UIColor(red: 43 / 255, green: 84 / 255, blue: 72 / 255, alpha: 1).setFill()
            UIBezierPath(ovalIn: rect).fill()
            let initial = String(name.trimmingCharacters(in: .whitespacesAndNewlines).prefix(1)).uppercased()
            let text = initial.isEmpty ? "O" : initial
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 38, weight: .bold),
                .foregroundColor: UIColor.white
            ]
            let textSize = text.size(withAttributes: attributes)
            let origin = CGPoint(x: (size.width - textSize.width) / 2, y: (size.height - textSize.height) / 2)
            text.draw(at: origin, withAttributes: attributes)
            context.cgContext.setStrokeColor(UIColor.white.withAlphaComponent(0.18).cgColor)
            context.cgContext.setLineWidth(2)
            context.cgContext.strokeEllipse(in: rect.insetBy(dx: 1, dy: 1))
        }
    }
}
