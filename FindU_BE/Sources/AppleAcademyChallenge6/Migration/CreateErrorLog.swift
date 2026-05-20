//
//  CreateErrorLog.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/15/25.
//

import Fluent

struct CreateErrorLog: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.errorLogs)
            .id()
            .field(IdKeyField.hospitalId, .uuid, .references(SchemaValue.hospitalAccount, "id", onDelete: .setNull))
            .field(ErrorLogField.endpoint, .string, .required)
            .field(ErrorLogField.method, .string, .required)
            .field(ErrorLogField.statusCode, .int, .required)
            .field(ErrorLogField.errorMessage, .string, .required)
            .field(ErrorLogField.stackTrace, .string)
            .field(ErrorLogField.requestBody, .string)
            .field(ErrorLogField.userAgent, .string)
            .field(ErrorLogField.ipAddress, .string)
            .field(CommonField.createdAt, .datetime)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.errorLogs).delete()
    }
}
