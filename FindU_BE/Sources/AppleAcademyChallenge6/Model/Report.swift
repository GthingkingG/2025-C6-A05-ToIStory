//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor
import Fluent

final class Report: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.reports
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "hospital_id")
    var hospital: HospitalAccount

    @Field(key: "content")
    var content: String
    
    @OptionalField(key: "email")
    var email: String?
    
    @Enum(key: "status")
    var status: ReportStatus
    
    @OptionalField(key: "admin_reply")
    var adminReply: String?
    
    @OptionalField(key: "replied_by")
    var repliedBy: String?
    
    @Timestamp(key: "replied_at", on: .none)
    var repliedAt: Date?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$report)
    var images: [ReportImage]
    
    init() {}
    
    init(
        id: UUID? = nil,
        hospitalId: UUID,
        content: String,
        email: String? = nil,
        status: ReportStatus = .pending
    ) {
        self.id = id
        self.$hospital.id = hospitalId
        self.content = content
        self.email = email
        self.status = status
    }
}
