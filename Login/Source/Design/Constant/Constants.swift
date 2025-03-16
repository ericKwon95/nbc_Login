//
//  Constants.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

import UIKit

enum Constants {
    enum LoginLanding {
        static let welcomeTitle = "환영합니다! 😆"
        static let welcomeBody = "로그인하고 다양한 서비스를 이용해보세요."
        static let startButtonTitle = "시작하기"
        static let stackViewSpacing: CGFloat = 16
        static let stackViewInset: CGFloat = 24
        static let welcomeBodySpacing: CGFloat = 32
    }

    enum SignUp {
        static let navigationBarHeight: CGFloat = 44
        static let navigationTitle = "회원가입"
        static let stackViewTopSpacing: CGFloat = 16
        static let horizontalInset: CGFloat = 24
        static let inputFieldSpacing: CGFloat = 4
        static let inputButtonSpacing: CGFloat = 16
        static let signUpButtonTitle = "회원가입"
    }

    enum LoginSuccess {
        static let stackSpacing: CGFloat = 16
        static let bodyToButtonSpacing: CGFloat = 32
        static let horizontalInset: CGFloat = 16
        static let welcomeMessageFormat = "%@ 님, 환영합니다 😃"
        static let loginSuccessMessage = "로그인 성공!"
        static let logoutButtonTitle = "로그아웃"
        static let deleteAccountButtonTitle = "회원탈퇴"
    }
}
