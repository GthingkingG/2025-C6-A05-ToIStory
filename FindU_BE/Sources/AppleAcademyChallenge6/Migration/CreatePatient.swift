//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent

struct CreatePatient: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.patients)
            .id()
            .field(IdKeyField.hospitalId, .uuid, .required, .references(SchemaValue.hospitalAccount, "id", onDelete: .cascade))
            .field(PatientField.name, .string, .required)
            .field(PatientField.ward, .string, .required)
            .field(PatientField.bed, .int, .required)
            .field(IdKeyField.departmentId, .uuid, .required, .references(SchemaValue.departments, "id", onDelete: .restrict))
            .field(IdKeyField.deviceId, .uuid, .references(SchemaValue.devices, "id", onDelete: .setNull))
            .field(PatientField.memo, .string)
            .field(CommonField.createdAt, .datetime)
            .field(CommonField.updatedAt, .datetime)
            .unique(on: IdKeyField.hospitalId, PatientField.ward, PatientField.bed)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.patients).delete()
    }
}
