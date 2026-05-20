//
//  DeviceServiceProtocol.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

protocol DeviceServiceProtocol {
    /// 기기 전체 조회
    func getList() -> AnyPublisher<ResponseData<[DeviceDTO]>, MoyaError>
    /// 기기 신고
    func postReports(report: DeviceReportsRequest) -> AnyPublisher<ResponseData<DeviceResponse>, MoyaError>
}
