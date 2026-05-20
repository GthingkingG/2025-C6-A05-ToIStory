//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Vapor
import Fluent
import JWT

final class AuthService {
    let database: any Database
    let app: Application
    
    init(database: any Database, app: Application) {
        self.database = database
        self.app = app
    }
    
    // MARK: - 계정 생성
    func register(
        email: String,
        password: String,
        hospitalName: String,
        businessNumber: String?
    ) async throws -> AuthResponseDTO {
        
        let existing = try await HospitalAccount.query(on: database)
            .filter(\.$email == email)
            .first()
        
        if existing != nil {
            throw Abort(.conflict, reason: "이메일 이미 존재합니다.")
        }
        
        let passwordHash = try Bcrypt.hash(password)
        
        let hospital = HospitalAccount(
            email: email,
            passwordHash: passwordHash,
            hospitalName: hospitalName,
            businessNumber: businessNumber
        )
        
        try await hospital.save(on: database)
        
        let tokens = try await createToken(hospital)
        
        return AuthResponseDTO(hospital: HospitalDTO(from: hospital), accessToken: tokens.accessToken, refreshToken: tokens.refreshToken, expiresIn: tokens.expireIn)
    }
    
    // MARK: - 로그인
    func login(email: String, password: String) async throws -> AuthResponseDTO {
        guard let hospital = try await HospitalAccount.query(on: database)
            .filter(\.$email == email)
            .first() else {
            throw Abort(.unauthorized, reason: "유효하지 않은 이메일 및 패스워드 입니다")
        }
        
        let isValidPassword = try Bcrypt.verify(password, created: hospital.passwordHash)
        
        guard isValidPassword else {
            throw Abort(.unauthorized, reason: "유효하지 않는 이메일 및 비밀번호")
        }
        
        let tokens = try await createToken(hospital)
        
        return AuthResponseDTO(
            hospital: HospitalDTO(from: hospital),
            accessToken: tokens.accessToken,
            refreshToken: tokens.refreshToken,
            expiresIn: tokens.expireIn
        )
    }
    
    // MARK: - 토큰 갱신
    func refreshAccessToken(refreshToken: String) async throws -> TokenResponseDTO {
        guard let token = try await RefreshToken.query(on: database)
            .filter(\.$refreshToken == refreshToken)
            .with(\.$hospital)
            .first() else {
            throw Abort(.unauthorized, reason: "유효하지 않는 리프레시 토큰")
        }
        
        guard let expiresAt = token.expiresAt, expiresAt > Date() else {
            try await token.delete(on: database)
            throw Abort(.unauthorized, reason: "리프레시 토큰 만료됨")
        }
        
        let accessToken = try await createAccessToken(token.hospital)
        let expirationSeconds = Environment.get(EnvironmentValue.jwtExpirationSeconds)
            .flatMap(Int.init) ?? 604800
        
        let newExpiresAt = Date().addingTimeInterval(TimeInterval(expirationSeconds))
        token.expiresAt = newExpiresAt
        try await token.save(on: database)
        
        return TokenResponseDTO(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: newExpiresAt,
            expiresIn: expirationSeconds
        )
    }
    
    // MARK: -로그아웃
    func logout(refreshToken: String, hospitalId: UUID) async throws {
        guard let token = try await RefreshToken.query(on: database)
            .filter(\.$refreshToken == refreshToken)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "리프레시 토큰 정보 없음")
        }
        
        try await token.delete(on: database)
    }
    
    // MARK: - 병원계정 정보 조회
    func getHospitalAccount(id: UUID) async throws -> HospitalAccount {
        guard let hospital = try await HospitalAccount.find(id, on: database) else {
            throw Abort(.notFound, reason: "Hospital account not found")
        }
        
        return hospital
    }
    
    // MARK: - 회원탈퇴
    func deleteAccount(hospitalId: UUID, password: String) async throws {
        guard let hospital = try await HospitalAccount.find(hospitalId, on: database) else {
            throw Abort(.notFound, reason: "병원 계정을 찾을 수 없습니다.")
        }
        
        let isAalidPassword = try hospital.verify(password: password)
        guard isAalidPassword else {
            throw Abort(.badRequest, reason: "비밀번호가 일치하지 않습니다.")
        }
        
        try await RefreshToken.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .delete()
        
        try await hospital.delete(on: database)
    }
}

extension AuthService {
    private func createToken(_ hospital: HospitalAccount) async throws -> (
        accessToken: String,
        refreshToken: String,
        expireIn: Int
    ) {
        guard let hospitalId = hospital.id else {
            throw Abort(.internalServerError, reason: "병원 계정이 존재하지 않아요")
        }
        
        let accessToken = try await createAccessToken(hospital)
        let refreshToken = UUID().uuidString
        let expiresIn = Int(Environment.jwtExpriationSeconds)
        
        let expiratoinDays = Environment.jwtExpirationDays
        let expiresAt = Date().addingTimeInterval(TimeInterval(expiratoinDays * 24 * 60 * 60))
        
        try await RefreshToken.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .delete()
        
        let token = RefreshToken(
            accessToken: accessToken,
            refreshToken: refreshToken,
            hospitalId: hospitalId,
            expiresAt: expiresAt
        )
        
        try await token.save(on: database)
        return (accessToken, refreshToken, expiresIn)
    }
    
    private func createAccessToken(_ hospital: HospitalAccount) async throws -> String {
        guard let hospitalId = hospital.id else {
            throw Abort(.internalServerError, reason: "병원 계정이 존재하지 않습니다.")
        }
        
        let payload = SessionToken(
            hospitalId: hospitalId,
            email: hospital.email,
            exp: ExpirationClaim(value: Date().addingTimeInterval(3600))
        )
        
        return try await app.jwt.keys.sign(payload)
    }
}
