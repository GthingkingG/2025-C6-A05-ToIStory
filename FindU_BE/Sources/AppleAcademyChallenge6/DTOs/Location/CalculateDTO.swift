//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/13/25.
//

import Vapor

/// 위도, 경도 값
struct LocationCalculateRequestDTO: Content {
    let serialNumber: String
    let batteryLevel: Int
    let floor: Int
    let timestamp: Date
    let measurements: [FTMMeasurementDTO]
    
    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
        case batteryLevel = "battery_level"
        case floor
        case timestamp
        case measurements
    }
}

struct FTMMeasurementDTO: Content {
    let anchorMac: String
    let distanceMeters: Double
    let rttNanoseconds: Int
    let rssi: Int
    
    enum CodingKeys: String, CodingKey {
        case anchorMac = "anchor_mac"
        case distanceMeters = "distance_meters"
        case rttNanoseconds = "rtt_nanoseconds"
        case rssi
    }
}

// MARK: - Response

struct LocationCalculateResponseDTO: Content {
    let serialNumber: String
    let batteryLevel: Int
    let currentZone: CurrentZoneResponseDTO
    let assignedWard: String?
    let isInAssignedWard: Bool
    let distanceFromAnchor: Double
    let preciseLocation: PreciseLocationDTO?
    let nearbyZones: [NearbyZoneDTO]
    let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
        case batteryLevel = "battery_level"
        case currentZone = "current_zone"
        case assignedWard = "assigned_ward"
        case isInAssignedWard = "is_in_assigned_ward"
        case distanceFromAnchor = "distance_from_anchor"
        case preciseLocation = "precise_location"
        case nearbyZones = "nearby_zones"
        case timestamp
    }
}

struct CurrentZoneResponseDTO: Content {
    let type: String
    let name: String
    let floor: Int
}

struct PreciseLocationDTO: Content {
    let x: Double
    let y: Double
    let z: Double?
}

struct NearbyZoneDTO: Content {
    let zoneName: String
    let zoneType: String
    let distance: Double
    
    enum CodingKeys: String, CodingKey {
        case zoneName = "zone_name"
        case zoneType = "zone_type"
        case distance
    }
}
