//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/13/25.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct AuthController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let auth = routes.grouped("api", "auth")
        
        auth.post("register", use: register)
            .openAPI(tags: TagObject(name: TagObjectValue.auth),
                     summary: "회원가입",
                     description: "새로운 병원을 등록합니다.",
                     body: .type(RegisterRequestDTO.self),
                     response: .type(CommonResponseDTO<AuthResponseDTO>.self)
            )
        auth.post("login", use: login)
            .openAPI(tags: TagObject(name: TagObjectValue.auth),
                     summary: "로그인",
                     description: "병원 계정으로 로그인합니다.",
                     body: .type(LoginRequestDTO.self),
                     response: .type(CommonResponseDTO<AuthResponseDTO>.self)
            )
        auth.post("refresh", use: refresh)
            .openAPI(tags: TagObject(name: TagObjectValue.auth),
                     summary: "Access Token 갱신",
                     description: "Refresh Token을 사용하여 새로운 Access Token을 발급받는다.",
                     body: .type(RefreshRequest.self),
                     response: .type(CommonResponseDTO<TokenResponseDTO>.self)
            )
        let protected = auth.grouped(JWTMiddleware())
        
        protected.post("logout", use: logout)
            .openAPI(tags: TagObject(name: TagObjectValue.auth),
                     summary: "로그아웃",
                     description: "로그아웃하여 Refresh Token을 무효화합니다.",
                     body: .type(LogoutRequest.self),
                     response: .type(CommonResponseDTO<EmptyResponse>.self)
            )
        
        protected.delete("withdraw", use: withdraw)
            .openAPI(tags: TagObject(name: TagObjectValue.auth),
                     summary: "회원 탈퇴",
                     description: "비밀번호 확인 후 계정을 삭제합니다.",
                     body: .type(WithdrawRequest.self),
                     response: .type(CommonResponseDTO<EmptyResponse
                                     >.self)
            )
    }
    
    /// 회원가입
    ///
    /// **요청:**
    /// ```json
    /// {
    ///   "email": "hospital@example.com",
    ///   "password": "password123",
    ///   "hospital_name": "서울대병원",
    ///   "business_number": "123-45-67890"
    /// }
    /// ```
    ///
    /// **응답:**
    /// - Access Token (1시간)
    /// - Refresh Token (7일)
    /// - 병원 정보
    func register(_ req: Request) async throws -> CommonResponseDTO<AuthResponseDTO> {
        let dto = try req.content.decode(RegisterRequestDTO.self)
        try dto.validate()
        
        let service = req.di.makeAuthService(request: req)
        
        let result = try await service.register(
            email: dto.email,
            password: dto.password,
            hospitalName: dto.hospitalName,
            businessNumber: dto.businessNumber
        )
        
        return CommonResponseDTO.success(code: ResponseCode.CREATED201, message: "회원가입 성공", result: result)
    }
    // MARK: - Login
       
       /// 로그인
       ///
       /// **요청:**
       /// ```json
       /// {
       ///   "email": "hospital@example.com",
       ///   "password": "password123"
       /// }
       /// ```
       ///
       /// **응답:**
       /// - Access Token (1시간)
       /// - Refresh Token (7일)
       /// - 병원 정보
    func login(_ req: Request) async throws -> CommonResponseDTO<AuthResponseDTO> {
        let dto = try req.content.decode(LoginRequestDTO.self)
        try dto.validate()
        
        let service = req.di.makeAuthService(request: req)
        
        let result = try await service.login(email: dto.email, password: dto.password)
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "로그인 성공", result: result)
    }
    
    // MARK: - Refresh Token
        
        /// Access Token 갱신
        ///
        /// **요청:**
        /// ```json
        /// {
        ///   "refresh_token": "rR3fR3shT0k3n..."
        /// }
        /// ```
        ///
        /// **응답:**
        /// - 새로운 Access Token (1시간)
        /// - 기존 Refresh Token (연장됨)
    func refresh(_ req: Request) async throws -> CommonResponseDTO<TokenResponseDTO> {
        let dto = try req.content.decode(RefreshRequest.self)
        
        guard !dto.refreshToken.isEmpty else {
            throw Abort(.badRequest, reason: "리프레시 토큰 필수 입력")
        }
        
        let service = req.di.makeAuthService(request: req)
        let result = try await service.refreshAccessToken(refreshToken: dto.refreshToken)
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "토큰 갱신 성공", result: result)
    }
    
    // MARK: - Logout
        
        /// 로그아웃
        ///
        /// **요청 헤더:**
        /// ```
        /// Authorization: Bearer {access_token}
        /// ```
        ///
        /// **요청 바디:**
        /// ```json
        /// {
        ///   "refresh_token": "rR3fR3shT0k3n..."
        /// }
        /// ```
        ///
        /// **동작:**
        /// - Refresh Token을 데이터베이스에서 삭제
        /// - Access Token은 클라이언트에서 삭제해야 함
    func logout(_ req: Request) async throws -> CommonResponseDTO<EmptyResponse> {
        let dto = try req.content.decode(LogoutRequest.self)
        let sessionToken = try req.requireAuth()
        let service = req.di.makeAuthService(request: req)
        
        try await service.logout(refreshToken: dto.refreshToken, hospitalId: sessionToken.hospitalId)
        
        return CommonResponseDTO.successNoData(code: ResponseCode.COMMON200, message: "로그아웃 성공")
    }
    
    func withdraw(_ req: Request) async throws -> CommonResponseDTO<EmptyResponse> {
        let dto = try req.content.decode(WithdrawRequest.self)
        let session = try req.requireAuth()
        let service = req.di.makeAuthService(request: req)
        
        try await service.deleteAccount(hospitalId: session.hospitalId, password: dto.password)
        return CommonResponseDTO.successNoData(code: ResponseCode.COMMON200, message: "회원탈퇴 성공")
    }
}
