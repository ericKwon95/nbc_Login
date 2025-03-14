//
//  StartViewController.swift
//  Login
//
//  Created by 권승용 on 3/14/25.
//

import UIKit
import SnapKit

final class StartViewController: UIViewController {
    private lazy var startView = StartView() { [weak self] in
        self?.startViewTapped()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
    }
    
    private func configureHierarchy() {
        [
            startView
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
