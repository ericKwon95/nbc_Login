//
//  CustomInputField.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

/// 재사용 가능한 커스텀 입력 필드 뷰
final class CustomInputField: UIView {
    // MARK: - Properties

    let textField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .inputFormBackground
        $0.textColor = .fontBlack
        $0.layer.borderColor = UIColor.cancelButtonStroke.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let inputTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .fontBlack
    }

    private let validationResultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .fontGray
        $0.text = " "
    }

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(with type: InputFieldType) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureInputField(with: type)
        bind()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func applyValidationResult(_ result: ValidationResult) {
        validationResultLabel.text = "\(result.description)"
    }

    private func configureHierarchy() {
        [
            inputTitle,
            textField,
            validationResultLabel,
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
        }

        validationResultLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.equalTo(textField)
            make.height.equalTo(32)
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

    private func bind() {
        // 공백 제거
        textField.rx.text.orEmpty
            .map { $0.replacingOccurrences(of: " ", with: "") }
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: CustomInputField {
    var text: ControlProperty<String> {
        base.textField.rx.text.orEmpty
    }
}

@available(iOS 17.0, *)
#Preview {
    CustomInputField(with: .email)
}
