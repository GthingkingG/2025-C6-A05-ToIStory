//
//  DeviceLocatoinDTO.swift
//  Findew
//
//  Created by Apple Coding machine on 11/4/25.
//

import Foundation

struct DeviceLocatoinDTO: Codable {
    let zoneType: String?        // 구역 타입 (예: "병동", "수술실")
    let zoneName: String?        // 구역 이름 (예: "A동", "수술실 1")
    let floor: Int?              // 층
    let x: Double?               // X 좌표
    let y: Double?               // Y 좌표
    let lastUpdate: Date?        // 마지막 위치 업데이트 시간
    
    enum CodingKeys: String, CodingKey {
        case zoneType = "zone_type"
        case zoneName = "zone_name"
        case floor
        case x
        case y
        case lastUpdate = "last_update"
    }
}
