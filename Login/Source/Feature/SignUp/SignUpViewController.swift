//
//  SignUpViewController.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

/// 회원가입 뷰컨
final class SignUpViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: SignUpViewModel

    private let navigationBar = CustomNavigationBar()

    private let emailInputField = CustomInputField(with: .email)
    private let passwordInputField = CustomInputField(with: .password)
    private let confirmPasswordInputField = CustomInputField(with: .confirmPassword)
    private let nicknameInputField = CustomInputField(with: .nickname)
    private let signupButton = CustomButton(
        style: .confirm,
        title: Constants.SignUp.signUpButtonTitle
    )

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 4
        $0.alignment = .center
    }

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureBackground()
        configureHierarchy()
        configureLayout()
        bind()
        configureTapGesture()
        configureTextFieldDelegates()
        makeEmailTextFieldFirstResponder()
        configureKeyboardNotifications()
    }

    // MARK: - Functions

    /// 네비게이션 바 설정
    private func configureNavigationItem() {
        navigationBar.configureNavigationItem(title: Constants.SignUp.navigationTitle)
        navigationController?.isNavigationBarHidden = true
    }

    /// 배경색 설정
    private func configureBackground() {
        view.backgroundColor = .appBackground
    }

    /// 뷰 계층 구조 설정
    private func configureHierarchy() {
        [
            emailInputField,
            passwordInputField,
            confirmPasswordInputField,
            nicknameInputField,
            signupButton,
        ].forEach { verticalStackView.addArrangedSubview($0) }

        [
            navigationBar,
            verticalStackView,
        ].forEach { view.addSubview($0) }
    }

    /// 오토레이아웃 설정
    private func configureLayout() {
        [
            emailInputField,
            passwordInputField,
            confirmPasswordInputField,
            nicknameInputField,
            signupButton,
        ].forEach {
            $0.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
            }
        }

        navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Constants.SignUp.navigationBarHeight)
        }

        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(Constants.SignUp.stackViewTopSpacing)
            make.horizontalEdges.equalToSuperview().inset(Constants.SignUp.horizontalInset)
        }

        verticalStackView.setCustomSpacing(
            Constants.SignUp.inputButtonSpacing,
            after: nicknameInputField
        )
    }

    /// 텍스트 필드 델리게이트 설정
    private func configureTextFieldDelegates() {
        emailInputField.textField.delegate = self
        passwordInputField.textField.delegate = self
        confirmPasswordInputField.textField.delegate = self
        nicknameInputField.textField.delegate = self
    }

    /// RxSwift 바인딩 설정
    /// - 입력 필드의 텍스트 변경 감지
    /// - 유효성 검사 결과 적용
    /// - 회원가입 버튼 활성화 상태 관리
    private func bind() {
        let input = SignUpViewModel.Input(
            emailText: emailInputField.rx.text.asObservable(),
            passwordText: passwordInputField.rx.text.asObservable(),
            confirmPasswordText: confirmPasswordInputField.rx.text.asObservable(),
            nicknameText: nicknameInputField.rx.text.asObservable(),
            signUpButtonTapped: signupButton.rx.tap.asObservable(),
            dismissButtonTapped: navigationBar.rx.backButtonTap.asObservable()
        )

        let output = viewModel.transform(input)

        output.validationResult
            .emit(with: self) { owner, validationResult in
                if validationResult is EmailValidationResult {
                    owner.emailInputField.applyValidationResult(validationResult)
                } else if validationResult is PasswordValidationResult {
                    owner.passwordInputField.applyValidationResult(validationResult)
                } else if validationResult is ConfirmPasswordValidationResult {
                    owner.confirmPasswordInputField.applyValidationResult(validationResult)
                } else if validationResult is NicknameValidationResult {
                    owner.nicknameInputField.applyValidationResult(validationResult)
                } else {
                    Log.error("Unknown ValidationResult 방출 - 확인 필요")
                }
            }
            .disposed(by: disposeBag)

        output.isSignUpButtonEnabled
            .drive(with: self) { owner, isEnabled in
                owner.signupButton.setEnableStatus(isEnabled)
            }
            .disposed(by: disposeBag)
    }

    /// 이메일 입력 필드를 first responder 로 설정
    private func makeEmailTextFieldFirstResponder() {
        emailInputField.textField.becomeFirstResponder()
    }
}

// MARK: - 키보드 표시/숨김 관리

extension SignUpViewController {
    /// 키보드 표시/숨김에 따른 뷰 조정을 위한 알림 설정
    private func configureKeyboardNotifications() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, notification in
                owner.keyboardWillShow(notification)
            }
            .disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, notification in
                owner.keyboardWillHide(notification)
            }
            .disposed(by: disposeBag)
    }

    /// 키보드가 표시될 때 호출되는 메서드
    /// 키보드가 활성화되는 시점의 first reponder 텍스트 필드가 키보드 위에 위치하도록 뷰의 위치를 조정.
    private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification
            .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = notification
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification
            .userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
            let currentTextField = view.currentFirstResponder as? UITextField else {
            return
        }

        let keyboardHeight = keyboardFrame.height

        let textFieldMaxY = currentTextField.convert(currentTextField.bounds, to: view).maxY
        let keyboardMinY = view.frame.height - keyboardHeight
        let distance = keyboardMinY - textFieldMaxY - Constants.SignUp
            .minimumSpaceBetweenKeyboardAndTextField

        if distance < 0 {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: UIView.AnimationOptions(rawValue: curve),
                animations: {
                    self.view.frame.origin.y = distance
                }
            )
        }
    }

    /// 키보드가 숨겨질 때 호출되는 메서드
    /// 조정한 위치 복구
    private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification
            .userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = notification
            .userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }

        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: curve),
            animations: {
                self.view.frame.origin.y = 0
            }
        )
    }
}

// MARK: - 빈 화면 탭 시 키보드 내림 기능

extension SignUpViewController {
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func handleTap() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    /// 텍스트필드 리턴 키 누를 때 다음 텍스트필드로 포커스 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailInputField.textField {
            passwordInputField.textField.becomeFirstResponder()
        } else if textField == passwordInputField.textField {
            confirmPasswordInputField.textField.becomeFirstResponder()
        } else if textField == confirmPasswordInputField.textField {
            nicknameInputField.textField.becomeFirstResponder()
        } else if textField == nicknameInputField.textField {
            textField.resignFirstResponder()
        }
        return true
    }
}

// MARK: - 자신 및 서브뷰의 first responder 탐색

extension UIView {
    fileprivate var currentFirstResponder: UIView? {
        if isFirstResponder {
            return self
        }

        for subview in subviews {
            if let firstResponder = subview.currentFirstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
