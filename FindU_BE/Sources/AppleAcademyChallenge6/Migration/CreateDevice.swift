//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent

struct CreateDevice: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.devices)
            .id()
            .field(IdKeyField.hospitalId, .uuid, .required, .references(SchemaValue.hospitalAccount, "id", onDelete: .cascade))
            .field(DeviceField.serialNumber, .string, .required)
            .field(DeviceField.batteryLevel, .int, .required)
            .field(DeviceField.isMalfunctioning, .bool, .required)
            .field(DeviceField.currentZoneType, .string)
            .field(DeviceField.currentZoneName, .string)
            .field(DeviceField.currentFloor, .int)
            .field(DeviceField.locationX, .double)
            .field(DeviceField.locationY, .double)
            .field(DeviceField.lastUpdate, .datetime)
            .field(CommonField.createdAt, .datetime)
            .field(CommonField.updatedAt, .datetime)
            .unique(on: DeviceField.serialNumber)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.devices).delete()
    }
}
