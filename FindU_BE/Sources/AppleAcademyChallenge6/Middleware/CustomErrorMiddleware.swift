//
//  CustomErrorMiddleware.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine
//

import Vapor

/// Abort 에러를 CommonResponseDTO 형식으로 변환하는 커스텀 에러 미들웨어
struct CustomErrorMiddleware: AsyncMiddleware {

    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch {
            return handleError(error, for: request)
        }
    }

    private func handleError(_ error: any Error, for request: Request) -> Response {
        request.logger.report(error: error)

        let response: Response

        // Abort 에러를 CommonResponseDTO 형식으로 변환
        if let abort = error as? (any AbortError) {
            let responseCode = mapHTTPStatusToResponseCode(abort.status)
            let errorResponse = CommonResponseDTO<EmptyResponse>.error(
                code: responseCode,
                message: abort.reason
            )

            response = Response(status: abort.status)
            do {
                try response.content.encode(errorResponse)
            } catch {
                response.body = .init(string: "Internal server error")
            }
        } else {
            // 기타 에러는 500으로 처리
            let errorResponse = CommonResponseDTO<EmptyResponse>.error(
                code: .ERROR500,
                message: "Internal server error"
            )

            response = Response(status: .internalServerError)
            do {
                try response.content.encode(errorResponse)
            } catch {
                response.body = .init(string: "Internal server error")
            }
        }

        return response
    }

    /// HTTP 상태 코드를 ResponseCode로 매핑
    private func mapHTTPStatusToResponseCode(_ status: HTTPStatus) -> ResponseCode {
        switch status {
        case .badRequest:
            return .ERROR400
        case .unauthorized:
            return .ERROR401
        case .forbidden:
            return .ERROR403
        case .notFound:
            return .ERROR404
        case .conflict:
            return .ERROR409
        case .unprocessableEntity:
            return .ERROR422
        case .internalServerError:
            return .ERROR500
        case .serviceUnavailable:
            return .ERROR503
        default:
            return .ERROR500
        }
    }
}
