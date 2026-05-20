//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/28/25.
//

import Vapor

// MARK: - Reuquest

struct RegisterRequestDTO: Content {
    let email: String
    let password: String
    let hospitalName: String
    let businessNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case email, password
        case hospitalName = "hospital_name"
        case businessNumber = "business_number"
    }
    
    func validate() throws {
        guard email.contains("@") else {
            throw Abort(.badRequest, reason: "Invalid email format")
        }
        
        guard password.count >= 8 else {
            throw Abort(.badRequest, reason: "Password must be at least 8 characters")
        }
        
        guard !hospitalName.isEmpty else {
            throw Abort(.badRequest, reason: "Hospital name is required")
        }
    }
}

