//
//  DepartmentRouter.swift
//  Findew
//
//  Created by 내꺼다 on 10/22/25.
//

import Foundation
import Moya
import Alamofire

enum DepartmentRouter {
    /// 소속과 전체 조회
    case getList
}

extension DepartmentRouter: APITargetType {
    var path: String {
        switch self {
        case .getList:
            return "/api/department/all"
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
