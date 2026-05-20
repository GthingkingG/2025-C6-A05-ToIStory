//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/31/25.
//

import Vapor
import JWT

struct JWTConfiguration {
    static func configure(_ app: Application) async throws {
        // MARK: - JWT
        guard let jwtSecret = Environment.get(EnvironmentValue.jwtSecret) else {
            fatalError("JWT_SECRET 존재하지 않아요")
        }
        
        guard let secretData = jwtSecret.data(using: .utf8) else {
            fatalError("JWT_SECRET 작동하지 않아요")
        }
        
        let hmacKey = HMACKey(from: secretData)
        await app.jwt.keys.add(hmac: hmacKey, digestAlgorithm: .sha256)
    }
}
