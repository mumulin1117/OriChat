import UIKit

final class OriChatTrustScoreCardView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let detailLabel = UILabel()
    private let footLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 22
        layer.masksToBounds = true
        gradientLayer.colors = [
            UIColor(red: 37 / 255, green: 83 / 255, blue: 72 / 255, alpha: 1).cgColor,
            UIColor(red: 116 / 255, green: 194 / 255, blue: 114 / 255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)

        titleLabel.text = "Reliability score"
        titleLabel.textColor = UIColor.black.withAlphaComponent(0.66)
        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        scoreLabel.textColor = .black
        scoreLabel.font = .systemFont(ofSize: 48, weight: .heavy)
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.minimumScaleFactor = 0.72
        detailLabel.textColor = UIColor.black.withAlphaComponent(0.72)
        detailLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        detailLabel.numberOfLines = 0
        footLabel.textColor = UIColor.black.withAlphaComponent(0.58)
        footLabel.font = .systemFont(ofSize: 12, weight: .medium)
        footLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [titleLabel, scoreLabel, detailLabel, footLabel])
        stack.axis = .vertical
        stack.spacing = 8
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 176),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame=bounds
    }

    func configure(metrics: OriChatTrustProfileMetrics) {
        if let score = metrics.reliabilityScore {
            scoreLabel.text = String(format: "%.1f", score)
            detailLabel.text = "\(metrics.completedCount) completed trips · \(metrics.cancelsLast30Days) cancels in 30 days"
            footLabel.text = "No-show rate \(metrics.pigeonRateText). Score is calculated from local Fishing Buddy activity and reviews."
        } else {
            scoreLabel.text = "--"
            detailLabel.text = "No completed buddy trips yet"
            footLabel.text = "Join or organize trips to build your OriChat trust profile."
        }
    }
}
