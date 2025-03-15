//
//  LoginKeychainStorageable.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

/// 키체인에 로그인 상태를 저장하고 관리하는 프로토콜
protocol LoginKeychainStorageable {
    /// 로그인 상태를 키체인에 저장
    /// - Parameter isLoggedIn: 로그인 상태 (true: 로그인됨, false: 로그아웃됨)
    /// - Throws: 키체인 저장 중 발생할 수 있는 오류
    func setIsLoggedIn(_ isLoggedIn: Bool) async throws

    /// 키체인에서 로그인 상태를 조회
    /// - Returns: 로그인 상태 (true: 로그인됨, false: 로그아웃됨)
    /// - Throws: 키체인 읽기 중 발생할 수 있는 오류
    func getIsLoggedIn() async throws -> Bool
}
