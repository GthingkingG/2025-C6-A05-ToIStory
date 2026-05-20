//
//  ErrorLoggingMiddleware.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/15/25.
//

import Vapor

struct ErrorLoggingMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        do {
            let response = try await next.respond(to: request)

            // 4xx, 5xx 에러 상태 코드는 로깅
            if response.status.code >= 400 {
                await logError(request: request, statusCode: Int(response.status.code), error: nil)
            }

            return response
        } catch {
            // 예외 발생 시 로깅
            let statusCode = (error as? (any AbortError))?.status.code ?? 500
            await logError(request: request, statusCode: Int(statusCode), error: error)

            // 에러를 다시 던져서 기본 에러 핸들러가 처리하도록 함
            throw error
        }
    }

    private func logError(request: Request, statusCode: Int, error: (any Error)?) async {
        do {
            // 세션 토큰에서 hospitalId 추출 (있는 경우)
            let hospitalId = request.auth.get(SessionToken.self)?.hospitalId

            // 에러 메시지 추출
            let errorMessage: String
            let stackTrace: String?

            if let error = error {
                errorMessage = error.localizedDescription
                stackTrace = String(describing: error)
            } else {
                errorMessage = "HTTP Error \(statusCode)"
                stackTrace = nil
            }

            // 요청 본문 추출 (옵션)
            let requestBody: String?
            let contentType = request.headers.first(name: .contentType) ?? ""

            // 멀티파트 데이터나 바이너리 데이터는 로깅하지 않음
            if contentType.contains("multipart") {
                requestBody = "[Multipart Form Data - 생략됨]"
            } else if let bodyBuffer = request.body.data {
                let bodySize = bodyBuffer.readableBytes
                // 10KB 이상의 데이터는 로깅하지 않음
                if bodySize > 10_240 {
                    requestBody = "[Request body too large (\(bodySize) bytes) - 생략됨]"
                } else {
                    let bodyString = String(buffer: bodyBuffer)
                    requestBody = bodyString.allSatisfy({ $0.isASCII }) ? bodyString : "[Binary data - 생략됨]"
                }
            } else {
                requestBody = nil
            }

            // 사용자 에이전트 추출
            let userAgent = request.headers.first(name: .userAgent)

            // IP 주소 추출
            let ipAddress = request.headers.first(name: "X-Forwarded-For")
                ?? request.remoteAddress?.description

            // ErrorLog 생성
            let errorLog = ErrorLog(
                hospitalId: hospitalId,
                endpoint: request.url.path,
                method: request.method.rawValue,
                statusCode: statusCode,
                errorMessage: errorMessage,
                stackTrace: stackTrace,
                requestBody: requestBody,
                userAgent: userAgent,
                ipAddress: ipAddress
            )

            // DB에 저장
            try await errorLog.save(on: request.db)
        } catch {
            // 로깅 실패 시에도 원래 요청이 실패하지 않도록 에러를 무시
            request.logger.error("Failed to log error: \(error)")
        }
    }
}
