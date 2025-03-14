//
//  StartViewController.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import SnapKit
import UIKit

final class StartViewController: UIViewController {
    // MARK: - Properties

    private lazy var startView = StartView { [weak self] in
        self?.startViewTapped()
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
            startView,
        ].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        startView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func startViewTapped() {
        print("startViewTapped2")
    }
}

@available(iOS 17.0, *)
#Preview {
    StartViewController()
}
