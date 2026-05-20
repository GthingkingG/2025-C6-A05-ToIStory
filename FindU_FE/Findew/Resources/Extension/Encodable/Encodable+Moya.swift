//
//  Encodable+Moya.swift
//  Findew
//
//  Created by 내꺼다 on 10/30/25.
//

import Foundation
import Moya
import Alamofire

extension Encodable {
    private func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let obj = try JSONSerialization.jsonObject(with: data, options: [])
        return obj as? [String: Any] ?? [:]
    }
    
    private func asParameters() -> [String: Any] {
        (try? self.asDictionary()) ?? [:]
    }
    
    func asQueryTask() -> Moya.Task {
        .requestParameters(parameters: asParameters(), encoding: URLEncoding.queryString)
    }
}
