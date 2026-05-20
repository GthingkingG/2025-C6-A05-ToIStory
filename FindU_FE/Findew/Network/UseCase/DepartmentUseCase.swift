//
//  DepartmentUseCase.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
@preconcurrency import Moya
import Combine

class DepartmentUseCase: DepartmentUseCaseProtocol {
    private let service: DepartmentServiceProtocol
    
    init(service: DepartmentServiceProtocol = DepartmentService()) {
        self.service = service
    }
    /// 소속과 전체 조회
    func executeGetList() -> AnyPublisher<ResponseData<[DepartmentDTO]>, MoyaError> {
        service.getList()
    }
}
