//
//  PasswordValidationTests.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

@testable import Login
import Testing

@Suite("Password Validation Tests")
struct PasswordValidationTests {
    // MARK: - Properties

    var service: SignUpValidationService!

    // MARK: - Lifecycle

    init() {
        service = SignUpValidationService(repository: MockUserRepository())
    }

    // MARK: - Functions

    @Test("유효한 비밀번호 성공 테스트", arguments: [
        "Test1234!",
        "Password1!",
        "Complex123#@",
    ])
    func validateValidPassword(_ password: String) {
        let result = service.validatePassword(password)
        #expect(result == .valid)
    }

    @Test("대문자가 없는 비밀번호 실패 테스트", arguments: [
        "test1234!",
        "password1@",
        "nocaps123#"
    ])
    func validatePasswordWithNoUppercase(_ password: String) {
        let result = service.validatePassword(password)
        #expect(result == .noUppercase)
    }

    @Test("특수문자가 없는 비밀번호 실패 테스트", arguments: [
        "Test1234",
        "Password123",
        "NoSpecial1"
    ])
    func validatePasswordWithNoSpecialChar(_ password: String) {
        let result = service.validatePassword(password)
        #expect(result == .noSpecialCharacter)
    }

    @Test("숫자가 없는 비밀번호 실패 테스트", arguments: [
        "TestPass!",
        "Password@",
        "NoNumber#"
    ])
    func validatePasswordWithNoNumber(_ password: String) {
        let result = service.validatePassword(password)
        #expect(result == .noNumber)
    }

    @Test("유효하지 않은 길이 비밀번호 실패 테스트", arguments: [
        "Test1!", // 너무 짧음
        "A1!" // 최소 길이 미달
    ])
    func validatePasswordWithInvalidLength(_ password: String) {
        let result = service.validatePassword(password)
        #expect(result == .invalidLength)
    }

    @Test("공백 비밀번호 실패 테스트", arguments: [
        " ",
    ])
    func validatePasswordWithWhitespace(_ password: String) {
        let result = service.validatePassword(password)
        #expect(result == .invalidWhitespace)
    }

    @Test("빈 비밀번호 실패 테스트", arguments: [
        "",
    ])
    func validatePasswordWithEmpty(_ password: String) {
        let result = service.validatePassword(password)
        #expect(result == .empty)
    }
}
