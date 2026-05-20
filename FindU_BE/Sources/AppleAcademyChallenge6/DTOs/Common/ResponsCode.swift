//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor

struct ResponseCode: Content {
    
    let code: String
    let httpStatus: HTTPStatus
    
    // MARK: - Success Codes (2xx)
    
    /// 200 OK - 일반적인 성공
    static let COMMON200 = ResponseCode(code: "COMMON200", httpStatus: .ok)
    
    /// 201 Created - 리소스 생성 성공
    static let CREATED201 = ResponseCode(code: "CREATED201", httpStatus: .created)
    
    /// 204 No Content - 성공했지만 응답 데이터 없음
    static let NO_CONTENT204 = ResponseCode(code: "NO_CONTENT204", httpStatus: .noContent)
    
    // MARK: - Client Error Codes (4xx)
    
    /// 400 Bad Request - 잘못된 요청
    static let ERROR400 = ResponseCode(code: "ERROR400", httpStatus: .badRequest)
    
    /// 401 Unauthorized - 인증 실패
    static let ERROR401 = ResponseCode(code: "ERROR401", httpStatus: .unauthorized)
    
    /// 403 Forbidden - 권한 없음
    static let ERROR403 = ResponseCode(code: "ERROR403", httpStatus: .forbidden)
    
    /// 404 Not Found - 리소스를 찾을 수 없음
    static let ERROR404 = ResponseCode(code: "ERROR404", httpStatus: .notFound)
    
    /// 409 Conflict - 리소스 충돌 (중복 등)
    static let ERROR409 = ResponseCode(code: "ERROR409", httpStatus: .conflict)
    
    /// 422 Unprocessable Entity - 유효성 검증 실패
    static let ERROR422 = ResponseCode(code: "ERROR422", httpStatus: .unprocessableEntity)
    
    // MARK: - Server Error Codes (5xx)
    
    /// 500 Internal Server Error - 서버 내부 오류
    static let ERROR500 = ResponseCode(code: "ERROR500", httpStatus: .internalServerError)
    
    /// 503 Service Unavailable - 서비스 이용 불가
    static let ERROR503 = ResponseCode(code: "ERROR503", httpStatus: .serviceUnavailable)
}

// MARK: - Equatable

extension ResponseCode: Equatable {
    static func == (lhs: ResponseCode, rhs: ResponseCode) -> Bool {
        return lhs.code == rhs.code
    }
}
