//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent

struct CreateDepartment: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema(SchemaValue.departments)
            .id()
            .field(IdKeyField.hospitalId, .uuid, .required, .references(SchemaValue.hospitalAccount, "id", onDelete: .cascade))
            .field(DepartmentField.departmentName, .string, .required)
            .field(DepartmentField.code, .string, .required)
            .field(DepartmentField.description, .string)
            .field(CommonField.createdAt, .datetime)
            .field(CommonField.updatedAt, .datetime)
            .unique(on: IdKeyField.hospitalId, DepartmentField.code)
            .unique(on: IdKeyField.hospitalId, DepartmentField.departmentName)
            .create()
    }
    
    func revert(on database: any Database) async throws {
        try await database.schema(SchemaValue.departments).delete()
    }
}
