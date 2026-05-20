//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor
import VaporToOpenAPI

struct DeviceController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let devices = routes.grouped("api", "devices")
        let protected = devices.grouped(JWTMiddleware())
        
        protected.get("all", use: getAll)
            .openAPI(
                tags: TagObject(name: TagObjectValue.device),
                summary: "디바이스 전체 조회",
                description: "병원의 모든 디바이스 목록을 조회합니다.",
                response: .type(CommonResponseDTO<[DeviceDTO]>.self)
            )
        protected.post("regist", use: register)
            .openAPI(
                tags: TagObject(name: TagObjectValue.device),
                summary: "디바이스 등록",
                description: "새로운 디바이스를 등록합니다. 시리얼 넘버를 사용하여 디바이스 식별",
                body: .type(DeviceAddRequest.self),
                response: .type(CommonResponseDTO<DeviceDTO>.self)
            )
        protected.post("malfunction", use: reportMalfunctions)
            .openAPI(
                tags: TagObject(name: TagObjectValue.device),
                summary: "디바이스 고장 신고",
                description: "여러 디바이스의 고장을 일괄 신고합니다.",
                body: .type(ReportMalfunctionRequest.self),
                response: .type(CommonResponseDTO<BulkMalfunctionResult>.self)
            )
        protected.delete(":serialNumber", use: delete)
            .openAPI(
                tags: TagObject(name: TagObjectValue.device),
                summary: "디바이스 삭제",
                description: "시리얼 넘버로 디바이스를 삭제합니다.",
                response: .type(CommonResponseDTO<EmptyResponse>.self)
            )
    }
    
    func getAll(_ req: Request) async throws -> CommonResponseDTO<[DeviceDTO]> {
        let sessionToken = try req.requireAuth()
        let service = req.di.makeDeviceService(request: req)
        
        let devices = try await service.getAllDevices(hospitalId: sessionToken.hospitalId)
        
        let result = devices.map { DeviceDTO(from: $0) }
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "기기 목록 조회 성공", result: result)
    }
    
    func register(_ req: Request) async throws -> CommonResponseDTO<DeviceDTO> {
        let dto = try req.content.decode(DeviceAddRequest.self)
        
        let sessionToken = try req.requireAuth()
        let service = req.di.makeDeviceService(request: req)
        
        let device = try await service.creatreDevice(
            hospitalId: sessionToken.hospitalId,
            serialNumber: dto.serialNumber
        )
        
        let result = DeviceDTO(from: device)
        
        return CommonResponseDTO.success(code: ResponseCode.CREATED201, message: "기기 등록 성공", result: result)
    }
    
    func reportMalfunctions(_ req: Request) async throws -> CommonResponseDTO<BulkMalfunctionResult> {
        let dto = try req.content.decode(ReportMalfunctionRequest.self)
        let sessionToken = try req.requireAuth()
        let service = req.di.makeDeviceService(request: req)
        
        let result = try await service.reportMalfunctions(
            serialNumbers: dto.serialNumber,
            hospitalId: sessionToken.hospitalId
        )
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "기기 고장 신고 완료", result: result)
    }
    
    func delete(_ req: Request) async throws -> CommonResponseDTO<EmptyResponse> {
        let sessionToken = try req.requireAuth()
        let serialNumber = try req.parameters.require("serialNumber", as: String.self)
        
        let service = req.di.makeDeviceService(request: req)
        try await service.deleteDevice(serialNumber: serialNumber, hospitalId: sessionToken.hospitalId)
        
        return CommonResponseDTO.successNoData(code: ResponseCode.COMMON200, message: "기기 삭제 성공")
    }
}
