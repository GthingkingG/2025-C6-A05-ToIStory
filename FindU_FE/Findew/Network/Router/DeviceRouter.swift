//
//  DeviceRouter.swift
//  Findew
//
//  Created by 내꺼다 on 10/22/25.
//

import Foundation
import Moya
import Alamofire

enum DeviceRouter {
    /// 기기 전체 조회
    case getList
    /// 기기 신고
    case postReports(report: DeviceReportsRequest)
}

extension DeviceRouter: APITargetType {
    var path: String {
        switch self {
        case .getList:
            return "/api/devices/all"
        case .postReports:
            return "/api/devices/malfunction"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getList:
            return .get
        case .postReports:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getList:
            return .requestPlain
        case .postReports(let report):
            return .requestJSONEncodable(report)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
