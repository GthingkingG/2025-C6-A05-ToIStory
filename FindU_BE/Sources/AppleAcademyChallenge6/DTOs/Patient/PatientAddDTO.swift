//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/14/25.
//

import Vapor

/// 환자 추가
struct PatientAddRequest: Content {
    let name: String
    let ward: String
    let bed: Int
    let departmentId: UUID
    let deviceSerial: String?
    let memo: String?
    
    enum CodingKeys: String, CodingKey {
        case name, ward, bed, memo
        case departmentId = "department_id"
        case deviceSerial = "device_serial"
    }
}
