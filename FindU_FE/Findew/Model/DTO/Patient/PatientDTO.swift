//
//  PatientDTO.swift
//  Findew
//
//  Created by 내꺼다 on 10/31/25.
//

import Foundation

/// 테이블리스트 조회시 사용
struct PatientDTO: Codable, Identifiable {
    let id: UUID
    let name: String
    let ward: String
    let bed: Int
    let department: Department
    let device: PatientDevice?
    let memo: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ward
        case bed
        case department
        case device
        case memo
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    /// 병동-호실 병합
    var wardBedNumber: String {
        "\(ward)-\(bed)"
    }
    
    var currentLocationText: String {
        if let zone = device?.currentZone {
            if let floor = zone.floor {
                let floorText = floor < 0 ? "지하 \(abs(floor))" : "\(floor)"
                return "\(floorText)층 \(zone.name)"
            } else {
                return zone.name
            }
        }
        return "현재 위치 파악 불가"
    }
}

/// PatientDevice
struct PatientDevice: Codable, DeviceInfo {
    let id: UUID
    let serialNumber: String
    let batteryLevel: Int
    let isMalfunctioning: Bool
    let currentZone: CurrentZone?
    let preciseLocation: PreciseLocation?
    let lastLocationUpdate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case serialNumber = "serial_number"
        case batteryLevel = "battery_level"
        case isMalfunctioning = "is_malfunctioning"
        case currentZone = "current_zone"
        case preciseLocation = "precise_location"
        case lastLocationUpdate = "last_location_update"
    }
}

/// Current Zone
struct CurrentZone: Codable, Equatable {
    let type: String
    let name: String
    let floor: Int?
}

/// PreciseLocation
struct PreciseLocation: Codable {
    let x: Double
    let y: Double
    let z: Double?
}

/// Department
struct Department: Codable {
    let id: UUID
    let name: String
    let code: String
}

/// Device
struct Device: Codable, Hashable {
    let serialNumber: String
    let batteryLevel: Int
    let isMalfunctioning: Bool
    
    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
        case batteryLevel = "battery_level"
        case isMalfunctioning = "is_malfunctioning"
    }
}
