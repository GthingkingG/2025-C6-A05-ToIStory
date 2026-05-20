//
//  RoomUseCaseProtocol.swift
//  Findew
//
//  Created by 내꺼다 on 11/14/25.
//

import Foundation
import Moya
import Combine

protocol RoomUseCaseProtocol {
    /// 호실 조회
    func executeGetList() -> AnyPublisher<ResponseData<RoomListResponse>, MoyaError>
}
