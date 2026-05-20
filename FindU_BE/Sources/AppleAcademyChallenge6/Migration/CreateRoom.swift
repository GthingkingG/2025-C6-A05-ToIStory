//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/10/25.
//

// Sources/AppleAcademyChallenge6/Migrations/CreateRoom.swift

import Fluent

struct CreateRoom: AsyncMigration {
    
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.rooms)
            .id()
            .field(IdKeyField.hospitalId, .uuid, .required, .references(SchemaValue.hospitalAccount, "id", onDelete: .cascade))
            .field(RoomField.floor, .int, .required)
            .field(RoomField.roomNumber, .string, .required)
            .field(RoomField.bedCount, .int, .required)
            .field(RoomField.isAvailable, .bool, .required)
            .field(CommonField.createdAt, .datetime)
            .field(CommonField.updatedAt, .datetime)
            .unique(on: IdKeyField.hospitalId, RoomField.roomNumber)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.rooms).delete()
    }
}
