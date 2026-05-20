//
//  DepartmentService.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Combine
import Moya

class DepartmentService: DepartmentServiceProtocol, BaseAPIService {
    typealias Target = DepartmentRouter
    
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
    
    func getList() -> AnyPublisher<ResponseData<[DepartmentDTO]>, MoyaError> {
        request(.getList)
    }
}
