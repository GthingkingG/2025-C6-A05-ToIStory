//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

/// 진료과 공통 DTO
struct DepartmentDTO: Content {
    let id: UUID
    let name: String
    let code: String
    let description: String?
    let patientCount: Int
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, code, description
        case patientCount = "patient_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from department: Department) {
            self.id = department.id!
            self.name = department.name
            self.code = department.code
            self.description = department.description
            self.patientCount = department.patients.count
            self.createdAt = department.createdAt
            self.updatedAt = department.updatedAt
        }
}
