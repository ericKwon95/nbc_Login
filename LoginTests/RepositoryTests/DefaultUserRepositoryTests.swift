//
//  DefaultUserRepositoryTests.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

@testable import Login
import Testing

@Suite("User Repository Tests", .serialized)
struct DefaultUserRepositoryTests {
    @Test("유저 생성하기 성공 테스트")
    func createUser() async throws {
        let mockManager = MockCoreDataManager()
        let repository = DefaultUserRepository(coredataManager: mockManager)
        let user = TestConstant.user
        let password = "password"

        repository.createUser(with: user, password: password)

        #expect(mockManager.createUserCalled)
        #expect(mockManager.savedEmail == user.email)
        #expect(mockManager.savedNickname == user.nickname)
        #expect(mockManager.savedPassword == password)
    }

    @Test("유저 조회하기 성공 테스트")
    func fetchUser() throws {
        let mockManager = MockCoreDataManager()
        let repository = DefaultUserRepository(coredataManager: mockManager)
        let expectedUser = TestConstant.user

        let user = try repository.fetchUser(by: expectedUser.email)

        #expect(mockManager.fetchUserCalled)
        #expect(mockManager.savedEmail == expectedUser.email)
        #expect(user == expectedUser)
    }

    @Test("유저 삭제하기 성공 테스트")
    func deleteUser() throws {
        let mockManager = MockCoreDataManager()
        let repository = DefaultUserRepository(coredataManager: mockManager)
        let email = TestConstant.user.email

        try repository.deleteUser(by: email)

        #expect(mockManager.deleteUserCalled)
        #expect(mockManager.savedEmail == email)
    }
}
