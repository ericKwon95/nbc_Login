//
//  KeychainManageable.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

import Foundation

/// 키체인 데이터 관리를 위한 프로토콜
protocol KeychainManageable {
    /// 키체인에 데이터를 저장하는 메서드
    /// - Parameters:
    ///   - data: 저장할 데이터
    ///   - key: 데이터를 식별하기 위한 키 값
    /// - Throws: 키체인 저장 과정에서 발생할 수 있는 에러
    func save(_ data: Data, forKey key: String) async throws

    /// 키체인에서 데이터를 읽어오는 메서드
    /// - Parameter key: 읽어올 데이터의 키 값
    /// - Returns: 키에 해당하는 데이터. 데이터가 없는 경우 nil 반환
    /// - Throws: 키체인 읽기 과정에서 발생할 수 있는 에러
    func read(forKey key: String) async throws -> Data?

    /// 키체인의 기존 데이터를 업데이트하는 메서드
    /// - Parameters:
    ///   - data: 새로운 데이터
    ///   - key: 업데이트할 데이터의 키 값
    /// - Throws: 키체인 업데이트 과정에서 발생할 수 있는 에러
    func update(_ data: Data, forKey key: String) async throws

    /// 키체인에서 데이터를 삭제하는 메서드
    /// - Parameter key: 삭제할 데이터의 키 값
    /// - Throws: 키체인 삭제 과정에서 발생할 수 있는 에러
    func delete(forKey key: String) async throws
}
