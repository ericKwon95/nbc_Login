//
//  Log.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import OSLog

/// 앱 로그 역할 담당하는 커스텀 로거 객체
enum Log {
    // MARK: - Static Properties

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.ericKwon.Login",
        category: "LoggerLog"
    )

    // MARK: - Static Functions

    static func debug(_ message: String) {
        logger.debug("[🔍 DEBUG] \(message)")
    }

    static func info(_ message: String) {
        logger.info("[ℹ️ INFO] \(message)")
    }

    static func warning(_ message: String) {
        logger.warning("[⚠️ WARNING] \(message)")
    }

    static func error(_ message: String) {
        logger.error("[❌ ERROR] \(message)")
    }

    static func fault(_ message: String) {
        logger.fault("[🔥 FAULT] \(message)")
    }
}
