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

    private let viewModel: LoginLandingViewModel

    private let welcomeTitleLabel = TitleLabel().then {
        $0.setText(Constants.LoginLanding.welcomeTitle)
    }

    private let welcomeBodyLabel = BodyLabel().then {
        $0.setText(Constants.LoginLanding.welcomeBody)
    }

    private let startButton = CustomButton(
        style: .confirm,
        title: Constants.LoginLanding.startButtonTitle,
        image: .arrowRight
    )

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = Constants.LoginLanding.stackViewSpacing
        $0.alignment = .center
        $0.distribution = .fill
    }

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
            make.horizontalEdges.equalToSuperview().inset(Constants.LoginLanding.stackViewInset)
        }

        verticalStackView.setCustomSpacing(
            Constants.LoginLanding.welcomeBodySpacing,
            after: welcomeBodyLabel
        )
    }

    private func bind() {
        let input = LoginLandingViewModel.Input(
            startButtonTapped: startButton.rx.tap.asObservable()
        )
        let _ = viewModel.transform(input)
    }
}
