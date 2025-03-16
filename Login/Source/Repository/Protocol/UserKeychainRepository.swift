//
//  UserKeychainRepository.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

protocol UserKeychainRepository {
    func setUserEmail(with email: String) async throws
    func getUserEmail() async throws -> String
    func removeUserEmail() async throws
}
