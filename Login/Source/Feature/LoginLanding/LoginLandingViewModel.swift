//
//  LoginLandingViewModel.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

import RxRelay
import RxSwift

final class LoginLandingViewModel {
    // MARK: - Nested Types

    struct Input {
        let startButtonTapped: Observable<Void>
    }

    struct Output {}

    // MARK: - Properties

    let navigateToSignUp = PublishRelay<Void>()
    let navigateToLoginSuccess = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    private let loginKeychainStorage: LoginKeychainStorageable

    // MARK: - Lifecycle

    init(loginKeychainStorage: LoginKeychainStorageable) {
        self.loginKeychainStorage = loginKeychainStorage
    }

    // MARK: - Functions

    func transform(input: Input) -> Output {
        input.startButtonTapped
            .subscribe(with: self) { owner, _ in
                Task {
                    if try await owner.isLoggedIn() {
                        Log.log("이미 로그인된 유저입니다. 로그인 성공 화면으로 이동")
                        owner.navigateToLoginSuccess.accept(())
                    } else {
                        Log.log("아직 로그인하지 않은 유저입니다. 회원가입 화면으로 이동")
                        owner.navigateToSignUp.accept(())
                    }
                }
            }
            .disposed(by: disposeBag)

        return Output()
    }
}

extension LoginLandingViewModel {
    private func isLoggedIn() async throws -> Bool {
        try await loginKeychainStorage.getIsLoggedIn()
    }
}
