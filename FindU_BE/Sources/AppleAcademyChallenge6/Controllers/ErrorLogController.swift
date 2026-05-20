//
//  ErrorLogController.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/15/25.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct ErrorLogController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let errorLogs = routes.grouped("api", "error-logs")
        let protected = errorLogs.grouped(JWTMiddleware())

        protected.get(use: list)
            .openAPI(
                tags: TagObject(name: "ErrorLog"),
                summary: "에러 로그 목록 조회",
                description: "병원의 에러 로그 목록을 페이지네이션하여 조회합니다. page, perPage, statusCode 파라미터로 필터링 가능합니다.",
                response: .type(CommonResponseDTO<PaginatedErrorLogsResponse>.self)
            )

        protected.get(":id", use: get)
            .openAPI(
                tags: TagObject(name: "ErrorLog"),
                summary: "에러 로그 상세 조회",
                description: "특정 에러 로그의 상세 정보를 조회합니다.",
                response: .type(CommonResponseDTO<ErrorLogResponse>.self)
            )

        protected.delete(":id", use: delete)
            .openAPI(
                tags: TagObject(name: "ErrorLog"),
                summary: "에러 로그 삭제",
                description: "특정 에러 로그를 삭제합니다.",
                response: .type(CommonResponseDTO<EmptyResponse>.self)
            )

        protected.delete("clear", use: clear)
            .openAPI(
                tags: TagObject(name: "ErrorLog"),
                summary: "에러 로그 전체 삭제",
                description: "병원의 모든 에러 로그를 삭제합니다.",
                response: .type(CommonResponseDTO<EmptyResponse>.self)
            )
    }

    // 에러 로그 목록 조회 (페이지네이션 + 필터링)
    func list(_ req: Request) async throws -> CommonResponseDTO<PaginatedErrorLogsResponse> {
        let sessionToken = try req.requireAuth()

        // 쿼리 파라미터
        let page = req.query[Int.self, at: "page"] ?? 1
        let perPage = req.query[Int.self, at: "perPage"] ?? 20
        let statusCode = req.query[Int.self, at: "statusCode"]

        // 쿼리 빌더
        var query = ErrorLog.query(on: req.db)
            .filter(\.$hospital.$id == sessionToken.hospitalId)

        // 상태 코드 필터링
        if let statusCode = statusCode {
            query = query.filter(\.$statusCode == statusCode)
        }

        // 전체 개수 조회
        let total = try await query.count()

        // 페이지네이션 적용 및 최신순 정렬
        let logs = try await query
            .sort(\.$createdAt, .descending)
            .paginate(PageRequest(page: page, per: perPage))
            .items

        let result = PaginatedErrorLogsResponse(
            logs: logs.map { ErrorLogResponse(from: $0) },
            page: page,
            perPage: perPage,
            total: total
        )

        return CommonResponseDTO.success(
            code: ResponseCode.COMMON200,
            message: "에러 로그 목록 조회 성공",
            result: result
        )
    }

    // 에러 로그 상세 조회
    func get(_ req: Request) async throws -> CommonResponseDTO<ErrorLogResponse> {
        let sessionToken = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)

        guard let errorLog = try await ErrorLog.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == sessionToken.hospitalId)
            .first()
        else {
            throw Abort(.notFound, reason: "에러 로그를 찾을 수 없습니다.")
        }

        let result = ErrorLogResponse(from: errorLog)

        return CommonResponseDTO.success(
            code: ResponseCode.COMMON200,
            message: "에러 로그 상세 조회 성공",
            result: result
        )
    }

    // 에러 로그 삭제
    func delete(_ req: Request) async throws -> CommonResponseDTO<EmptyResponse> {
        let sessionToken = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)

        guard let errorLog = try await ErrorLog.query(on: req.db)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == sessionToken.hospitalId)
            .first()
        else {
            throw Abort(.notFound, reason: "에러 로그를 찾을 수 없습니다.")
        }

        try await errorLog.delete(on: req.db)

        return CommonResponseDTO.successNoData(
            code: ResponseCode.COMMON200,
            message: "에러 로그 삭제 성공"
        )
    }

    // 에러 로그 전체 삭제
    func clear(_ req: Request) async throws -> CommonResponseDTO<EmptyResponse> {
        let sessionToken = try req.requireAuth()

        try await ErrorLog.query(on: req.db)
            .filter(\.$hospital.$id == sessionToken.hospitalId)
            .delete()

        return CommonResponseDTO.successNoData(
            code: ResponseCode.COMMON200,
            message: "에러 로그 전체 삭제 성공"
        )
    }
}
