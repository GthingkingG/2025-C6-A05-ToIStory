//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/28/25.
//

import Vapor

struct DeviceUpdateRequest: Content {
    let serialNumber: String?
    let isMalfunctioning: Bool
    
    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
        case isMalfunctioning
    }
}
