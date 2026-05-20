//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

struct AnchorAddRequest: Content {
    let macAddress: String
    let zoneType: String
    let zoneName: String
    let floor: Int
    let positionX: Double
    let positionY: Double
    let positionZ: Double?
    
    enum CodingKeys: String, CodingKey {
        case macAddress = "mac_address"
        case zoneType = "zone_type"
        case zoneName = "zone_name"
        case floor
        case positionX = "position_x"
        case positionY = "position_y"
        case positionZ = "position_z"
    }
}

