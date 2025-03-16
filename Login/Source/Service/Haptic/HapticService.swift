//
//  HapticService.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import UIKit

/// 햅틱 기능 제공 서비스
enum HapticService {
    case selection

    // MARK: - Static Properties

    static let feedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Functions

    func run() {
        switch self {
        case .selection:
            let generator = HapticService.feedbackGenerator
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
