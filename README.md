# 회원가입 앱

> 바로인턴 과제 앱입니다.

## 기술 스택
- **UIKit, RxSwift, SnapKit, Then, Swift Testing**

## 개발 환경
- **Xcode 16.2**
- **macOS 15.3.1**
- **최소 지원 버전: iOS 16.6**

## 동작 GIF

| 회원가입 화면 이동 | 로그인 성공 화면 이동 | 시작 화면 이동 |
| -- | -- | -- |
|<img src="https://github.com/user-attachments/assets/c7e3a05a-eca0-4941-b7e0-cdc4d9fb6c0b" width=300>|<img src="https://github.com/user-attachments/assets/516df6b1-1bf4-4c05-ab88-3eefd195ead4" width=300>|<img src="https://github.com/user-attachments/assets/fe4ce81b-323c-48d2-bce4-1e58e9d45572" width=300>|

| 입력 검증 | 중복 이메일 검증 |
| -- | -- |
|<img src="https://github.com/user-attachments/assets/cf96335c-b344-460c-a274-d95a512fe55d" width=300>|<img src="https://github.com/user-attachments/assets/920286fc-75ba-4ddd-b51b-d8858af8cacc" width=300>|

---

## 개발 과정

### 요구사항 시각화
- **Magic Patterns와 Figma**를 활용하여 요구사항을 시각적으로 정리하고, 디자인 초안을 작성함.

<img width="643" alt="Screenshot 2025-03-13 at 4 42 28 PM" src="https://github.com/user-attachments/assets/016d8a24-1c9a-48f1-90c8-e3464e82c690" />

### 프로젝트 설계
![프로젝트 아키텍처](https://github.com/user-attachments/assets/3c779d92-5ef9-4c8c-9fc4-3f8c04d40701)

- **테스트 가능성, 유지보수성 고려하여 MVVM 패턴 적용**
- **데이터 흐름 명확성을 위해 Input/Output 패턴 도입**
- **공용 컴포넌트 Design 계층으로 분리하여 재사용성 증가**
- **서비스 계층에 기능별 역할 분리** (햅틱 피드백, 입력 검증, 유저 관리 등)
- **레포지토리 계층에서 데이터 관리 역할 분리** (CoreData, Keychain 활용)
- **Navigation 관리를 위한 Coordinator 패턴 적용**
- **DIP 적용으로 의존성을 줄이고, 테스트 가능성 향상**
- **주요 기능 테스트 코드 작성 (테스트 커버리지: 37%)**

### 반복 작업 줄이기 위한 개발 환경 설정
- **SwiftFormat 도입**
  - 코드 스타일을 일관되게 유지하고, 리뷰 시 가독성을 향상.
  - 불필요한 빈칸, 들여쓰기, 타입 순서 등을 자동 정리하여 유지보수 편리성 증가.

### 코어 기능에 대한 테스트 코드 작성
- **CoreData, Keychain, 입력 검증 로직 등 핵심 기능에 대한 테스트 코드 작성**
- **빠르고 반복적인 테스트로 로직 검증 속도 증가**
- **Swift Testing의 Parameterized Test 적용 → 가독성 높은 테스트 코드 작성**

```swift
@Test("특수문자가 포함된 닉네임 실패 테스트", arguments: [
    "닉네임!",
    "테스트@닉네임",
    "한글#닉네임",
    "닉네임.테스트"
])
func validateNicknameWithSpecialCharacters(_ nickname: String) {
    let result = service.validateNickname(nickname)
    #expect(result == .invalidCharacter)
}
```

### 확장성과 재사용성을 고려한 기능 구현
- **KeychainManager**를 일반적인 CRUD 구조로 설계하여, 인증 및 보안 관련 기능 확장 가능하도록 구현.
- **ValidationResult 프로토콜 적용** → 검증 조건을 쉽게 추가할 수 있도록 추상화.
- **커스텀 UI 컴포넌트 (버튼, 라벨, 텍스트 필드) 생성** → 뷰 역할 분리 및 재사용성 강화.

### UX 개선을 위한 추가 기능
- **회원가입 화면 진입 시, 이메일 텍스트 필드를 first responder로 지정하여 바로 입력 가능하도록 설정**
- **Return 버튼 탭 시, 다음 입력 필드로 자동 이동하여 UX 개선**
- **키보드가 텍스트 필드를 가리지 않도록, 현재 포커싱된 필드에 따라 화면 y축 조정**
- **버튼 탭 시 햅틱 피드백 적용하여 사용자 경험 강화**

### 코드 품질 유지 및 유지보수 편의성 향상
- **중요한 로직 및 복잡한 기능에 대한 주석 작성** → 코드 이해도를 높이고 유지보수 용이하게 함.
- **뷰 컨트롤러에서 사용되는 매직 넘버 및 문자열을 상수화하여 가독성 및 유지보수성 향상.**

## 프로젝트 구조
```
📦Login
 ┣ 📂App
 ┃ ┣ 📂Base.lproj
 ┃ ┃ ┗ 📜LaunchScreen.storyboard
 ┃ ┣ 📂Login.xcdatamodeld
 ┃ ┃ ┣ 📂Login.xcdatamodel
 ┃ ┃ ┃ ┗ 📜contents
 ┃ ┃ ┗ 📜.xccurrentversion
 ┃ ┣ 📜.DS_Store
 ┃ ┣ 📜AppDelegate.swift
 ┃ ┣ 📜Info.plist
 ┃ ┗ 📜SceneDelegate.swift
 ┣ 📂Base.lproj
 ┣ 📂Resource
 ┃ ┗ 📂Assets.xcassets
 ┃ ┃ ┣ 📂AccentColor.colorset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂AppIcon.appiconset
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂Color
 ┃ ┃ ┃ ┣ 📂appBackground.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┣ 📂appPrimary.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┣ 📂cancelButtonBackground.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┣ 📂cancelButtonStroke.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┣ 📂confirmButtonBackground.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┣ 📂fontBlack.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┣ 📂fontGray.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┣ 📂fontWhite.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┣ 📂inputFormBackground.colorset
 ┃ ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┣ 📂Image
 ┃ ┃ ┃ ┣ 📂arrowLeft.imageset
 ┃ ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┃ ┗ 📜Frame.svg
 ┃ ┃ ┃ ┣ 📂arrowRight.imageset
 ┃ ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┃ ┗ 📜Frame.svg
 ┃ ┃ ┃ ┣ 📂deleteAccount.imageset
 ┃ ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┃ ┗ 📜Frame.svg
 ┃ ┃ ┃ ┣ 📂logout.imageset
 ┃ ┃ ┃ ┃ ┣ 📜Contents.json
 ┃ ┃ ┃ ┃ ┗ 📜Frame.svg
 ┃ ┃ ┃ ┗ 📜Contents.json
 ┃ ┃ ┗ 📜Contents.json
 ┣ 📂Source
 ┃ ┣ 📂Common
 ┃ ┃ ┣ 📂Base
 ┃ ┃ ┃ ┗ 📜ViewModelType.swift
 ┃ ┃ ┣ 📂Crypto
 ┃ ┃ ┃ ┗ 📜CryptoUtils.swift
 ┃ ┃ ┣ 📂Error
 ┃ ┃ ┃ ┣ 📜CoreDataError.swift
 ┃ ┃ ┃ ┗ 📜KeychainError.swift
 ┃ ┃ ┗ 📂Log
 ┃ ┃ ┃ ┗ 📜Log.swift
 ┃ ┣ 📂Coordination
 ┃ ┃ ┗ 📜AppCoordinator.swift
 ┃ ┣ 📂Design
 ┃ ┃ ┣ 📂Button
 ┃ ┃ ┃ ┗ 📜CustomButton.swift
 ┃ ┃ ┣ 📂Constant
 ┃ ┃ ┃ ┗ 📜Constants.swift
 ┃ ┃ ┣ 📂InputField
 ┃ ┃ ┃ ┣ 📜CustomInputField.swift
 ┃ ┃ ┃ ┗ 📜InputFieldType.swift
 ┃ ┃ ┣ 📂Label
 ┃ ┃ ┃ ┣ 📜BodyLabel.swift
 ┃ ┃ ┃ ┗ 📜TitleLabel.swift
 ┃ ┃ ┗ 📂NavigationBar
 ┃ ┃ ┃ ┗ 📜CustomNavigationBar.swift
 ┃ ┣ 📂Feature
 ┃ ┃ ┣ 📂LoginLanding
 ┃ ┃ ┃ ┣ 📜LoginLandingViewController.swift
 ┃ ┃ ┃ ┗ 📜LoginLandingViewModel.swift
 ┃ ┃ ┣ 📂LoginSuccess
 ┃ ┃ ┃ ┣ 📜LoginSuccessViewController.swift
 ┃ ┃ ┃ ┗ 📜LoginSuccessViewModel.swift
 ┃ ┃ ┗ 📂SignUp
 ┃ ┃ ┃ ┣ 📜SignUpViewController.swift
 ┃ ┃ ┃ ┗ 📜SignUpViewModel.swift
 ┃ ┣ 📂Model
 ┃ ┃ ┗ 📜User.swift
 ┃ ┣ 📂Persistence
 ┃ ┃ ┣ 📂Protocol
 ┃ ┃ ┃ ┣ 📜CoreDataManageable.swift
 ┃ ┃ ┃ ┗ 📜KeychainManageable.swift
 ┃ ┃ ┣ 📜CoreDataManager.swift
 ┃ ┃ ┗ 📜KeychainManager.swift
 ┃ ┣ 📂Repository
 ┃ ┃ ┣ 📂Protocol
 ┃ ┃ ┃ ┣ 📜UserKeychainRepository.swift
 ┃ ┃ ┃ ┗ 📜UserRepository.swift
 ┃ ┃ ┣ 📜DefaultUserKeychainRepository.swift
 ┃ ┃ ┗ 📜DefaultUserRepository.swift
 ┃ ┗ 📂Service
 ┃ ┃ ┣ 📂Haptic
 ┃ ┃ ┃ ┗ 📜HapticService.swift
 ┃ ┃ ┣ 📂SignUpValidation
 ┃ ┃ ┃ ┣ 📜SignUpValidationService.swift
 ┃ ┃ ┃ ┣ 📜SignUpValidator.swift
 ┃ ┃ ┃ ┗ 📜ValidationResult.swift
 ┃ ┃ ┗ 📂User
 ┃ ┃ ┃ ┣ 📜UserManageable.swift
 ┃ ┃ ┃ ┗ 📜UserManager.swift
 ┗ 📜.DS_Store
```
