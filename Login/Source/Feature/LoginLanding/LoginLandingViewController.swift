//
//  LoginLandingViewController.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import RxCocoa
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

    private let viewModel: LoginLandingViewModel

    // MARK: - Lifecycle

    init(viewModel: LoginLandingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgound()
        configureHierarchy()
        configureLayout()
        bind()
    }

    // MARK: - Functions

    private func configureNavigationItem() {
        navigationController?.isNavigationBarHidden = true
    }

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

    private func bind() {
        let input = LoginLandingViewModel.Input(
            startButtonTapped: startButton.rx.tap.asObservable()
        )
        let _ = viewModel.transform(input)
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginLandingViewController(
        viewModel: LoginLandingViewModel(loginKeychainStorage: MockLoginKeychainStorage())
    )
}

private struct MockLoginKeychainStorage: LoginKeychainStorageable {
    func setIsLoggedIn(_: Bool) async throws {}
    func getIsLoggedIn() async throws -> Bool {
        true
    }
}
