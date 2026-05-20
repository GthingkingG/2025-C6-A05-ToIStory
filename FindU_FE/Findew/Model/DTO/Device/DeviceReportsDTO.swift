//
//  DeviceReportsDTO.swift
//  AppleAcademyChallenge6App
//
//  Created by 내꺼다 on 10/20/25.
//

import Foundation

/// 기기 신고
struct DeviceReportsRequest: Codable {
    let serialNumber: [String]
    
    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
    }
}

struct DeviceResponse: Codable {
    let totalCount: Int
    let successCount: Int
    let failedCount: Int
    let failedDevices: [String]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case successCount = "success_count"
        case failedCount = "failed_count"
        case failedDevices = "failed_devices"
    }
}
