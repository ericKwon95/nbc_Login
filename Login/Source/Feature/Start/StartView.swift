//
//  StartView.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import UIKit
import SnapKit
import Then

final class StartView: UIView {
    // MARK: - Property
    
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
    
    private let startButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "시작하기"
        config.baseBackgroundColor = .appPrimary
        return UIButton(configuration: config)
    }()
    
    private let rightArrow = UIImageView().then {
        $0.image = .arrowRight
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Initializer
    
    init(startButtonTapped: @escaping () -> Void) {
        self.startButtonTapped = startButtonTapped
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        addButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
    
    private func configureHierarchy() {
        [
            verticalStackView,
            startButton
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
        startButton.addAction(UIAction(handler: { [weak self] _ in
            self?.startButtonTapped()
        }), for: .touchUpInside)
    }
}

@available(iOS 17.0, *)
#Preview {
    StartView() {
        print("시작하기 버튼 탭")
    }
}
