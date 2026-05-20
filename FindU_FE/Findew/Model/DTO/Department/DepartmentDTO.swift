//
//  DepartmentDTO.swift
//  Findew
//
//  Created by 내꺼다 on 10/29/25.
//

import Foundation

/// Department DTO
struct DepartmentDTO: Codable, Identifiable {
    let id: UUID
    let name: String
    let code: String
    let description: String?
    let patientCount: Int
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case code
        case description
        case patientCount = "patient_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
