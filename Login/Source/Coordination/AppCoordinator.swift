//
//  AppCoordinator.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import RxSwift
import UIKit

final class AppCoordinator {
    // MARK: - Properties

    let navigationController: UINavigationController

    private var loginLandingDisposeBag = DisposeBag()
    private var signUpDisposeBag = DisposeBag()
    private var loginSuccessDisposeBag = DisposeBag()

    private let userManager: UserManager
    private let userRepository: UserRepository

    // MARK: - Lifecycle

    init(
        navigationController: UINavigationController,
        userManager: UserManager,
        userRepository: UserRepository
    ) {
        self.navigationController = navigationController
        self.userManager = userManager
        self.userRepository = userRepository
    }

    // MARK: - Functions

    func start() {
        showLoginLanding()
    }

    private func showLoginLanding() {
        loginLandingDisposeBag = DisposeBag()

        let loginLandingViewModel = LoginLandingViewModel(userManager: userManager)
        let loginLandingViewController =
            LoginLandingViewController(viewModel: loginLandingViewModel)

        loginLandingViewModel.navigateToSignUp
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.showSignUp()
            }
            .disposed(by: loginLandingDisposeBag)

        loginLandingViewModel.navigateToLoginSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.showLoginSuccess()
            }
            .disposed(by: loginLandingDisposeBag)

        navigationController.setViewControllers([loginLandingViewController], animated: false)
    }

    private func showSignUp() {
        signUpDisposeBag = DisposeBag()

        let validationService = SignUpValidationService(repository: userRepository)
        let signUpViewModel = SignUpViewModel(
            userRepository: userRepository,
            validationService: validationService,
            userManager: userManager
        )
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)

        signUpViewModel.navigateToLoginSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.showLoginSuccess()
            }
            .disposed(by: signUpDisposeBag)

        signUpViewModel.navigateBack
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.navigationController.popViewController(animated: true)
            }
            .disposed(by: signUpDisposeBag)

        navigationController.pushViewController(signUpViewController, animated: true)
    }

    private func showLoginSuccess() {
        loginSuccessDisposeBag = DisposeBag()

        let loginSuccessViewModel = LoginSuccessViewModel(
            userManager: userManager,
            userRepository: userRepository
        )
        let loginSuccessViewController =
            LoginSuccessViewController(viewModel: loginSuccessViewModel)

        loginSuccessViewModel.navigateToLoginLanding
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self else {
                    return
                }
                navigationController.popToRootViewController(animated: true)
            })
            .disposed(by: loginSuccessDisposeBag)

        navigationController.pushViewController(loginSuccessViewController, animated: true)
    }
}
