//
//  DepartmentUseCaseProtocol.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

protocol DepartmentUseCaseProtocol {
    /// 소속과 전체 조회
    func executeGetList() -> AnyPublisher<ResponseData<[DepartmentDTO]>, MoyaError>
}
