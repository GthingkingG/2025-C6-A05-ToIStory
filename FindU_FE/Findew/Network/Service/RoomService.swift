//
//  RoomService.swift
//  Findew
//
//  Created by 내꺼다 on 11/14/25.
//

import Foundation
import Moya
import Combine

class RoomService: RoomServiceProtocol, BaseAPIService {
    typealias Target = RoomRouter
    
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
    
    func getList() -> AnyPublisher<ResponseData<RoomListResponse>, MoyaError> {
        request(.getList)
    }
}
