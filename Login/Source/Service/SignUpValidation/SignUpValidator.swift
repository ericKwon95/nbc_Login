//
//  SignUpValidator.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

/// 회원가입 시 필요한 입력값들의 유효성을 검증하는 메서드를 정의합니다.
protocol SignUpValidator {
    func validateEmail(_ email: String) -> EmailValidationResult
    func validatePassword(_ password: String) -> PasswordValidationResult
    func confirmPassword(_ password: String, _ confirmPassword: String) -> Bool
    func validateNickname(_ nickname: String) -> NicknameValidationResult
}
