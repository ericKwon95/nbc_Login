//
//  SceneDelegate.swift
//  Login
//
//  Created by 권승용 on 3/13/25.
//

import RxSwift
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Properties

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    // MARK: - Functions

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        // 의존성 초기화
        let coreDataManager = CoreDataManager.shared
        let userManager = UserManager.shared
        let userRepository = DefaultUserRepository(coredataManager: coreDataManager)

        // 네비게이션 컨트롤러 및 코디네이터 설정
        let navigationController = UINavigationController()
        appCoordinator = AppCoordinator(
            navigationController: navigationController,
            userManager: userManager,
            userRepository: userRepository
        )

        // 윈도우 설정 및 코디네이터 시작
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        appCoordinator?.start()
    }

    func sceneDidEnterBackground(_: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
