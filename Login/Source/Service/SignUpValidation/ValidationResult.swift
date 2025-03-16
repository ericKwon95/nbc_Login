//
//  ValidationResult.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

// MARK: - 회원가입 검증 결과 열거형

protocol ValidationResult {
    var isValid: Bool { get }
    var description: String { get }
}

enum EmailValidationResult: ValidationResult {
    case valid // 유효한 이메일
    case invalid // 유효하지 않은 이메일
    case invalidWhitespace // 공백 포함
    case empty // 빈 문자열
    case duplicated // 중복

    // MARK: - Computed Properties

    var isValid: Bool {
        self == .valid
    }

    var description: String {
        switch self {
        case .valid:
            return "✅ 올바른 이메일 양식 입니다."
        case .invalid:
            return "❌ 올바르지 않은 이메일 양식 입니다."
        case .invalidWhitespace:
            return "❌ 이메일은 공백을 포함할 수 없습니다."
        case .empty:
            return " "
        case .duplicated:
            return "❌ 중복된 이메일 입니다."
        }
    }
}

enum PasswordValidationResult: ValidationResult {
    case valid // 유효한 비밀번호
    case invalidLength // 8자 미만 24자 초과
    case invalidWhitespace // 공백 포함
    case noUppercase // 대문자 없음
    case noSpecialCharacter // 특수문자 없음
    case noNumber // 숫자 없음
    case empty // 빈 문자열

    // MARK: - Computed Properties

    var isValid: Bool {
        self == .valid
    }

    var description: String {
        switch self {
        case .valid:
            return "✅ 유효한 비밀번호 입니다."
        case .invalidLength:
            return "❌ 비밀번호는 8자 이상 24자 이하로 입력해주세요."
        case .invalidWhitespace:
            return "❌ 비밀번호는 공백을 포함할 수 없습니다."
        case .noUppercase:
            return "❌ 비밀번호는 최소 하나 이상의 대문자를 포함해야 합니다."
        case .noSpecialCharacter:
            return "❌ 비밀번호는 최소 하나 이상의 특수문자를 포함해야 합니다."
        case .noNumber:
            return "❌ 비밀번호는 최소 하나 이상의 숫자를 포함해야 합니다."
        case .empty:
            return " "
        }
    }
}

enum ConfirmPasswordValidationResult: ValidationResult {
    case valid
    case invalid
    case empty

    // MARK: - Computed Properties

    var isValid: Bool {
        self == .valid
    }

    var description: String {
        switch self {
        case .valid:
            return "✅ 비밀번호가 일치합니다."
        case .invalid:
            return "❌ 비밀번호가 일치하지 않습니다."
        case .empty:
            return " "
        }
    }
}

enum NicknameValidationResult: ValidationResult {
    case valid // 유효하인 닉네임
    case invalidLength // 길이 조건 불만족 (4-12자)
    case invalidWhitespace // 공백 포함
    case invalidCharacter // 특수문자 포함
    case empty // 빈 문자열

    // MARK: - Computed Properties

    var isValid: Bool {
        self == .valid
    }

    var description: String {
        switch self {
        case .valid:
            return "✅ 유효한 닉네임입니다."
        case .invalidLength:
            return "❌ 닉네임은 4자 이상 12자 이하로 입력해주세요."
        case .invalidWhitespace:
            return "❌ 닉네임은 공백을 포함할 수 없습니다."
        case .invalidCharacter:
            return "❌ 닉네임은 특수문자를 포함할 수 없습니다."
        case .empty:
            return " "
        }
    }
}
