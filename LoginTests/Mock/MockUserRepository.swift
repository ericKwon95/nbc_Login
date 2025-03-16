//
//  MockUserRepository.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

@testable import Login

final class MockUserRepository: UserRepository {
    func createUser(with _: Login.User, password _: String) {}

    func fetchUser(by _: String) throws -> Login.User {
        User(nickname: "Nickname", email: "testemail@example.com")
    }

    func deleteUser(by _: String) throws {}
}
