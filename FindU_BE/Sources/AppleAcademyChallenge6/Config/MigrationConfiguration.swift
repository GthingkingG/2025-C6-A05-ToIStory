//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Vapor
import Fluent

struct MigrationConfiguration {
    static func configure(_ app: Application) {
        app.migrations.add(CreateHospitalAccount())

        app.migrations.add(CreateRefreshToken())
        app.migrations.add(CreateDepartment())
        app.migrations.add(CreateDevice())
        app.migrations.add(CreateAnchor())
        app.migrations.add(CreateReport())
        app.migrations.add(CreateRoom())

        app.migrations.add(CreatePatient())

        app.migrations.add(CreateReportImage())
        app.migrations.add(CreateErrorLog())
    }
    
    static func migrate(_ app: Application) async throws {
        try await app.autoMigrate()
    }
}
