//
//  CoreDataManager.swift
//  Login
//
//  Created by 권승용 on 3/15/25.
//

import CoreData

/// 코어 데이터에서 유저 데이터를 관리하는 매니저 클래스
final class CoreDataManager {
    // MARK: - Static Properties

    static let shared = CoreDataManager()

    // MARK: - Properties

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Login")

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Functions

    /// context를 저장하는 함수. 변경사항이 있을 경우에만 저장
    private func save() {
        guard persistentContainer.viewContext.hasChanges else {
            return
        }

        do {
            try persistentContainer.viewContext.save()
        } catch {
            Log.error("context 저장 실패: \(error.localizedDescription)")
        }
    }
}

extension CoreDataManager: CoreDataManageable {
    /// 새로운 유저를 생성하는 함수
    /// - Parameters:
    ///   - nickname: 닉네임
    ///   - email: 이메일
    ///   - password: 비밀번호
    func createUser(nickname: String, email: String, password: String) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "UserEntity",
            in: persistentContainer.viewContext
        ) else {
            Log.error("UserEntity 불러오기 실패")
            return
        }
        let newUser = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
        newUser.setValue(nickname, forKey: "nickname")
        newUser.setValue(email, forKey: "email")
        newUser.setValue(password, forKey: "password")
        save()
    }

    /// 이메일을 통해 유저를 찾는 함수
    /// - Parameter email: 이메일
    /// - Returns: 유저 객체 (존재하지 않을 경우 nil 반환)
    func fetchUser(email: String) throws -> User {
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)

        let result = try persistentContainer.viewContext.fetch(request)

        guard let userEntity = result.first else {
            Log.error("유저가 존재하지 않음")
            throw CoreDataError.noUser
        }

        guard let nickName = userEntity.nickname,
              let email = userEntity.email else {
            Log.error("유저 정보가 잘못됨")
            throw CoreDataError.userInfoNil
        }

        return User(
            nickname: nickName,
            email: email
        )
    }

    /// 이메일을 통해 유저를 삭제하는 함수
    /// - Parameter email: 이메일
    func deleteUser(with email: String) throws {
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email)

        let result = try persistentContainer.viewContext.fetch(request)

        for user in result {
            persistentContainer.viewContext.delete(user)
        }
        save()
        Log.log("유저 삭제 완료")
    }

    /// UserEntity의 모든 데이터를 삭제하는 함수
    func removeAll() throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        try persistentContainer.viewContext.execute(batchDeleteRequest)
        Log.info("User Entity 데이터 모두 삭제 완료")
    }
}
