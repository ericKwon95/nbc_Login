//
//  LoginSuccessViewController.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

final class LoginSuccessViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: LoginSuccessViewModel

    private let titleLabel = TitleLabel()

    private let bodyLabel = BodyLabel().then {
        $0.setText(Constants.LoginSuccess.loginSuccessMessage)
    }

    private let logoutButton = CustomButton(
        style: .confirm,
        title: Constants.LoginSuccess.logoutButtonTitle,
        image: .logout
    )

    private let deleteAccountButton = CustomButton(
        style: .cancel,
        title: Constants.LoginSuccess.deleteAccountButtonTitle,
        image: .deleteAccount
    )

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 16
        $0.distribution = .fill
    }

    private let viewDidLoadRelay = PublishRelay<Void>()

    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(viewModel: LoginSuccessViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureHierarchy()
        configureLayout()
        bind()
        viewDidLoadRelay.accept(())
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

    private func bind() {
        let input = LoginSuccessViewModel.Input(
            viewDidLoad: viewDidLoadRelay.asObservable(),
            logoutTapped: logoutButton.rx.tap.asObservable(),
            deleteAccountTapped: deleteAccountButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(input)

        output.userNickname
            .drive(with: self, onNext: { owner, nickname in
                owner.titleLabel.setText(String(
                    format: Constants.LoginSuccess.welcomeMessageFormat,
                    nickname
                ))
            })
            .disposed(by: disposeBag)
    }
}
