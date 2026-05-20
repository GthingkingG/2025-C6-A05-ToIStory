//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Vapor
import JWT

struct JWTMiddleware: AsyncMiddleware {
    
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {

        // 1. Authorization 헤더 확인
        guard let authHeader = request.headers[.authorization].first else {
            throw Abort(.unauthorized, reason: "Missing authorization header")
        }

        // 2. Bearer 토큰 추출
        guard authHeader.hasPrefix("Bearer ") else {
            throw Abort(.unauthorized, reason: "Invalid authorization format. Expected: Bearer {token}")
        }

        let token = authHeader.replacingOccurrences(of: "Bearer ", with: "")

        // 3. JWT 검증 및 SessionToken 추출
        let sessionToken: SessionToken
        do {
            sessionToken = try await request.jwt.verify(token, as: SessionToken.self)
        } catch let error as JWTError {
            // JWT 검증 실패
            throw Abort(.unauthorized, reason: "Invalid token: \(error.localizedDescription)")
        } catch {
            // 기타 JWT 관련 에러
            throw Abort(.unauthorized, reason: "Token verification failed")
        }

        // 4. Request에 SessionToken 저장
        request.auth.login(sessionToken)

        // 5. 다음 핸들러로 전달 (이후 발생하는 에러는 그대로 전파됨)
        return try await next.respond(to: request)
    }
}
