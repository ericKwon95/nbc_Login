//
//  NicknameValidationTests.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

@testable import Login
import Testing

@Suite("Nickname Validation Tests")
struct NicknameValidationTests {
    // MARK: - Properties

    var service: SignUpValidationService!

    // MARK: - Lifecycle

    init() {
        service = SignUpValidationService()
    }

    // MARK: - Functions

    @Test("유효한 닉네임 성공 테스트", arguments: [
        "테스트닉네임",
        "일이삼사오육칠팔",
        "한글닉네임123",
    ])
    func validateValidNickname(_ nickname: String) {
        let result = service.validateNickname(nickname)
        #expect(result == .valid)
    }

    @Test("유효하지 않은 길이 닉네임 실패 테스트", arguments: [
        "짧은닉",
        "매우매우매우긴닉네임테스트"
    ])
    func validateNicknameWithInvalidLength(_ nickname: String) {
        let result = service.validateNickname(nickname)
        #expect(result == .invalidLength)
    }

    @Test("공백이 포함된 닉네임 실패 테스트", arguments: [
        "닉 네임",
    ])
    func validateNicknameWithWhiteSpace(_ nickname: String) {
        let result = service.validateNickname(nickname)
        #expect(result == .invalidWhitespace)
    }

    @Test("특수문자가 포함된 닉네임 실패 테스트", arguments: [
        "닉네임!",
        "테스트@닉네임",
        "한글#닉네임",
        "닉네임.테스트"
    ])
    func validateNicknameWithSpecialCharacters(_ nickname: String) {
        let result = service.validateNickname(nickname)
        #expect(result == .invalidCharacter)
    }

    @Test("비어있는 닉네임 실패 테스트", arguments: [
        "",
    ])
    func validateEmptyNickname(_ nickname: String) {
        let result = service.validateNickname(nickname)
        #expect(result == .empty)
    }
}
