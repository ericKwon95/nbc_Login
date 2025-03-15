//
//  ValidationResult.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

// MARK: - 회원가입 검증 결과 열거형

enum EmailValidationResult {
    case valid // 유효한 이메일
    case invalid // 유효하지 않은 이메일
    case empty // 빈 문자열
}

enum PasswordValidationResult {
    case valid // 유효한 비밀번호
    case invalidLength // 8자 미만 24자 초과
    case noUppercase // 대문자 없음
    case noSpecialCharacter // 특수문자 없음
    case noNumber // 숫자 없음
    case empty // 빈 문자열
}

enum NicknameValidationResult {
    case valid // 유효하인 닉네임
    case invalidLength // 길이 조건 불만족 (4-12자)
    case invalidCharacter // 특수문자 포함
    case empty // 빈 문자열
}
