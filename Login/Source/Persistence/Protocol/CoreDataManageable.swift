//
//  CoreDataManageable.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

protocol CoreDataManageable {
    func createUser(nickname: String, email: String, password: String)
    func fetchUser(email: String) throws -> User
    func deleteUser(with email: String) throws
    func removeAll() throws
}
