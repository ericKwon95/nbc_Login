//
//  CustomNavigationBar.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import Combine
import SnapKit
import Then
import UIKit

final class CustomNavigationBar: UIView {
    // MARK: - Properties

    private let backButton = {
        var config = UIButton.Configuration.borderless()
        config.image = .arrowLeft
        config.title = "돌아가기"
        config.baseBackgroundColor = nil
        config.baseForegroundColor = .appPrimary
        return UIButton(configuration: config)
    }()

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .fontBlack
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func configureNavigationItem(title: String) {
        titleLabel.text = title
    }

    private func configureHierarchy() {
        [
            backButton,
            titleLabel,
        ].forEach { addSubview($0) }
    }

    private func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    CustomNavigationBar()
}
