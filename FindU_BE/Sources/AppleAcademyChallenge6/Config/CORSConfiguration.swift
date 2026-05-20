//
//  CORSConfiguration.swift
//  AppleAcademyChallenge6
//
//  Created by Claude on 11/15/25.
//

import Vapor

enum CORSConfiguration {
    static func configure(_ app: Application) {
        let corsConfiguration = CORSMiddleware.Configuration(
            allowedOrigin: .all,
            allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
            allowedHeaders: [
                .accept,
                .authorization,
                .contentType,
                .origin,
                .xRequestedWith,
                .userAgent,
                .accessControlAllowOrigin
            ]
        )
        app.middleware.use(CORSMiddleware(configuration: corsConfiguration))
    }
}
