//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/28/25.
//

import Vapor

struct DeviceAddRequest: Content {
    let serialNumber: String
    
    enum CodingKeys: String, CodingKey {
        case serialNumber = "serial_number"
    }
}
