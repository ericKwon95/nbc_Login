//
//  HapticService.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import UIKit

enum HapticService {
    case impact(UIImpactFeedbackGenerator.FeedbackStyle)
    case notification(UINotificationFeedbackGenerator.FeedbackType)
    case selection

    // MARK: - Static Properties

    static let impactGenerator = UIImpactFeedbackGenerator()
    static let notificationGenerator = UINotificationFeedbackGenerator()
    static let feedbackGenerator = UISelectionFeedbackGenerator()

    // MARK: - Functions

    func run() {
        switch self {
        case .impact:
            let generator = HapticService.impactGenerator
            generator.prepare()
            generator.impactOccurred()
        case let .notification(type):
            let generator = HapticService.notificationGenerator
            generator.prepare()
            generator.notificationOccurred(type)
        case .selection:
            let generator = HapticService.feedbackGenerator
            generator.prepare()
            generator.selectionChanged()
        }
    }
}
