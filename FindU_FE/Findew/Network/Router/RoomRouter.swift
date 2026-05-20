//
//  RoomRouter.swift
//  Findew
//
//  Created by 내꺼다 on 11/14/25.
//

import Foundation
import Moya
import Alamofire

enum RoomRouter {
    /// 병실 목록 조회
    case getList
}

extension RoomRouter: APITargetType {
    var path: String {
        switch self {
        case .getList:
            return "/api/rooms/all"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getList:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
