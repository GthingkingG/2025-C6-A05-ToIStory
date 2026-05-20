//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent

struct CreateRefreshToken: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.refreshToken)
            .id()
            .field(TokenField.accessToken, .string, .required)
            .field(TokenField.refreshToken, .string, .required)
            .field(IdKeyField.hospitalId, .uuid, .required, .references(SchemaValue.hospitalAccount, "id", onDelete: .cascade))
            .field(CommonField.expiresAt, .datetime, .required)
            .field(CommonField.createdAt, .datetime)
            .unique(on: TokenField.refreshToken)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.refreshToken).delete()
    }
}
