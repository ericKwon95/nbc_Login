//
//  KeychainManagerTests.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

import Foundation
@testable import Login
import Testing

@Suite(.serialized)
final class KeychainManagerTests {
    // MARK: - Properties

    private let sut = KeychainManager()

    // MARK: - Functions

    @Test
    func saveAndReadData() async throws {
        let testKey = "testKey"
        let testData = "testValue".data(using: .utf8)!

        try await sut.save(testData, forKey: testKey)
        let resultData = try await sut.read(forKey: testKey)

        #expect(resultData == testData)

        try await sut.delete(forKey: testKey)
    }

    @Test
    func saveAndDelete() async throws {
        let testKey = "testKey"
        let testData = "testValue".data(using: .utf8)!

        try await sut.save(testData, forKey: testKey)
        try await sut.delete(forKey: testKey)

        await #expect(throws: KeychainError.itemNotFound, performing: {
            try await sut.read(forKey: testKey)
        })
    }
}

extension KeychainManager {
    func clearAllData() async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecMatchLimit as String: kSecMatchLimitAll,
        ]

        // 현재 저장된 모든 항목 조회
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess {
            if let items = result as? [[String: Any]] {
                for item in items {
                    if let key = item[kSecAttrAccount as String] as? String {
                        // 각 항목 삭제
                        try await delete(forKey: key)
                    }
                }
            }
        }
    }
}
