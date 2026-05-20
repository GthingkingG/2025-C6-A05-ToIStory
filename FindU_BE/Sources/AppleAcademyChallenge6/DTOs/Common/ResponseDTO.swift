//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/13/25.
//

import Vapor

struct CommonResponseDTO<T: Content>: Content {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
    
    enum CodingKeys: String, CodingKey {
        case isSuccess = "is_success"
        case code
        case message
        case result
    }
    
    static func success(
        code: ResponseCode,
        message: String,
        result: T
    ) -> CommonResponseDTO<T> {
        return CommonResponseDTO(
            isSuccess: true,
            code: code.code,
            message: message,
            result: result
        )
    }
    
    static func successNoData(
        code: ResponseCode,
        message: String
    ) -> CommonResponseDTO<EmptyResponse> where T == EmptyResponse {
        return CommonResponseDTO<EmptyResponse>(
            isSuccess: true,
            code: code.code,
            message: message,
            result: nil
        )
    }
    
    static func error(
        code: ResponseCode,
        message: String
    ) -> CommonResponseDTO<EmptyResponse> where T == EmptyResponse {
        return CommonResponseDTO<EmptyResponse>(
            isSuccess: false,
            code: code.code,
            message: message,
            result: nil
        )
    }
}

extension CommonResponseDTO: AsyncResponseEncodable {
    
    /// Response로 인코딩
    func encodeResponse(for request: Request) async throws -> Response {
        let response = Response()
        
        // HTTP 상태 코드 설정
        if let responseCode = getResponseCode(from: code) {
            response.status = responseCode.httpStatus
        } else {
            response.status = isSuccess ? .ok : .internalServerError
        }
        
        // JSON 인코딩
        try response.content.encode(self)
        
        return response
    }
    
    /// 코드 문자열로 ResponseCode 찾기
    private func getResponseCode(from codeString: String) -> ResponseCode? {
        switch codeString {
        case "COMMON200": return .COMMON200
        case "CREATED201": return .CREATED201
        case "NO_CONTENT204": return .NO_CONTENT204
        case "ERROR400": return .ERROR400
        case "ERROR401": return .ERROR401
        case "ERROR403": return .ERROR403
        case "ERROR404": return .ERROR404
        case "ERROR409": return .ERROR409
        case "ERROR422": return .ERROR422
        case "ERROR500": return .ERROR500
        case "ERROR503": return .ERROR503
        default: return nil
        }
    }
}

struct EmptyResponse: Content {}
