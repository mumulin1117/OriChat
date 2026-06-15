import UIKit

final class MainTabBarController: UITabBarController {
    private let authStore: AuthStore

    init(authStore: AuthStore) {
        self.authStore = authStore
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        selectedIndex = 0
    }

    private func configureTabBar() {
        let home = wrap(HomeViewController(), title: "Home", idle: "orichat_tab_home_idle", active: "orichat_tab_home_active")
        let community = wrap(CommunityViewController(), title: "Buddy", idle: "orichat_tab_buddy_idle", active: "orichat_tab_buddy_active")
        let video = wrap(VideoViewController(), title: "Video", idle: "orichat_tab_video_idle", active: "orichat_tab_video_active")
        let profile = wrap(ProfileViewController(authStore: authStore), title: "Profile", idle: "orichat_tab_profile_idle", active: "orichat_tab_profile_active")
        setViewControllers([home, community, video, profile], animated: false)

        tabBar.isTranslucent = false
        tabBar.backgroundColor = AppConstants.darkBackground
        tabBar.tintColor = AppConstants.accentColor
        tabBar.unselectedItemTintColor = UIColor(red: 132 / 255, green: 140 / 255, blue: 160 / 255, alpha: 1)
    }

    private func wrap(_ controller: UIViewController, title: String, idle: String, active: String) -> UINavigationController {
        controller.title = title
        let nav = OriChatNavigationController(rootViewController: controller)
        nav.setNavigationBarHidden(true, animated: false)
        let idleImage = UIImage(named: idle)?.withRenderingMode(.alwaysOriginal)
        let activeImage = UIImage(named: active)?.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem = UITabBarItem(title: nil, image: idleImage, selectedImage: activeImage)
        nav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        return nav
    }
}

final class OriChatNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.isEmpty == false {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
