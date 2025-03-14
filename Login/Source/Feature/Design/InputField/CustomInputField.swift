//
//  CustomInputField.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import SnapKit
import Then
import UIKit

/// 재사용 가능한 커스텀 입력 필드 뷰
final class CustomInputField: UIView {
    // MARK: - Properties

    private let inputTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .fontBlack
    }

    private let textField = UITextField().then {
        $0.borderStyle = .roundedRect
    }

    // MARK: - Lifecycle

    init(with type: InputFieldType) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureInputField(with: type)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func configureHierarchy() {
        [
            inputTitle,
            textField,
        ].forEach { addSubview($0) }
    }

    private func configureLayout() {
        inputTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(inputTitle.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }

    private func configureInputField(with type: InputFieldType) {
        inputTitle.text = type.title
        textField.placeholder = type.placeholder

        switch type {
        case .email:
            textField.textContentType = .emailAddress
            textField.keyboardType = .emailAddress
        case .password,
             .confirmPassword:
            textField.textContentType = .password
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
        case .nickname:
            textField.textContentType = .nickname
            textField.keyboardType = .asciiCapable
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    CustomInputField(with: .email)
}
