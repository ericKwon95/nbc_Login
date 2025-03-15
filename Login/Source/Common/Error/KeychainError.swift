//
//  KeychainError.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

enum KeychainError: Error {
    case saveError
    case readError
    case updateError
    case deleteError
    case itemNotFound
}
