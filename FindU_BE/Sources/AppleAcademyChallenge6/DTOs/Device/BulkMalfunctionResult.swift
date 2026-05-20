//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor

struct BulkMalfunctionResult: Content {
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
