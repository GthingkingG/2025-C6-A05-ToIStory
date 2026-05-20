//
//  DashboardDTO.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/15/25.
//

import Vapor

// 병원별 통계 응답
struct HospitalStatsResponse: Content {
    let hospitalId: UUID
    let hospitalName: String
    let totalAnchors: Int
    let activeAnchors: Int
    let totalPatients: Int
    let totalDevices: Int
    let malfunctioningDevices: Int
    let totalRooms: Int
    let availableRooms: Int
    let totalDepartments: Int
    let totalReports: Int
    let pendingReports: Int
    let recentErrorCount: Int // 최근 24시간 에러 수
}

// 전체 시스템 통계 (모든 병원)
struct SystemStatsResponse: Content {
    let totalHospitals: Int
    let totalPatients: Int
    let totalDevices: Int
    let totalAnchors: Int
    let totalRooms: Int
    let totalErrorsToday: Int
    let hospitals: [HospitalStatsResponse]
}

// 병원별 간단한 요약
struct HospitalSummaryResponse: Content {
    let hospitalId: UUID
    let hospitalName: String
    let businessNumber: String?
    let email: String
    let totalPatients: Int
    let totalDevices: Int
    let createdAt: Date?
}

// 디바이스 상태 통계
struct DeviceStatsResponse: Content {
    let totalDevices: Int
    let normalDevices: Int
    let malfunctioningDevices: Int
    let lowBatteryDevices: Int // 배터리 20% 이하
    let devicesInUse: Int // 환자에게 할당된 디바이스
}

// 에러 통계
struct ErrorStatsResponse: Content {
    let totalErrors: Int
    let errorsToday: Int
    let errorsThisWeek: Int
    let errorsByStatusCode: [StatusCodeCount]
}

struct StatusCodeCount: Content {
    let statusCode: Int
    let count: Int
}
