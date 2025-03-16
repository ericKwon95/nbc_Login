# 회원가입 앱
- 바로인턴 과제 앱 입니다.

## 기술 스택
- UIKit, RxSwift, SnapKit, Then

## 개발 환경
- Xcode 16.2
- macOS 15.3.1
- 최소지원버전 iOS 16.6

## 동작 GIF

| 회원가입 화면 이동 | 로그인 성공 화면 이동 | 시작 화면 이동 |
| -- | -- | -- |
|<img src="https://github.com/user-attachments/assets/c7e3a05a-eca0-4941-b7e0-cdc4d9fb6c0b" width=300>|<img src="https://github.com/user-attachments/assets/516df6b1-1bf4-4c05-ab88-3eefd195ead4" width=300>|<img src="https://github.com/user-attachments/assets/fe4ce81b-323c-48d2-bce4-1e58e9d45572" width=300>|

| 입력 검증 | 중복 이메일 검증 |
| -- | -- |
|<img src="https://github.com/user-attachments/assets/cf96335c-b344-460c-a274-d95a512fe55d" width=300>|<img src="https://github.com/user-attachments/assets/920286fc-75ba-4ddd-b51b-d8858af8cacc" width=300>|

## 개발 과정

### 요구사항 시각화
- Magic Patterns + Figma 활용해 요구사항에 부합한 디자인 초안 작성

<img width="643" alt="Screenshot 2025-03-13 at 4 42 28 PM" src="https://github.com/user-attachments/assets/016d8a24-1c9a-48f1-90c8-e3464e82c690" />

### 프로젝트 설계
- 테스트 가능성, 유지보수성 고려 MVVM 패턴 도입
- 데이터 흐름 명확성 위해 Input Output 패턴 도입
- 공용 컴포넌트 Design 계층으로 분리해 각 뷰컨에서 재사용
- 서비스 계층에 햅틱, 회원가입 입력 필드 검증 로직, 유저 관리 객체 역할 분리
- 레포지토리 계층에 유저 레포지토리 역할 분리
- 영속성 계층에 코어데이터, 키체인 관련 역할 분리
- 네비게이션 역할 코디네이터로 분리
- 각 객체에 DIP 적용, 테스트 가능성 향상
 - 서비스, 영속성 등 주요 기능에 대한 테스트코드 작성 -> **37% 커버리지** 달성
