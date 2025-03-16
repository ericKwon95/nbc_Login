//
//  EmailValidationTests.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

@testable import Login
import Testing

@Suite("Email Validation Tests")
struct EmailValidationTests {
    // MARK: - Properties

    var service: SignUpValidationService!

    // MARK: - Lifecycle

    init() {
        service = SignUpValidationService(repository: MockUserRepository())
    }

    // MARK: - Functions

    @Test("유효한 이메일 성공 테스트", arguments: [
        "testemail@example.com",
    ])
    func validateValidEmail(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .valid)
    }

    @Test("이메일 길이 실패 테스트", arguments: [
        "abcde@test.com",
        "abcdefghijklmnopqrstu@test.com",
    ])
    func validateEmailLength(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .invalidLength)
    }

    @Test("공백 포함 이메일 실패 테스트", arguments: [
        "test email@example.com",
    ])
    func validateEmailWithWhitespace(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .invalidWhitespace)
    }

    @Test("허용되지 않는 문자 포함 이메일 실패 테스트", arguments: [
        "testEmail@example.com", // 대문자
        "test.email!!!@example.com", // 특수문자
        "testEmail@exämple.com", // 비ASCII 문자
    ])
    func validateInvalidEmailWithInvalidCharacter(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .invalidCharacter)
    }

    @Test("유효하지 않은 이메일 형식 실패 테스트", arguments: [
        "@example.com", // 로컬 파트 없음
        "testtt@", // 도메인 없음

    ])
    func validateEmailFormat(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .invalid)
    }

    @Test("유효하지 않은 도메인 실패 테스트", arguments: [
        "testtt@invalid-domain", // 잘못된 도메인
        "testtt@.com", // 도메인 이름 없음
        "testtt@example.", // 최상위 도메인 없음
    ])
    func validateInvalidDomain(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .invalidDomain)
    }

    @Test("숫자로 시작하는 이메일 실패 테스트", arguments: [
        "123abc@example.com", // 숫자로 시작
    ])
    func validateEmailStartingWithNumber(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .startsWithNumber)
    }

    @Test("빈 이메일 실패 테스트", arguments: [
        "", // 공백
    ])
    func validateEmptyEmail(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .empty)
    }
}
