//
//  LoginSuccessViewController.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import SnapKit
import Then
import UIKit

final class LoginSuccessViewController: UIViewController {
    // MARK: - Properties

    private let titleLabel = TitleLabel().then {
        $0.setText("{닉네임} 님, 환영합니다 😃")
    }

    private let bodyLabel = BodyLabel().then {
        $0.setText("로그인 성공!")
    }

    private let logoutButton = CustomButton(style: .confirm, title: "로그아웃", image: .logout)

    private let deleteAccountButton = CustomButton(
        style: .cancel,
        title: "회원탈퇴",
        image: .deleteAccount
    )

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 16
        $0.distribution = .fill
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureHierarchy()
        configureLayout()
    }

    // MARK: - Functions

    private func configureBackground() {
        view.backgroundColor = .appBackground
    }

    private func configureHierarchy() {
        [
            titleLabel,
            bodyLabel,
            logoutButton,
            deleteAccountButton,
        ].forEach { verticalStackView.addArrangedSubview($0) }

        view.addSubview(verticalStackView)
    }

    private func configureLayout() {
        logoutButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        deleteAccountButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }

        verticalStackView.setCustomSpacing(32, after: bodyLabel)

        verticalStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginSuccessViewController()
}
