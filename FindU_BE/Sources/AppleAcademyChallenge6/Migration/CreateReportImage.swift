//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent

struct CreateReportImage: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.reportImages)
            .id()
            .field(IdKeyField.reportId, .uuid, .required, .references(SchemaValue.reports, "id", onDelete: .cascade))
            .field(ReportImageField.url, .string, .required)
            .field(ReportImageField.filename, .string, .required)
            .field(ReportImageField.uploadedAt, .datetime)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.reportImages).delete()
    }
}
