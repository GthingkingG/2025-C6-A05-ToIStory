//
//  PatientUpdateDTO.swift
//  AppleAcademyChallenge6App
//
//  Created by 내꺼다 on 10/21/25.
//

import Foundation

/// 환자 수정
struct PatientUpdatePath: Codable {
    let id: UUID
}

struct PatientUpdateRequest: Codable {
    let name: String?
    let ward: String?
    let bed: Int?
    let departmentId: UUID?
    let memo: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case ward
        case bed
        case departmentId = "department_id"
        case memo
    }
}
