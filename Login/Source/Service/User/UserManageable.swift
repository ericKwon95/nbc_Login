//
//  UserManageable.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

/// 사용자 관리와 관련된 핵심 기능을 정의하는 프로토콜
protocol UserManageable {
    /// 사용자의 로그인 상태를 확인
    /// - Returns: 로그인된 상태면 true, 아니면 false
    func isLoggedIn() async throws -> Bool
    
    /// 사용자 로그인을 처리
    /// - Parameter user: 로그인할 사용자 정보
    /// - Throws: 로그인 처리 중 발생할 수 있는 에러
    func logIn(with user: User) async throws
    
    /// 현재 로그인된 사용자를 로그아웃
    /// - Throws: 로그아웃 처리 중 발생할 수 있는 에러
    func logOut() async throws
    
    /// 이전에 로그인했던 사용자의 이메일을 조회
    /// - Returns: 이전 로그인 사용자의 이메일
    /// - Throws: 이메일 조회 중 발생할 수 있는 에러
    func getPreviousLoggedInUserEmail() async throws -> String
    
    /// 현재 로그인된 사용자 정보를 반환
    /// - Returns: 현재 로그인된 사용자 정보. 로그인된 사용자가 없으면 nil
    func getCurrentUser() -> User?
}
