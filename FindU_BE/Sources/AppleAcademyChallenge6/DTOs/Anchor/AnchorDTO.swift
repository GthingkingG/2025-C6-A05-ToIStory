//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

struct AnchorDTO: Content {
    let id: UUID
    let macAddress: String
    let zoneType: String
    let zoneName: String
    let floor: Int
    let positionX: Double
    let positionY: Double
    let positionZ: Double?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case macAddress = "mac_address"
        case zoneType = "zone_type"
        case zoneName = "zone_name"
        case floor
        case positionX = "position_x"
        case positionY = "position_y"
        case positionZ = "position_z"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from anchor: Anchor) {
        self.id = anchor.id!
        self.macAddress = anchor.macAddress
        self.zoneType = anchor.zoneType
        self.zoneName = anchor.zoneName
        self.floor = anchor.floor
        self.positionX = anchor.positionX
        self.positionY = anchor.positionY
        self.positionZ = anchor.positionZ
        self.createdAt = anchor.createdAt
        self.updatedAt = anchor.updatedAt
    }
}
