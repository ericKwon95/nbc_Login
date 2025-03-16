//
//  LoginKeychainStorageable.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

/// 키체인에 로그인 상태를 저장하고 관리하는 프로토콜
protocol LoginKeychainStorageable {
    /// 키체인에 로그인 이메일 주소를 저장
    /// - Parameter email: 이메일 주소
    func setUserEmail(with email: String) async throws
    /// 키체인에서 로그인 이메일 주소를 가져옴
    /// - Returns: 로그인 이메일 주소. 저장된 이메일이 없을 경우 에러 반환
    func getUserEmail() async throws -> String
    /// 키체인에서 로그인한 유저를 삭제
    func removeUserEmail() async throws
}
