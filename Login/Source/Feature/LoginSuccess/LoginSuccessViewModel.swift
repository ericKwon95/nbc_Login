//
//  LoginSuccessViewModel.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import RxCocoa
import RxRelay
import RxSwift

/// 로그인 성공 화면의 비즈니스 로직을 처리하는 뷰모델
final class LoginSuccessViewModel: ViewModelType {
    // MARK: - Nested Types

    /// 뷰에서 발생하는 이벤트를 처리하기 위한 입력 구조체
    struct Input {
        /// 화면이 로드될 때 발생하는 이벤트
        let viewDidLoad: Observable<Void>
        /// 로그아웃 버튼 탭 이벤트
        let logoutTapped: Observable<Void>
        /// 계정 삭제 버튼 탭 이벤트
        let deleteAccountTapped: Observable<Void>
    }

    /// 뷰에 표시될 데이터를 전달하기 위한 출력 구조체
    struct Output {
        /// 사용자 닉네임을 표시하기 위한 Driver
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

    /// Input을 Output으로 변환하는 메서드
    /// - Parameter input: 뷰로부터 전달받은 Input 객체
    /// - Returns: 변환된 Output 객체
    func transform(_ input: Input) -> Output {
        // 화면 로드 시 현재 사용자의 닉네임을 가져와 바인딩
        input.viewDidLoad
            .withUnretained(self)
            .map { owner, _ in
                let user = owner.userManager.getCurrentUser()
                return user?.nickname ?? ""
            }
            .bind(to: userNickname)
            .disposed(by: disposeBag)

        // 로그아웃 버튼 탭 처리
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

        // 계정 삭제 버튼 탭 처리
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
