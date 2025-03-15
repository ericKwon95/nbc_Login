//
//  DefaultUserRepository.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

final class DefaultUserRepository: UserRepository {
    // MARK: - Properties

    private let coredataManager: CoreDataManageable

    // MARK: - Lifecycle

    init(coredataManager: CoreDataManageable) {
        self.coredataManager = coredataManager
    }

    // MARK: - Functions

    func createUser(with user: User, password: String) {
        coredataManager.createUser(nickname: user.nickname, email: user.email, password: password)
    }

    func fetchUser(by email: String) throws -> User {
        try coredataManager.fetchUser(email: email)
    }

    func deleteUser(by email: String) throws {
        try coredataManager.deleteUser(with: email)
    }
}
