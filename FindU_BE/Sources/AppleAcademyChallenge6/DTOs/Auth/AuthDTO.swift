//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/14/25.
//

import Vapor

struct AuthResponseDTO: Content {
    let hospital: HospitalDTO
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
    
    init(
        hospital: HospitalDTO,
        accessToken: String,
        refreshToken: String,
        expiresIn: Int
    ) {
        self.hospital = hospital
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.tokenType = "Bearer"
        self.expiresIn = expiresIn
    }
}
