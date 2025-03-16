//
//  LoginSuccessViewModel.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import RxCocoa
import RxRelay
import RxSwift

final class LoginSuccessViewModel: ViewModelType {
    // MARK: - Nested Types

    struct Input {
        let viewDidLoad: Observable<Void>
        let logoutTapped: Observable<Void>
        let deleteAccountTapped: Observable<Void>
    }

    struct Output {
        let userNickname: Driver<String>
    }

    // MARK: - Properties

    let navigateToLoginLanding = PublishRelay<Void>()

    private let userNickname = BehaviorRelay(value: "")
    private let disposeBag = DisposeBag()

    private let userManager: UserManageable
    private let userRepository: UserRepository

    // MARK: - Lifecycle

    init(userManager: UserManageable, userRepository: UserRepository) {
        self.userManager = userManager
        self.userRepository = userRepository
    }

    // MARK: - Functions

    func transform(_ input: Input) -> Output {
        input.viewDidLoad
            .withUnretained(self)
            .map { owner, _ in
                let user = owner.userManager.getCurrentUser()
                return user?.nickname ?? ""
            }
            .bind(to: userNickname)
            .disposed(by: disposeBag)

        input.logoutTapped
            .subscribe(with: self) { owner, _ in
                Log.log("로그아웃 버튼 탭")
                Task {
                    do {
                        try await owner.userManager.logOut()
                        owner.navigateToLoginLanding.accept(())
                    } catch {
                        Log.error("로그아웃 실패 : \(error)")
                    }
                }
            }
            .disposed(by: disposeBag)

        input.deleteAccountTapped
            .subscribe(with: self) { owner, _ in
                Log.log("계정 삭제 버튼 탭")
                guard let currentUserEmail = owner.userManager.getCurrentUser()?.email else {
                    return
                }
                do {
                    try owner.userRepository.deleteUser(by: currentUserEmail)
                    owner.navigateToLoginLanding.accept(())
                } catch {
                    Log.error("계정 삭제 실패 : \(error)")
                }
            }
            .disposed(by: disposeBag)

        return Output(
            userNickname: userNickname.asDriver()
        )
    }
}
