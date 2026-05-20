//
//  RoomServiceProtocol.swift
//  Findew
//
//  Created by 내꺼다 on 11/14/25.
//

import Foundation
import Moya
import Combine

protocol RoomServiceProtocol {
    /// 호실 데이터 조회
    func getList() -> AnyPublisher<ResponseData<RoomListResponse>, MoyaError>
}
