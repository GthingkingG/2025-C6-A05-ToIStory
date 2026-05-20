//
//  DeviceService.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

class DeviceService: DeviceServiceProtocol, BaseAPIService {
    typealias Target = DeviceRouter
    
    var provider: MoyaProvider<Target>
    var decoder: JSONDecoder
    var callbackQueue: DispatchQueue
    
    init(
        decoder: JSONDecoder = APIManager.shared.sharedDecoder,
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = APIManager.shared.createProvider(for: Target.self)
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func getList() -> AnyPublisher<ResponseData<[DeviceDTO]>, MoyaError> {
        request(.getList)
    }
    
    func postReports(report: DeviceReportsRequest) -> AnyPublisher<ResponseData<DeviceResponse>, MoyaError> {
        request(.postReports(report: report))
    }
}
