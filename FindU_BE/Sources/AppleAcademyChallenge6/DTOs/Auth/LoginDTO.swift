//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/13/25.
//

import Vapor

// MARK: - Request

struct LoginRequestDTO: Content {
    let email: String
    let password: String
    
    func validate() throws {
        guard !email.isEmpty else {
            throw Abort(.badRequest, reason: "이메일 값 필수")
        }
        
        func validate() throws {
            guard !email.isEmpty else {
                throw Abort(.badRequest, reason: "Email is required")
            }
            
            guard email.contains("@") else {
                throw Abort(.badRequest, reason: "Invalid email format")
            }
            
            guard !password.isEmpty else {
                throw Abort(.badRequest, reason: "Password is required")
            }
            
            guard password.count >= 8 else {
                throw Abort(.badRequest, reason: "Password must be at least 8 characters")
            }
        }
    }
}

// MARK: - Response

struct LoginResponseDTO: Content {
    let accessToken: String
    let expiresAt: Date
    let expiresIn: Int
    let hospital: HospitalDTO
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresAt = "expires_at"
        case expiresIn = "expires_in"
        case hospital
    }
}
