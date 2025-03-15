//
//  LoginKeychainStorage.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

/// 키체인에 로그인 상태를 저장하고 관리하는 구조체
struct LoginKeychainStorage: LoginKeychainStorageable {
    // MARK: - Properties

    /// 키체인에서 로그인 상태를 저장하는 키 값
    private let isLoggedInKey = "isLoggedIn"
    /// 키체인 관리 객체
    private let keychainManager: KeychainManageable

    // MARK: - Lifecycle

    /// 키체인 저장소 초기화
    /// - Parameter keychainManager: 키체인 관리 객체
    init(keychainManager: KeychainManageable) {
        self.keychainManager = keychainManager
    }

    // MARK: - Functions

    /// 로그인 상태를 키체인에 저장
    /// - Parameter isLoggedIn: 로그인 상태 (true: 로그인됨, false: 로그아웃됨)
    /// - Throws: 키체인 저장 중 발생할 수 있는 오류
    func setIsLoggedIn(_ isLoggedIn: Bool) async throws {
        let data = String(isLoggedIn).data(using: .utf8)!

        // 기존 데이터가 있다면 업데이트, 없다면 저장
        if try await getIsLoggedIn() {
            try await keychainManager.update(data, forKey: isLoggedInKey)
        } else {
            try await keychainManager.save(data, forKey: isLoggedInKey)
        }
    }

    /// 키체인에서 로그인 상태를 조회
    /// - Returns: 로그인 상태 (true: 로그인됨, false: 로그아웃됨)
    /// - Throws: 키체인 읽기 중 발생할 수 있는 오류
    func getIsLoggedIn() async throws -> Bool {
        do {
            guard let data = try await keychainManager.read(forKey: isLoggedInKey),
                  let stringValue = String(data: data, encoding: .utf8) else {
                return false
            }
            return stringValue == "true"
        } catch {
            return false
        }
    }
}
