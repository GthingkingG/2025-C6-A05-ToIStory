//
//  PatientRouter.swift
//  Findew
//
//  Created by 내꺼다 on 10/22/25.
//

import Foundation
import Moya
import Alamofire

enum PatientRouter {
    /// 환자 전체 조희
    case getList
    /// 환자 삭제
    case deletePatient(path: PatientDeletPath)
    /// 환자 등록
    case postGenerate(generate: PatientGenerateRequest)
    /// 환자 수정
    case putUpdate(path: PatientUpdatePath, update: PatientUpdateRequest)
    /// 환자 상세 조회
    case getDetail(path: PatientDetailPath)
}

extension PatientRouter: APITargetType {
    var path: String {
        switch self {
        case .getList:
            return "/api/patients/all"
        case .deletePatient(let path):
            return "/api/patients/\(path.id)"
        case .postGenerate:
            return "/api/patients/create"
        case .putUpdate(let path, _):
            return "/api/patients/\(path.id)"
        case .getDetail(let path):
            return "/api/patients/\(path.id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getList, .getDetail:
            return .get
        case .deletePatient:
            return .delete
        case .postGenerate:
            return .post
        case .putUpdate:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getList:
            return .requestPlain
        case .deletePatient:
            return .requestPlain
        case .postGenerate(let generate):
            return .requestJSONEncodable(generate)
        case .putUpdate(_, let update):
            return .requestJSONEncodable(update)
        case .getDetail:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
