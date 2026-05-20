//
//  RoomUseCase.swift
//  Findew
//
//  Created by 내꺼다 on 11/14/25.
//

import Foundation
import Moya
import Combine

class RoomUseCase: RoomUseCaseProtocol {
    private let service: RoomServiceProtocol
    
    init(
        service: RoomServiceProtocol = RoomService()
    ) {
        self.service = service
    }
    
    /// 호실 조회
    func executeGetList() -> AnyPublisher<ResponseData<RoomListResponse>, MoyaError> {
        service.getList()
    }
}
