//
//  CustomButton.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import Combine
import SnapKit
import Then
import UIKit

/// 버튼 스타일 종류를 나타내는 열거형
enum CustomButtonStyle {
    case confirm
    case cancel
}

/// 재사용 가능한 커스텀 버튼 뷰
final class CustomButton: UIView {
    // MARK: - Properties

    let tappedSubject = PassthroughSubject<Void, Never>()

    private let imageView = UIImageView()
    private var button = UIButton()

    // MARK: - Lifecycle

    init(
        style: CustomButtonStyle,
        title: String,
        image: UIImage? = nil
    ) {
        super.init(frame: .zero)
        configureAppearance(style: style, title: title, image: image)
        configureHierarchy()
        configureLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func configureHierarchy() {
        addSubview(button)
        button.addSubview(imageView)
    }

    private func configureLayout() {
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44)
        }

        imageView.snp.makeConstraints { make in
            make.leading.equalTo(button.snp.leading).offset(12)
            make.centerY.equalTo(button.snp.centerY)
        }
    }

    private func configureAppearance(style: CustomButtonStyle, title: String, image: UIImage?) {
        imageView.image = image
        switch style {
        case .confirm:
            var configure = UIButton.Configuration.filled()
            configure.title = title
            configure.baseBackgroundColor = .confirmButtonBackground
            configure.baseForegroundColor = .fontWhite
            button = UIButton(configuration: configure)

        case .cancel:
            var configure = UIButton.Configuration.filled()
            configure.title = title
            configure.baseBackgroundColor = .cancelButtonBackground
            configure.baseForegroundColor = .red
            configure.background.strokeColor = .cancelButtonStroke
            configure.background.strokeWidth = 1
            button = UIButton(configuration: configure)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    CustomButton(style: .confirm, title: "Logout", image: nil)
}
