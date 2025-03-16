//
//  TitleLabel.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

import UIKit

final class TitleLabel: UILabel {
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func setText(_ text: String) {
        self.text = text
    }

    private func configureLabel() {
        font = .systemFont(ofSize: 24, weight: .regular)
        textColor = .fontBlack
    }
}
