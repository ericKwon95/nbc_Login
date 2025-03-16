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

    private let navigationBar = CustomNavigationBar()

    private let emailInputField = CustomInputField(with: .email)
    private let passwordInputField = CustomInputField(with: .password)
    private let confirmPasswordInputField = CustomInputField(with: .confirmPassword)
    private let nicknameInputField = CustomInputField(with: .nickname)
    private let signupButton = CustomButton(style: .confirm, title: "회원가입")

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 16
        $0.alignment = .center
    }

    private let viewModel: SignUpViewModel

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
    }

    // MARK: - Functions

    private func configureNavigationItem() {
        navigationBar.configureNavigationItem(title: "회원가입")
        navigationController?.isNavigationBarHidden = true
    }

    private func configureBackground() {
        view.backgroundColor = .appBackground
    }

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
            make.height.equalTo(44)
        }

        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }

    private func bind() {
        let input = SignUpViewModel.Input(
            emailText: emailInputField.rx.text.asObservable(),
            passwordText: passwordInputField.rx.text.asObservable(),
            confirmPasswordText: confirmPasswordInputField.rx.text.asObservable(),
            nicknameText: nicknameInputField.rx.text.asObservable(),
            signUpButtonTapped: signupButton.rx.tap.asObservable()
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
}

// @available(iOS 17.0, *)
// #Preview {
//    SignUpViewController()
// }
