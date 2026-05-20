//
//  DeviceUpdateDTO.swift
//  Findew
//
//  Created by 내꺼다 on 10/28/25.
//

import Foundation

/// 기기 수정
struct DevicePutPath: Codable {
    let id: UUID
}

struct DeviceUpdateRequest: Codable {
    let name: String?
    let isMalfunctioning: Bool?
    
    enum CodingKeys: String, CodingKey {
        case name
        case isMalfunctioning = "is_malfunctioning"
    }
}
