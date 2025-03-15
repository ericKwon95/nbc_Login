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
        service = SignUpValidationService()
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
        #expect(result == .invalid)
    }

    @Test("허용되지 않는 문자 포함 이메일 실패 테스트", arguments: [
        "testEmail@example.com", // 대문자
        "test.email!!!@example.com", // 특수문자
        "testEmail@exämple.com", // 비ASCII 문자
        "test space@example.com" // 공백
    ])
    func validateInvalidEmailWithInvalidCharacter(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .invalid)
    }

    @Test("유효하지 않은 이메일 형식 실패 테스트", arguments: [
        "123test@example.com", // 숫자로 시작
        "@example.com", // 로컬 파트 없음
        "test@", // 도메인 없음
        "test@invalid-domain", // 잘못된 도메인
        "test@.com", // 도메인 이름 없음
        "test@example.", // 최상위 도메인 없음
    ])
    func validateEmailFormat(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .invalid)
    }

    @Test("빈 이메일 실패 테스트", arguments: [
        "",
        " ",
    ])
    func validateEmptyEmail(_ email: String) {
        let result = service.validateEmail(email)
        #expect(result == .empty)
    }
}
