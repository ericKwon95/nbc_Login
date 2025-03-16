//
//  AppCoordinator.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import RxSwift
import UIKit

/// 앱의 전체 네비게이션 흐름을 관리하는 코디네이터 클래스
final class AppCoordinator {
    // MARK: - Properties

    /// 앱의 메인 네비게이션 컨트롤러
    let navigationController: UINavigationController

    /// 각 화면별 Rx 이벤트 구독을 관리하기 위한 DisposeBag
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

    // MARK: - Navigation Functions

    /// 코디네이터 시작 - 초기 화면(로그인 랜딩)을 표시
    func start() {
        showLoginLanding()
    }

    /// 로그인 랜딩 화면을 표시하고 관련 네비게이션 이벤트를 구독
    private func showLoginLanding() {
        loginLandingDisposeBag = DisposeBag()

        let loginLandingViewModel = LoginLandingViewModel(userManager: userManager)
        let loginLandingViewController =
            LoginLandingViewController(viewModel: loginLandingViewModel)

        // 회원가입 화면으로 이동하는 이벤트 구독
        loginLandingViewModel.navigateToSignUp
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.showSignUp()
            }
            .disposed(by: loginLandingDisposeBag)

        // 로그인 성공 화면으로 이동하는 이벤트 구독
        loginLandingViewModel.navigateToLoginSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.showLoginSuccess()
            }
            .disposed(by: loginLandingDisposeBag)

        navigationController.setViewControllers([loginLandingViewController], animated: false)
    }

    /// 회원가입 화면을 표시하고 관련 네비게이션 이벤트를 구독
    private func showSignUp() {
        signUpDisposeBag = DisposeBag()

        let validationService = SignUpValidationService(repository: userRepository)
        let signUpViewModel = SignUpViewModel(
            userRepository: userRepository,
            validationService: validationService,
            userManager: userManager
        )
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)

        // 로그인 성공 화면으로 이동하는 이벤트 구독
        signUpViewModel.navigateToLoginSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.showLoginSuccess()
            }
            .disposed(by: signUpDisposeBag)

        // 뒤로 가기 이벤트 구독
        signUpViewModel.navigateBack
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                owner.navigationController.popViewController(animated: true)
            }
            .disposed(by: signUpDisposeBag)

        navigationController.pushViewController(signUpViewController, animated: true)
    }

    /// 로그인 성공 화면을 표시하고 관련 네비게이션 이벤트를 구독
    private func showLoginSuccess() {
        loginSuccessDisposeBag = DisposeBag()

        let loginSuccessViewModel = LoginSuccessViewModel(
            userManager: userManager,
            userRepository: userRepository
        )
        let loginSuccessViewController =
            LoginSuccessViewController(viewModel: loginSuccessViewModel)

        // 로그인 랜딩 화면으로 돌아가는 이벤트 구독
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
