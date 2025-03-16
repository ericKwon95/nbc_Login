//
//  MockCoreDataManager.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

@testable import Login

final class MockCoreDataManager: CoreDataManageable {
    // MARK: - Properties

    var createUserCalled = false
    var fetchUserCalled = false
    var deleteUserCalled = false
    var savedEmail: String?
    var savedNickname: String?
    var savedPassword: String?

    // MARK: - Functions

    func createUser(nickname: String, email: String, password: String) {
        createUserCalled = true
        savedNickname = nickname
        savedEmail = email
        savedPassword = password
    }

    func fetchUser(email: String) throws -> User {
        fetchUserCalled = true
        savedEmail = email
        return TestConstant.user
    }

    func deleteUser(with email: String) throws {
        deleteUserCalled = true
        savedEmail = email
    }

    func removeAll() throws {
        // 구현 불필요
    }
}
