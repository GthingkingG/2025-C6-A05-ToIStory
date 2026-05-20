//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor
import Fluent

/// 병원 계정 테이블
final class HospitalAccount: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.hospitalAccount
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Field(key: "hospital_name")
    var hospitalName: String
    
    @OptionalField(key: "business_number")
    var businessNumber: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$hospital)
    var department: [Department]
    
    @Children(for: \.$hospital)
    var patients: [Patient]
    
    @Children(for: \.$hospital)
    var devices: [Device]
    
    @Children(for: \.$hospital)
    var anchors: [Anchor]
    
    @Children(for: \.$hospital)
    var reports: [Report]
    
    init() {}
    
    init(
        id: UUID? = nil,
        email: String,
        passwordHash: String,
        hospitalName: String,
        businessNumber: String? = nil
    ) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
        self.hospitalName = hospitalName
        self.businessNumber = businessNumber
        
    }
}

// MARK: - Authentication
extension HospitalAccount: ModelAuthenticatable {
    static let usernameKey: KeyPath<HospitalAccount, FieldProperty<HospitalAccount, String>> = \HospitalAccount.$email
    static let passwordHashKey: KeyPath<HospitalAccount, FieldProperty<HospitalAccount, String>> = \HospitalAccount.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}
