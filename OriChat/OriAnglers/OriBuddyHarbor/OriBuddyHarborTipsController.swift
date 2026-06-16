import UIKit

final class OriChatBuddyAITipsController: UIViewController {
    private let answerLabel = UILabel()
    private let answers = [
        "What should I bring for a lake trip?": "Bring water, sun protection, pliers, a small tackle box, and one backup lure. Ask the organizer if rods are provided.",
        "Best lure for bass?": "Start with a soft plastic worm or a small spinnerbait. Slow retrieves work well when the water is calm.",
        "How to join a beginner trip?": "Pick a trip marked Beginner friendly, read the gear note, then apply. Message-style details stay local in this prototype.",
        "Night fishing safety tips": "Bring a headlamp, tell someone your location, stay near the group, and avoid slippery rocks."
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = AppConstants.darkBackground
        let close = UIButton(type: .system)
        close.setImage(UIImage(systemName: "xmark"), for: .normal)
        close.tintColor = .white
        close.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        let title = UILabel()
        title.text = "FishBuddy AI"
        title.textColor = .white
        title.font = .systemFont(ofSize: 30, weight: .bold)

        answerLabel.text = "Pick a question."
        answerLabel.textColor = UIColor.white.withAlphaComponent(0.74)
        answerLabel.font = .systemFont(ofSize: 15)
        answerLabel.numberOfLines = 0

        let questionButtons = answers.keys.sorted().map { question -> UIButton in
            let button = UIButton(type: .system)
            button.setTitle(question, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            button.titleLabel?.numberOfLines = 0
            button.contentHorizontalAlignment = .left
            button.backgroundColor = UIColor(white: 0.12, alpha: 1)
            button.layer.cornerRadius = 16
            button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
            button.addTarget(self, action: #selector(questionTapped(_:)), for: .touchUpInside)
            return button
        }

        let stack = UIStackView(arrangedSubviews: [title] + questionButtons + [answerLabel])
        stack.axis = .vertical
        stack.spacing = 14
        view.addSubview(close)
        view.addSubview(stack)
        close.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            close.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            close.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            close.widthAnchor.constraint(equalToConstant: 44),
            close.heightAnchor.constraint(equalToConstant: 44),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 72),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }

    @objc private func questionTapped(_ sender: UIButton) {
        answerLabel.text = answers[sender.title(for: .normal) ?? ""]
    }

    @objc private func closeTapped() {
        dismiss(animated: true)
    }
}
