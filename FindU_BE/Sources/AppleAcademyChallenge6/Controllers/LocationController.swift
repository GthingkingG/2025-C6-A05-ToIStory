//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct LocationController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let locations = routes.grouped("api", "locations")
        locations.post("calculate", use: calculateLocation)
            .openAPI(
                tags: TagObject(name: TagObjectValue.location),
                summary: "위치 계산 (FTM 기반)",
                description: """
                              FTM(Fine Timing Measurement) 측정값을 사용하여 디바이스의 위치를 계산합니다.
                              
                              - 최소 3개 이상의 앵커 측정값이 필요합니다.
                              - Trilateration 알고리즘을 사용하여 2D/3D 위치를 계산합니다.
                              - 배터리 잔량과 현재 위치 정보도 함께 저장됩니다.
                              
                              **인증:** 불필요 (디바이스에서 직접 호출)
                              """,
                body: .type(LocationCalculateRequestDTO.self),
                response: .type(CommonResponseDTO<LocationCalculateResponseDTO>.self)
            )
    }
    
    func calculateLocation(_ req: Request) async throws -> CommonResponseDTO<LocationCalculateResponseDTO> {
        let dto = try req.content.decode(LocationCalculateRequestDTO.self)
        let locatoinService = req.di.makeLocationService(request: req)
        
        let result = try await locatoinService.calculateLocation(
            serialNumber: dto.serialNumber,
            batteryLevel: dto.batteryLevel,
            floor: dto.floor,
            measurements: dto.measurements
        )
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "위치 계산 성공", result: result)
    }
}
