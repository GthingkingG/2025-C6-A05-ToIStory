//
//  DeviceUseCase.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
@preconcurrency import Moya
import Combine

class DeviceUseCase: DeviceUseCaseProtocol {
    private let service: DeviceServiceProtocol
    
    init(service: DeviceServiceProtocol = DeviceService()) {
        self.service = service
    }
    /// 기기 전체 조회
    func executeGetList() -> AnyPublisher<ResponseData<[DeviceDTO]>, MoyaError> {
        service.getList()
    }
    /// 기기 신고
    func executePostReports(report: DeviceReportsRequest) -> AnyPublisher<ResponseData<DeviceResponse>, MoyaError> {
        service.postReports(report: report)
    }
}
