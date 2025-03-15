//
//  InputFieldType.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

/// 입력 필드 종류를 나타내는 열거형
enum InputFieldType {
    case email
    case password
    case confirmPassword
    case nickname

    // MARK: - Computed Properties

    var title: String {
        switch self {
        case .email:
            return "이메일 주소"
        case .password:
            return "비밀번호"
        case .confirmPassword:
            return "비밀번호 확인"
        case .nickname:
            return "닉네임"
        }
    }

    var placeholder: String {
        switch self {
        case .email:
            return ""
        case .password:
            return ""
        case .confirmPassword:
            return ""
        case .nickname:
            return ""
        }
    }
}
