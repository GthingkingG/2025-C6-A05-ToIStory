//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor
import Fluent
import JWT

struct SessionToken: Content, JWTPayload {
    let hospitalId: UUID
    let email: String
    let exp: ExpirationClaim
    
    enum CodingKeys: String, CodingKey {
        case hospitalId = "hospital_id"
        case email
        case exp
    }
    
    init(
        hospitalId: UUID,
        email: String,
        exp: ExpirationClaim
    ) {
        self.hospitalId = hospitalId
        self.email = email
        self.exp = exp
    }
    
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try exp.verifyNotExpired()
    }
}

extension SessionToken: Authenticatable {}
