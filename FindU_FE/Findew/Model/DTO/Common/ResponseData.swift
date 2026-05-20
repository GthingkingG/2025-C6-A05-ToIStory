//
//  ResponseData.swift
//  Findew
//
//  Created by 내꺼다 on 10/29/25.
//

import Foundation

struct ResponseData<T: Codable>: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?

    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
        case code
        case message
        case result
    }
}
