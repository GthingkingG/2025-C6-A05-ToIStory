//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/14/25.
//

import Vapor

// MARK: - Response
struct ReportDTO: Content {
    let id: UUID
    let content: String
    let email: String?
    let status: ReportStatus
    let images: [String]
    let adminReply: String?
    let repliedBy: String?
    let repliedAt: Date?
    let createdAt: Date?
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, content, email, status, images
        case adminReply = "admin_reply"
        case repliedBy = "replied_by"
        case repliedAt = "replied_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from report: Report) {
        self.id = report.id!
        self.content = report.content
        self.email = report.email
        self.status = report.status
        self.images = report.images.map { $0.url }
        self.adminReply = report.adminReply
        self.repliedBy = report.repliedBy
        self.repliedAt = report.repliedAt
        self.createdAt = report.createdAt
        self.updatedAt = report.updatedAt
    }
}
