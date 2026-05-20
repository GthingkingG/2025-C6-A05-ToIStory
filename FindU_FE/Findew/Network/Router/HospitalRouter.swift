//
//  HospitalRouter.swift
//  Findew
//
//  Created by 내꺼다 on 10/22/25.
//

import Foundation
import Moya
import Alamofire

enum HospitalRouter {
    /// 앱 문의 및 신고
    case postInquiry(inquiry: HospitalInquiryRequest)
}

extension HospitalRouter: APITargetType {
    var path: String {
        switch self {
        case .postInquiry:
            return "/api/reports/inquiry"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postInquiry:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .postInquiry(inquiry):
            return .uploadMultipart(makeMultipartData(for: inquiry))
        }
    }
    
    
    var headers: [String : String]? {
        return nil
    }
}
