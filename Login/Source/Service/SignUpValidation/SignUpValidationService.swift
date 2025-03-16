//
//  SignUpValidationService.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

/// 입력값 검증에 활용되는 정규식 네임스페이스
private enum RegexPattern {
    static let localPart = "^[a-z0-9]+$"
    static let domain = "^[a-zA-Z0-9][a-zA-Z0-9-]+(\\.[a-zA-Z0-9-]+)*\\.[a-zA-Z]{2,}$"
    static let uppercase = ".*[A-Z]+.*"
    static let specialChar = ".*[!@#$%^&*()\\-_=+\\[\\]{};:'\",.<>/?]+.*"
    static let whitespace = ".*\\s+.*"
    static let number = ".*[0-9]+.*"
}

/// 회원가입 과정에서 입력 값을 검증하는 서비스
final class SignUpValidationService: SignUpValidator {
    // MARK: - Properties

    private let repository: UserRepository

    // MARK: - Lifecycle

    init(repository: UserRepository) {
        self.repository = repository
    }

    // MARK: - Functions

    /// 이메일 주소의 유효성을 검증합니다.
    /// - Parameter email: 이메일 주소
    /// - Returns: 이메일 주소의 유효성 검증 결과
    func validateEmail(_ email: String) -> EmailValidationResult {
        guard !containsWhitespace(email) else {
            return .invalidWhitespace
        }

        guard !email.isEmpty else {
            return .empty
        }

        let components = email.split(separator: "@")
        guard components.count == 2 else {
            return .invalid
        }

        let localPart = String(components[0])
        let domain = String(components[1])

        guard validateLocalPart(localPart) == .valid else {
            return .invalid
        }

        guard validateDomain(domain) == .valid else {
            return .invalid
        }

        return .valid
    }

    /// 이메일 주소의 중복 여부를 검증합니다.
    /// - Parameter email: 이메일 주소
    /// - Returns: 이메일 주소의 중복 검증 결과
    func validateEmailDuplication(_ email: String) -> EmailValidationResult {
        do {
            _ = try repository.fetchUser(by: email)
            return .duplicated
        } catch {
            return .valid
        }
    }

    /// 비밀번호의 유효성을 검증합니다.
    /// - Parameter password: 비밀번호
    /// - Returns: 비밀번호의 유효성 검증 결과
    func validatePassword(_ password: String) -> PasswordValidationResult {
        guard !containsWhitespace(password) else {
            return .invalidWhitespace
        }

        guard !password.isEmpty else {
            return .empty
        }
        guard (8 ... 24).contains(password.count) else {
            return .invalidLength
        }
        guard containsUppercase(password) else {
            return .noUppercase
        }
        guard containsSpecialCharacter(password) else {
            return .noSpecialCharacter
        }
        guard containsNumber(password) else {
            return .noNumber
        }

        return .valid
    }

    /// 비밀번호와 비밀번호 확인이 일치하는지 검증합니다.
    /// - Parameters:
    ///   - password: 비밀번호
    ///   - confirmPassword: 비밀번호 확인
    /// - Returns: 비밀번호와 비밀번호 확인이 일치하는지 여부
    func confirmPassword(
        _ password: String,
        _ confirmPassword: String
    ) -> ConfirmPasswordValidationResult {
        guard !confirmPassword.isEmpty else {
            return .empty
        }
        return password == confirmPassword ? .valid : .invalid
    }

    /// 닉네임의 유효성을 검증합니다.
    /// - Parameter nickname: 닉네임
    /// - Returns: 닉네임의 유효성 검증 결과
    func validateNickname(_ nickname: String) -> NicknameValidationResult {
        guard !containsWhitespace(nickname) else {
            return .invalidWhitespace
        }

        guard !nickname.isEmpty else {
            return .empty
        }
        guard (4 ... 12).contains(nickname.count) else {
            return .invalidLength
        }
        guard !containsSpecialCharacter(nickname) else {
            return .invalidCharacter
        }

        return .valid
    }
}

// MARK: - Private Functions

extension SignUpValidationService {
    private func validateLocalPart(_ localPart: String) -> EmailValidationResult {
        guard (6 ... 20).contains(localPart.count) else {
            return .invalid
        }

        if let firstChar = localPart.first, firstChar.isNumber {
            return .invalid
        }

        guard localPart.range(of: RegexPattern.localPart, options: .regularExpression) != nil else {
            return .invalid
        }

        return .valid
    }

    private func validateDomain(_ domain: String) -> EmailValidationResult {
        guard domain.range(of: RegexPattern.domain, options: .regularExpression) != nil else {
            return .invalid
        }

        return .valid
    }

    private func containsUppercase(_ text: String) -> Bool {
        text.range(of: RegexPattern.uppercase, options: .regularExpression) != nil
    }

    private func containsSpecialCharacter(_ text: String) -> Bool {
        text.range(of: RegexPattern.specialChar, options: .regularExpression) != nil
    }

    private func containsNumber(_ text: String) -> Bool {
        text.range(of: RegexPattern.number, options: .regularExpression) != nil
    }

    private func containsWhitespace(_ text: String) -> Bool {
        text.range(of: RegexPattern.whitespace, options: .regularExpression) != nil
    }
}
