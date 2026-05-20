//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent

struct CreateHospitalAccount: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.hospitalAccount)
            .id()
            .field(HospitalAccountField.email, .string, .required)
            .field(HospitalAccountField.password, .string, .required)
            .field(HospitalAccountField.name, .string, .required)
            .field(HospitalAccountField.businessNumber, .string)
            .field(CommonField.createdAt, .datetime)
            .field(CommonField.updatedAt, .datetime)
            .unique(on: HospitalAccountField.email)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.hospitalAccount).delete()
    }
}
