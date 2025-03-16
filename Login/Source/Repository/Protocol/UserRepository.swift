//
//  UserRepository.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

protocol UserRepository {
    func createUser(with user: User, password: String)
    func fetchUser(by email: String) throws -> User
    func deleteUser(by email: String) throws
}
