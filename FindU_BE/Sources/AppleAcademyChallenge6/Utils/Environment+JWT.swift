//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

extension Environment {
    static var jwtExpriationSeconds: TimeInterval {
        guard let value = Self.get("JWT_EXPIRATION_SECONDS"),
              let seconds = TimeInterval(value) else {
            return 60 * 60 * 24 * 7
        }
        return seconds
    }
    
    static var jwtExpirationDays: Int {
        guard let value = Self.get("JWT_EXPIRATION_DAYS"),
              let days = Int(value) else {
            return 7
        }
        return days
    }
}
