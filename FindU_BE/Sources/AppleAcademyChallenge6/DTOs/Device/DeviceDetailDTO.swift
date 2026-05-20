//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

struct DeviceDetailDTO: Content {
    let id: UUID
    let serialNumber: String
    let batteryLevel: Int
    let isMalfunctioning: Bool
    let currentZone: CurrentZoneDTO?
    let preciseLocation: PreciseLocationDTO?
    let lastLocationUpdate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case serialNumber = "serial_number"
        case batteryLevel = "battery_level"
        case isMalfunctioning = "is_malfunctioning"
        case currentZone = "current_zone"
        case preciseLocation = "precise_location"
        case lastLocationUpdate = "last_location_update"
    }
    
    init(from device: Device) {
        self.id = device.id!
        self.serialNumber = device.serialNumber
        self.batteryLevel = device.batteryLevel
        self.isMalfunctioning = device.isMalfunctioning
        
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
        
        if let x = device.locationX, let y = device.locationY {
            self.preciseLocation = PreciseLocationDTO(x: x, y: y, z: nil)
        } else {
            self.preciseLocation = nil
        }
        
        self.lastLocationUpdate = device.lastLocationUpdate
    }
}
