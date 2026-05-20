//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent

struct CreateAnchor: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.anchors)
            .id()
            .field(IdKeyField.hospitalId, .uuid, .required, .references(SchemaValue.hospitalAccount, "id", onDelete: .cascade))
            .field(AnchorField.macAddress, .string, .required)
            .field(AnchorField.zoneName, .string, .required)
            .field(AnchorField.zoneType, .string, .required)
            .field(AnchorField.floor, .int, .required)
            .field(AnchorField.positionX, .double, .required)
            .field(AnchorField.positionY, .double, .required)
            .field(AnchorField.positionZ, .double)
            .field(AnchorField.isActive, .bool, .required)
            .field(CommonField.createdAt, .datetime)
            .field(CommonField.updatedAt, .datetime)
            .unique(on: AnchorField.macAddress)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.anchors).delete()
    }
    
}
