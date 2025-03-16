//
//  CryptoUtils.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import CryptoKit
import Foundation

enum CryptoUtils {
    /// 문자열을 SHA256으로 해싱하는 함수
    /// - Parameter input: 해싱할 문자열
    /// - Returns: 해싱된 16진수 문자열
    static func sha256Hash(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        return hashedData.compactMap { String(format: "%02x", $0) }.joined()
    }
}
