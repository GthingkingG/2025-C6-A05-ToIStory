//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor
import Fluent

/// 앵커 테이블
final class Anchor: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.anchors
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "hospital_id")
    var hospital: HospitalAccount
    
    @Field(key: "mac_address")
    var macAddress: String
    
    @Field(key: "zone_type")
    var zoneType: String
    
    @Field(key: "zone_name")
    var zoneName: String
    
    @Field(key: "floor")
    var floor: Int
    
    @Field(key: "position_x")
    var positionX: Double
    
    @Field(key: "position_y")
    var positionY: Double
    
    @OptionalField(key: "position_z")
    var positionZ: Double?
    
    @Field(key: "is_active")
    var isActive: Bool
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        hospitalId: UUID,
        macAddress: String,
        zoneType: String,
        zoneName: String,
        floor: Int,
        positionX: Double,
        positionY: Double,
        positionZ: Double? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.$hospital.id = hospitalId
        self.macAddress = macAddress
        self.zoneType = zoneType
        self.zoneName = zoneName
        self.floor = floor
        self.positionX = positionX
        self.positionY = positionY
        self.positionZ = positionZ
        self.isActive = isActive
    }
}
