//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/14/25.
//

import Vapor

struct DeviceDTO: Content {
    let id: UUID
    let serialNumber: String
    let batteryLevel: Int
    let isMalfunctioning: Bool
    let patient: SimplePatientDTO?
    let currentZone: CurrentZoneDTO?
    let lastLocationUpdate: Date?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case serialNumber = "serial_number"
        case batteryLevel = "battery_level"
        case isMalfunctioning = "is_malfunctioning"
        case patient
        case currentZone = "current_zone"
        case lastLocationUpdate = "last_location_update"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from device: Device) {
        self.id = device.id!
        self.serialNumber = device.serialNumber
        self.batteryLevel = device.batteryLevel
        self.isMalfunctioning = device.isMalfunctioning
        self.patient = device.patient.map { SimplePatientDTO(from: $0) }
        
        if let zoneType = device.currentZoneType,
           let zoneName = device.currentZoneName {
            self.currentZone = CurrentZoneDTO(
                type: zoneType,
                name: zoneName,
                floor: device.currentFloor
            )
        } else {
            self.currentZone = nil
        }
        
        self.lastLocationUpdate = device.lastLocationUpdate
        self.createdAt = device.createdAt
        self.updatedAt = device.updatedAt
    }
}
