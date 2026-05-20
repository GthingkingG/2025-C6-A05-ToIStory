//
//  APITargetType.swift
//  Findew
//
//  Created by 내꺼다 on 10/24/25.
//

import Foundation
import Moya

protocol APITargetType: TargetType {}

extension APITargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
