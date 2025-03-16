//
//  ViewModelType.swift
//  Login
//
//  Created by 권승용 on 3/16/25.
//

/// MVVM 아키텍처의 뷰모델 구조를 정의하는 프로토콜입니다.
/// Input Output 패턴을 사용하여 뷰와 뷰모델 간의 데이터 흐름을 관리합니다.
protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
