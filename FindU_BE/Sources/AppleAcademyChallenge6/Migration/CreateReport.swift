//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent

struct CreateReport: AsyncMigration {
    func prepare(on database: any Database) async throws {
        let reportStatusEnum = try await database.enum("report_status")
            .case("pending")
            .case("in_progress")
            .case("resolved")
            .case("closed")
            .create()
        
        try await database.schema(SchemaValue.reports)
            .id()
            .field(IdKeyField.hospitalId, .uuid, .required, .references(SchemaValue.hospitalAccount, "id", onDelete: .cascade))
            .field(ReportField.content, .string, .required)
            .field(ReportField.email, .string)
            .field(ReportField.status, reportStatusEnum, .required)
            .field(ReportField.adminReply, .string)
            .field(ReportField.repliedBy, .string)
            .field(ReportField.repliedAt, .datetime)
            .field(CommonField.createdAt, .datetime)
            .field(CommonField.updatedAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.reports).delete()
        try await database.enum("report_status").delete()
        try await database.enum("report_type").delete()
    }
}
