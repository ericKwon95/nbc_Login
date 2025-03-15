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

    private let disposeBag = DisposeBag()

    // MARK: - Functions

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        let keychainManager = KeychainManager()
        let loginKeychainStorage = LoginKeychainStorage(keychainManager: keychainManager)
        let loginLandingViewModel =
            LoginLandingViewModel(loginKeychainStorage: loginKeychainStorage)
        let loginLandingViewController =
            LoginLandingViewController(viewModel: loginLandingViewModel)
        let navigationController =
            UINavigationController(rootViewController: loginLandingViewController)

        loginLandingViewModel.navigateToSignUp
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { _, _ in
                let signUpViewController = SignUpViewController()
                navigationController.pushViewController(signUpViewController, animated: true)
            }
            .disposed(by: disposeBag)

        loginLandingViewModel.navigateToLoginSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { _, _ in
                let loginSuccessViewController = LoginSuccessViewController()
                navigationController.pushViewController(loginSuccessViewController, animated: true)
            }
            .disposed(by: disposeBag)

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
