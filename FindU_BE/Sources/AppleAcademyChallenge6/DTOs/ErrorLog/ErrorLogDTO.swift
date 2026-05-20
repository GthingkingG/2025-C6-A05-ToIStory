//
//  ErrorLogDTO.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/15/25.
//

import Vapor

// 에러 로그 응답 DTO
struct ErrorLogResponse: Content {
    let id: UUID?
    let endpoint: String
    let method: String
    let statusCode: Int
    let errorMessage: String
    let stackTrace: String?
    let requestBody: String?
    let userAgent: String?
    let ipAddress: String?
    let createdAt: Date?

    init(from errorLog: ErrorLog) {
        self.id = errorLog.id
        self.endpoint = errorLog.endpoint
        self.method = errorLog.method
        self.statusCode = errorLog.statusCode
        self.errorMessage = errorLog.errorMessage
        self.stackTrace = errorLog.stackTrace
        self.requestBody = errorLog.requestBody
        self.userAgent = errorLog.userAgent
        self.ipAddress = errorLog.ipAddress
        self.createdAt = errorLog.createdAt
    }
}

// 페이지네이션된 에러 로그 응답
struct PaginatedErrorLogsResponse: Content {
    let logs: [ErrorLogResponse]
    let page: Int
    let perPage: Int
    let total: Int
}
