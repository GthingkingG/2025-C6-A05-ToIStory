//
//  HospitalDTO.swift
//  Findew
//
//  Created by 내꺼다 on 10/29/25.
//

import Foundation

/// HospitalDTO
struct HospitalDTO: Codable {
    let id: UUID
    let content: String
    let email: String?
    let status: String
    let images: [String]
    let adminReply: String?
    let repliedBy: String?
    let repliedAt: String?
    let createdAt: String?
    let updatedAt: String?

    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case email
        case status
        case images
        case adminReply = "admin_reply"
        case repliedBy = "replied_by"
        case repliedAt = "replied_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
