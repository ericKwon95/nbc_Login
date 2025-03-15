//
//  KeychainManager.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

import Foundation

/// 키체인 데이터 관리를 위한 매니저 구조체
/// KeychainManageable 프로토콜을 준수하여 키체인 CRUD 작업을 수행
struct KeychainManager: KeychainManageable {
    /// 키체인에 데이터를 저장하는 메서드
    /// - Parameters:
    ///   - data: 저장할 데이터
    ///   - key: 데이터를 저장할 키 값
    /// - Throws: KeychainError.saveError 저장 실패시 발생
    func save(_ data: Data, forKey key: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            logStatus(status)
            throw KeychainError.saveError
        }
    }

    /// 키체인에서 데이터를 읽어오는 메서드
    /// - Parameter key: 읽어올 데이터의 키 값
    /// - Returns: 저장된 데이터가 있다면 Data 타입으로 반환, 없다면 nil
    /// - Throws: KeychainError.itemNotFound 항목을 찾을 수 없을 때
    ///          KeychainError.readError 읽기 실패시
    func read(forKey key: String) async throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess else {
            logStatus(status)
            throw status == errSecItemNotFound ? KeychainError.itemNotFound : KeychainError
                .readError
        }

        return result as? Data
    }

    /// 키체인의 기존 데이터를 업데이트하는 메서드
    /// - Parameters:
    ///   - data: 새로운 데이터
    ///   - key: 업데이트할 데이터의 키 값
    /// - Throws: KeychainError.updateError 업데이트 실패시 발생
    func update(_ data: Data, forKey key: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        let attributes: [String: Any] = [kSecValueData as String: data]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status == errSecSuccess else {
            logStatus(status)
            throw KeychainError.updateError
        }
    }

    /// 키체인에서 데이터를 삭제하는 메서드
    /// - Parameter key: 삭제할 데이터의 키 값
    /// - Throws: KeychainError.deleteError 삭제 실패시 발생
    func delete(forKey key: String) async throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            logStatus(status)
            throw KeychainError.deleteError
        }
    }
}

extension KeychainManager {
    /// 키체인 작업 중 발생한 에러를 로깅하는 내부 메서드
    /// - Parameter status: OSStatus 코드
    private func logStatus(_ status: OSStatus) {
        let errorMessage = SecCopyErrorMessageString(status, nil) as? String ?? "Unknown Error"
        Log.error("키체인 에러 : \(errorMessage)")
    }
}
