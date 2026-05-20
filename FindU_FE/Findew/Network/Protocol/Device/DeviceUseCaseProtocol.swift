//
//  DeviceUseCaseProtocol.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

protocol DeviceUseCaseProtocol {
    /// 기기 전체 조회
    func executeGetList() -> AnyPublisher<ResponseData<[DeviceDTO]>, MoyaError>
    /// 기기 신고
    func executePostReports(report: DeviceReportsRequest) -> AnyPublisher<ResponseData<DeviceResponse>, MoyaError>
}
