//
//  AuthDTO.swift
//  Findew
//
//  Created by 내꺼다 on 10/31/25.
//

import Foundation

/// Auth계정 병원 정보
struct AuthResponse: Codable {
    let hospital: AuthHospital
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case hospital
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

struct AuthHospital: Codable {
    let id: UUID
    let email: String
    let name: String
    let businessNumber: String?
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case businessNumber = "business_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
