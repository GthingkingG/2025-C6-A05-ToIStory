//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/13/25.
//

import Vapor

func routes(_ app: Application) throws {
    app.get("ping") { req async in
        return "pong"
    }

    app.get("docs") { req -> Response in
        return req.redirect(to: "/swagger-ui.html")
    }

    try app.register(collection: AuthController())
    try app.register(collection: RoomController())
    try app.register(collection: DepartmentController())
    try app.register(collection: AnchorController())

    try app.register(collection: PatientController())
    try app.register(collection: DeviceController())

    try app.register(collection: LocationController())
    try app.register(collection: ReportController())
    try app.register(collection: ErrorLogController())
    try app.register(collection: DashboardController())
}
