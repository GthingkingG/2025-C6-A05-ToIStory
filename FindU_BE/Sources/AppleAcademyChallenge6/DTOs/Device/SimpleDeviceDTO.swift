//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/28/25.
//

import Vapor

struct SimpleDeviceDTO: Content {
    let serialNumber: String
    let batteryLevel: Int
    let isMalfunctioning: Bool
    
    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
        case batteryLevel = "battery_level"
        case isMalfunctioning = "is_malfunctioning"
    }
    
    init(from device: Device) {
        self.serialNumber = device.serialNumber
        self.batteryLevel = device.batteryLevel
        self.isMalfunctioning = device.isMalfunctioning
    }
}
