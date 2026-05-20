//
//  DashboardController.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/15/25.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct DashboardController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let dashboard = routes.grouped("api", "dashboard")
        let protected = dashboard.grouped(JWTMiddleware())

        // 내 병원 통계
        protected.get("my-stats", use: getMyHospitalStats)
            .openAPI(
                tags: TagObject(name: "Dashboard"),
                summary: "내 병원 통계 조회",
                description: "로그인한 병원의 통계 정보를 조회합니다. (앵커, 환자, 디바이스, 병실, 부서, 리포트, 에러 수)",
                response: .type(CommonResponseDTO<HospitalStatsResponse>.self)
            )

        // 디바이스 상태 통계
        protected.get("device-stats", use: getDeviceStats)
            .openAPI(
                tags: TagObject(name: "Dashboard"),
                summary: "디바이스 상태 통계",
                description: "병원의 디바이스 상태별 통계를 조회합니다. (정상, 고장, 저배터리, 사용중)",
                response: .type(CommonResponseDTO<DeviceStatsResponse>.self)
            )

        // 에러 통계
        protected.get("error-stats", use: getErrorStats)
            .openAPI(
                tags: TagObject(name: "Dashboard"),
                summary: "에러 통계",
                description: "병원의 에러 발생 통계를 조회합니다. (전체, 오늘, 이번주, 상태코드별)",
                response: .type(CommonResponseDTO<ErrorStatsResponse>.self)
            )

        // 전체 병원 목록 (관리자용)
        protected.get("hospitals", use: getAllHospitals)
            .openAPI(
                tags: TagObject(name: "Dashboard"),
                summary: "전체 병원 목록 조회",
                description: "모든 병원의 요약 정보를 조회합니다.",
                response: .type(CommonResponseDTO<[HospitalSummaryResponse]>.self)
            )
    }

    // 내 병원 통계
    func getMyHospitalStats(_ req: Request) async throws -> CommonResponseDTO<HospitalStatsResponse> {
        let sessionToken = try req.requireAuth()
        let hospitalId = sessionToken.hospitalId
        let service = req.di.makeDashboardService(request: req)

        let stats = try await service.getMyHospitalStats(hospitalId: hospitalId)

        return CommonResponseDTO.success(
            code: ResponseCode.COMMON200,
            message: "병원 통계 조회 성공",
            result: stats
        )
    }

    // 디바이스 상태 통계
    func getDeviceStats(_ req: Request) async throws -> CommonResponseDTO<DeviceStatsResponse> {
        let sessionToken = try req.requireAuth()
        let hospitalId = sessionToken.hospitalId
        let service = req.di.makeDashboardService(request: req)

        let stats = try await service.getDeviceStats(hospitalId: hospitalId)

        return CommonResponseDTO.success(
            code: ResponseCode.COMMON200,
            message: "디바이스 통계 조회 성공",
            result: stats
        )
    }

    // 에러 통계
    func getErrorStats(_ req: Request) async throws -> CommonResponseDTO<ErrorStatsResponse> {
        let sessionToken = try req.requireAuth()
        let hospitalId = sessionToken.hospitalId
        let service = req.di.makeDashboardService(request: req)

        let stats = try await service.getErrorStats(hospitalId: hospitalId)

        return CommonResponseDTO.success(
            code: ResponseCode.COMMON200,
            message: "에러 통계 조회 성공",
            result: stats
        )
    }

    // 전체 병원 목록
    func getAllHospitals(_ req: Request) async throws -> CommonResponseDTO<[HospitalSummaryResponse]> {
        let service = req.di.makeDashboardService(request: req)
        let summaries = try await service.getAllHospitalsWithStats()

        return CommonResponseDTO.success(
            code: ResponseCode.COMMON200,
            message: "전체 병원 목록 조회 성공",
            result: summaries
        )
    }
}
