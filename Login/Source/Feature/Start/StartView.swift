//
//  StartView.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import SnapKit
import Then
import UIKit

final class StartView: UIView {
    // MARK: - Properties

    let startButtonTapped: () -> Void

    // MARK: - View Property

    private let welcomeTitleLabel = UILabel().then {
        $0.text = "환영합니다!"
        $0.font = .systemFont(ofSize: 24, weight: .regular)
        $0.textColor = .fontBlack
    }

    private let welcomeBodyLabel = UILabel().then {
        $0.text = "Login과의 여정을 시작하세요"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .fontGray
    }

    private lazy var verticalStackView = UIStackView().then {
        $0.addArrangedSubview(welcomeTitleLabel)
        $0.addArrangedSubview(welcomeBodyLabel)
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.spacing = 16
    }

    private let startButton = CustomButton(style: .confirm, title: "시작하기", image: .arrowRight)

    private let rightArrow = UIImageView().then {
        $0.image = .arrowRight
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Lifecycle

    // MARK: - Initializer

    init(startButtonTapped: @escaping () -> Void) {
        self.startButtonTapped = startButtonTapped
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        addButtonAction()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    // MARK: - Configurations

    private func configureHierarchy() {
        [
            verticalStackView,
            startButton,
        ].forEach { addSubview($0) }

        startButton.addSubview(rightArrow)
    }

    private func configureLayout() {
        verticalStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-44)
            make.horizontalEdges.equalToSuperview().inset(24)
        }

        startButton.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        rightArrow.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
    }

    private func addButtonAction() {
        // TODO: 버튼 액션 구독하기
    }
}

@available(iOS 17.0, *)
#Preview {
    StartView {
        print("시작하기 버튼 탭")
    }
}
