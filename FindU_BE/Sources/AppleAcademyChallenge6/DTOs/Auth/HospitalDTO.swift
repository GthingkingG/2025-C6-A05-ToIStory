//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/28/25.
//

import Vapor

struct HospitalDTO: Content {
    let id: UUID
    let email: String
    let name: String
    let businessNumber: String?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, email, name
        case businessNumber = "business_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from hospital: HospitalAccount) {
        self.id = hospital.id!
        self.email = hospital.email
        self.name = hospital.hospitalName
        self.businessNumber = hospital.businessNumber
        self.createdAt = hospital.createdAt
        self.updatedAt = hospital.updatedAt
    }
}
