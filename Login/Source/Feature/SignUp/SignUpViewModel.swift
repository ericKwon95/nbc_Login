//
//  SignUpViewModel.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

/// 회원가입 화면의 비즈니스 로직을 처리하는 ViewModel
final class SignUpViewModel: ViewModelType {
    // MARK: - Nested Types

    /// ViewModel이 받을 수 있는 입력값들을 정의
    struct Input {
        /// 이메일 텍스트 입력 스트림
        let emailText: Observable<String>
        /// 비밀번호 텍스트 입력 스트림
        let passwordText: Observable<String>
        /// 비밀번호 확인 텍스트 입력 스트림
        let confirmPasswordText: Observable<String>
        /// 닉네임 텍스트 입력 스트림
        let nicknameText: Observable<String>
        /// 회원가입 버튼 탭 이벤트 스트림
        let signUpButtonTapped: Observable<Void>
    }

    /// ViewModel이 출력할 수 있는 값들을 정의
    struct Output {
        /// 유효성 검사 결과 시그널
        let validationResult: Signal<ValidationResult>
        /// 회원가입 버튼 활성화 상태 드라이버
        let isSignUpButtonEnabled: Driver<Bool>
        /// 에러 발생 시그널
        let error: Signal<Error>
    }

    // MARK: - Properties

    /// 회원가입 성공 시 로그인 화면으로 이동하기 위한 릴레이
    let navigateToLoginSuccess = PublishRelay<Void>()

    /// 사용자 정보 관련 저장소
    private let userRepository: UserRepository
    /// 회원가입 입력값 유효성 검사 서비스
    private let validationService: SignUpValidator
    /// 로그인 정보 키체인 저장소
    private let loginKeychainStorage: LoginKeychainStorageable

    /// 유효성 검사 결과를 전달하는 릴레이
    private let validationResultRelay = PublishRelay<ValidationResult>()
    /// 회원가입 버튼 활성화 상태를 관리하는 릴레이
    private let isSignUpButtonEnabledRelay = BehaviorRelay<Bool>(value: false)
    /// 에러 발생을 전달하는 릴레이
    private let errorRelay = PublishRelay<Error>()

    /// Rx 리소스 정리를 위한 DisposeBag
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        userRepository: UserRepository,
        validationService: SignUpValidator,
        loginKeychainStorage: LoginKeychainStorageable
    ) {
        self.userRepository = userRepository
        self.validationService = validationService
        self.loginKeychainStorage = loginKeychainStorage
    }

    // MARK: - Functions

    /// Input을 Output으로 변환하는 메인 함수
    /// - Parameter input: 사용자의 입력값들
    /// - Returns: 처리된 결과값들
    func transform(_ input: Input) -> Output {
        // 각각의 유효성 검사 스트림 설정
        let validationStreams = createValidationStreams(from: input)

        // 모든 유효성 검사 결과를 validationResultRelay에 바인딩
        setupValidationResultBinding(validationStreams)

        // 회원가입 버튼 활성화 상태 바인딩
        setupSignUpButtonBinding(validationStreams: validationStreams)

        // 회원가입 버튼 탭 이벤트 처리
        handleSignUpButtonTap(from: input)

        return Output(
            validationResult: validationResultRelay.asSignal(),
            isSignUpButtonEnabled: isSignUpButtonEnabledRelay.asDriver(),
            error: errorRelay.asSignal()
        )
    }

    // MARK: - Private Functions

    /// 입력값들에 대한 유효성 검사 스트림 생성
    private func createValidationStreams(from input: Input) -> (
        email: Observable<ValidationResult>,
        password: Observable<ValidationResult>,
        confirmPassword: Observable<ValidationResult>,
        nickname: Observable<ValidationResult>
    ) {
        let email = input.emailText
            .withUnretained(self)
            .map { owner, email in
                owner.validationService.validateEmail(email) as ValidationResult
            }

        let password = input.passwordText
            .withUnretained(self)
            .map { owner, password in
                owner.validationService.validatePassword(password) as ValidationResult
            }

        let confirmPassword = input.confirmPasswordText
            .withUnretained(self)
            .withLatestFrom(input.passwordText) { main, password in
                let (owner, confirmPassword) = main
                return owner.validationService.confirmPassword(
                    password,
                    confirmPassword
                ) as ValidationResult
            }

        let nickname = input.nicknameText
            .withUnretained(self)
            .map { owner, nickname in
                owner.validationService.validateNickname(nickname) as ValidationResult
            }

        return (email, password, confirmPassword, nickname)
    }

    /// 모든 유효성 검사 결과를 validationResultRelay에 바인딩
    private func setupValidationResultBinding(_ streams: (
        email: Observable<ValidationResult>,
        password: Observable<ValidationResult>,
        confirmPassword: Observable<ValidationResult>,
        nickname: Observable<ValidationResult>
    )) {
        Observable.merge(
            streams.email,
            streams.password,
            streams.confirmPassword,
            streams.nickname
        )
        .bind(to: validationResultRelay)
        .disposed(by: disposeBag)
    }

    /// 회원가입 버튼 활성화 상태 바인딩 설정
    private func setupSignUpButtonBinding(
        validationStreams streams: (
            email: Observable<ValidationResult>,
            password: Observable<ValidationResult>,
            confirmPassword: Observable<ValidationResult>,
            nickname: Observable<ValidationResult>
        )
    ) {
        Observable.combineLatest(
            streams.email,
            streams.password,
            streams.confirmPassword,
            streams.nickname
        )
        .withUnretained(self)
        .map { _, results in
            let (emailValid, passwordValid, confirmValid, nicknameValid) = results
            return emailValid.isValid &&
                passwordValid.isValid &&
                confirmValid.isValid &&
                nicknameValid.isValid
        }
        .bind(to: isSignUpButtonEnabledRelay)
        .disposed(by: disposeBag)
    }

    /// 회원가입 버튼 탭 이벤트 처리
    private func handleSignUpButtonTap(from input: Input) {
        input.signUpButtonTapped
            .withLatestFrom(Observable.combineLatest(
                input.emailText,
                input.passwordText,
                input.nicknameText
            ))
            .withUnretained(self)
            .flatMap { owner, userData -> Observable<ValidationResult> in
                let (email, password, nickname) = userData

                let validationResult = owner.validationService.validateEmailDuplication(email)

                if validationResult.isValid {
                    let user = User(nickname: nickname, email: email)
                    owner.userRepository.createUser(with: user, password: password)
                    owner.saveLoginInfo()
                    owner.navigateToLoginSuccess.accept(())
                }

                return Observable.just(validationResult)
            }
            .bind(to: validationResultRelay)
            .disposed(by: disposeBag)
    }

    /// 로그인 정보를 키체인에 저장
    private func saveLoginInfo() {
        Task {
            do {
                try await loginKeychainStorage.setIsLoggedIn(true)
            } catch {
                errorRelay.accept(error)
            }
        }
    }
}
