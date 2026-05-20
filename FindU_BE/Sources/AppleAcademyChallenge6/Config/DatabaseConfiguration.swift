//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Fluent
import Vapor
import FluentPostgresDriver

struct DatabaseConfiguration {
    static func configure(_ app: Application) throws {
        let hostname = Environment.get(EnvironmentValue.host) ?? "CHANGEME_HOST"
        let port = Environment.get(EnvironmentValue.port).flatMap(Int.init(_:)) ?? 5432
        let username = Environment.get(EnvironmentValue.username) ?? "CHANGEME_USER"
        let password = Environment.get(EnvironmentValue.password) ?? "CHANGEME_PASSWORD"
        let databaseName = Environment.get(EnvironmentValue.databaseName) ?? "CHANGEME_DB"
        
        let configuration = SQLPostgresConfiguration(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: databaseName,
            tls: .disable
        )
        
        app.databases.use(.postgres(configuration: configuration), as: .psql)
    }
}
