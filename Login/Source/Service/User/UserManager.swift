//
//  UserManager.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

/// 사용자 관리를 담당하는 싱글톤 클래스입니다.
/// 로그인 상태 관리, 사용자 정보 저장 및 조회 기능을 제공합니다.
final class UserManager: UserManageable {
    // MARK: - Static Properties

    /// 싱글톤 인스턴스
    /// 키체인 스토리지와 코어데이터 매니저를 의존성으로 주입받습니다.
    static let shared =
        UserManager(
            userKeychainRepository: DefaultUserKeychainRepository(
                keychainManager: KeychainManager()
            ),
            coreDataManager: CoreDataManager.shared
        )

    // MARK: - Properties

    /// 현재 로그인된 사용자 정보
    private var user: User?
    /// 로그인 관련 키체인 저장소
    private let userKeychainRepository: UserKeychainRepository
    /// 코어데이터 관리자
    private let coreDataManager: CoreDataManageable

    // MARK: - Lifecycle

    /// 생성자
    /// - Parameters:
    ///   - loginKeychainStorage: 로그인 정보를 저장할 키체인 저장소
    ///   - coreDataManager: 사용자 정보를 관리할 코어데이터 매니저
    private init(userKeychainRepository: UserKeychainRepository, coreDataManager: CoreDataManager) {
        self.userKeychainRepository = userKeychainRepository
        self.coreDataManager = coreDataManager
    }

    // MARK: - Functions

    /// 현재 로그인 상태를 확인합니다.
    /// - Returns: 로그인 되어있으면 true, 아니면 false를 반환
    /// - Throws: 키체인 접근 중 발생할 수 있는 에러
    func isLoggedIn() async throws -> Bool {
        do {
            let _ = try await getPreviousLoggedInUserEmail()
            return true
        } catch {
            return false
        }
    }

    /// 사용자 로그인을 처리합니다.
    /// - Parameter user: 로그인할 사용자 정보
    /// - Throws: 키체인 저장 중 발생할 수 있는 에러
    func logIn(with user: User) async throws {
        self.user = user
        try await userKeychainRepository.setUserEmail(with: user.email)
    }

    /// 로그아웃을 처리합니다.
    /// - Throws: 키체인 데이터 삭제 중 발생할 수 있는 에러
    func logOut() async throws {
        user = nil
        try await userKeychainRepository.removeUserEmail()
    }

    /// 이전에 로그인했던 사용자의 이메일을 조회합니다.
    /// - Returns: 이전 로그인 사용자의 이메일
    /// - Throws: 키체인 접근 또는 코어데이터 조회 중 발생할 수 있는 에러
    func getPreviousLoggedInUserEmail() async throws -> String {
        let previousUserEmail = try await userKeychainRepository.getUserEmail()
        try fetchAndSaveUser(email: previousUserEmail)
        return previousUserEmail
    }

    /// 현재 로그인된 사용자 정보를 반환합니다.
    /// - Returns: 현재 로그인된 사용자 정보 (없으면 nil)
    func getCurrentUser() -> User? {
        user
    }
}

extension UserManager {
    /// 사용자 정보를 코어데이터에서 조회하여 UserManager에 저장합니다.
    /// - Parameter email: 조회할 사용자의 이메일
    /// - Throws: 코어데이터 조회 중 발생할 수 있는 에러
    private func fetchAndSaveUser(email: String) throws {
        let previousUser = try coreDataManager.fetchUser(email: email)
        user = previousUser
    }
}
