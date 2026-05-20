//
//  ErrorLog.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/15/25.
//

import Vapor
import Fluent

/// 에러 로그 테이블
final class ErrorLog: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.errorLogs

    @ID(key: .id)
    var id: UUID?

    @OptionalParent(key: "hospital_id")
    var hospital: HospitalAccount?

    @Field(key: "endpoint")
    var endpoint: String

    @Field(key: "method")
    var method: String

    @Field(key: "status_code")
    var statusCode: Int

    @Field(key: "error_message")
    var errorMessage: String

    @OptionalField(key: "stack_trace")
    var stackTrace: String?

    @OptionalField(key: "request_body")
    var requestBody: String?

    @OptionalField(key: "user_agent")
    var userAgent: String?

    @OptionalField(key: "ip_address")
    var ipAddress: String?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() {}

    init(
        id: UUID? = nil,
        hospitalId: UUID? = nil,
        endpoint: String,
        method: String,
        statusCode: Int,
        errorMessage: String,
        stackTrace: String? = nil,
        requestBody: String? = nil,
        userAgent: String? = nil,
        ipAddress: String? = nil
    ) {
        self.id = id
        self.$hospital.id = hospitalId
        self.endpoint = endpoint
        self.method = method
        self.statusCode = statusCode
        self.errorMessage = errorMessage
        self.stackTrace = stackTrace
        self.requestBody = requestBody
        self.userAgent = userAgent
        self.ipAddress = ipAddress
    }
}
