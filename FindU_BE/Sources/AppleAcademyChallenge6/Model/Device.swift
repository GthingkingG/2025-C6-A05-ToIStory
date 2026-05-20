//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor
import Fluent

/// 기기 테이블
final class Device: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.devices
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "hospital_id")
    var hospital: HospitalAccount
    
    @Field(key: "serial_number")
    var serialNumber: String
    
    @Field(key: "battery_level")
    var batteryLevel: Int
    
    @Field(key: "is_malfunctioning")
    var isMalfunctioning: Bool
    
    @OptionalField(key: "current_zone_type")
    var currentZoneType: String?
    
    @OptionalField(key: "current_zone_name")
    var currentZoneName: String?
    
    @OptionalField(key: "current_floor")
    var currentFloor: Int?
    
    @OptionalField(key: "location_x")
    var locationX: Double?
    
    @OptionalField(key: "location_y")
    var locationY: Double?
    
    @Timestamp(key: "last_location_update", on: .none)
    var lastLocationUpdate: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @OptionalChild(for: \.$device)
    var patient: Patient?
    
    init() {}
    
    init(
        id: UUID? = nil,
        hospitalId: UUID,
        serialNumber: String,
        batteryLevel: Int = 100,
        isMalfunctioning: Bool = false
    ) {
        self.id = id
        self.$hospital.id = hospitalId
        self.serialNumber = serialNumber
        self.batteryLevel = batteryLevel
        self.isMalfunctioning = isMalfunctioning
    }
}

