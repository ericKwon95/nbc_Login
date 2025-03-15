//
//  LoginLandingViewController.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import SnapKit
import UIKit

final class LoginLandingViewController: UIViewController {
    // MARK: - Properties

    private let welcomeTitleLabel = TitleLabel().then {
        $0.setText("환영합니다! 😆")
    }

    private let welcomeBodyLabel = BodyLabel().then {
        $0.setText("로그인하고 다양한 서비스를 이용해보세요.")
    }

    private let startButton = CustomButton(style: .confirm, title: "시작하기", image: .arrowRight)

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
        $0.distribution = .fill
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgound()
        configureHierarchy()
        configureLayout()
    }

    // MARK: - Functions

    private func configureBackgound() {
        view.backgroundColor = .appBackground
    }

    private func configureHierarchy() {
        [
            welcomeTitleLabel,
            welcomeBodyLabel,
            startButton,
        ].forEach { verticalStackView.addArrangedSubview($0) }

        [
            verticalStackView,
        ].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }

        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginLandingViewController()
}
