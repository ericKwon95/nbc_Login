//
//  CoreDataManagerTests.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

@testable import Login
import Testing

@Suite("Core Data Manager Tests", .serialized)
final class CoreDataManagerTests {
    // MARK: - Properties

    let sut = CoreDataManager.shared
    let user = User(
        nickname: "Nickname",
        email: "testemail@example.com"
    )

    // MARK: - Lifecycle

    deinit {
        do {
            try sut.removeAll()
        } catch {
            #expect(Bool(false))
            Log.error("UserEntity 전체 삭제 실패")
        }
    }

    // MARK: - Functions

    @Test("유저 생성 성공 테스트")
    func createUser() throws {
        sut.createUser(nickname: user.nickname, email: user.email, password: "password123")
        let fetchedUser = try sut.fetchUser(email: user.email)

        #expect(fetchedUser == user)
    }

    @Test("유저 삭제 성공 테스트")
    func deleteUser() throws {
        sut.createUser(nickname: user.nickname, email: user.email, password: "password123")

        try sut.deleteUser(with: user.email)
        do {
            _ = try sut.fetchUser(email: user.email)
        } catch {
            #expect(true)
        }
    }

    @Test("유저 가져오기 성공 테스트")
    func fetchUser() throws {
        sut.createUser(nickname: user.nickname, email: user.email, password: "password123")

        let fetchedUser = try sut.fetchUser(email: user.email)
        #expect(user == fetchedUser)
    }
}
