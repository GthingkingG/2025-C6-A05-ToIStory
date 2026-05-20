//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor

struct PatientDTO: Content {
    let id: UUID
    let name: String
    let ward: String
    let bed: Int
    let department: SimpleDepartmentDTO
    let device: SimpleDeviceDTO?
    let memo: String?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
           case id, name, ward, bed, department, device, memo
           case createdAt = "created_at"
           case updatedAt = "updated_at"
       }
       
       init(from patient: Patient) {
           self.id = patient.id!
           self.name = patient.name
           self.ward = patient.ward
           self.bed = patient.bed
           self.department = SimpleDepartmentDTO(from: patient.department)
           self.device = patient.device.map { SimpleDeviceDTO(from: $0) }
           self.memo = patient.memo
           self.createdAt = patient.createdAt
           self.updatedAt = patient.updatedAt
       }
}
