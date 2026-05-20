//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct PatientController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let patients = routes.grouped("api", "patients")
        let protected = patients.grouped(JWTMiddleware())
        
        protected.get("all", use: list)
            .openAPI(
                tags: TagObject(name: TagObjectValue.patient),
                summary: "환자 전체 조회",
                description: "병원의 모든 환자 목록을 조회합니다.",
                response: .type(CommonResponseDTO<[PatientDetailResponse]>.self)
            )
        protected.get("ward", ":ward", use: getByWard)
            .openAPI(
                tags: TagObject(name: TagObjectValue.patient),
                summary: "병동별 환자 조회",
                description: "특정 병동의 환자 목록을 조회합니다.",
                response: .type(CommonResponseDTO<[PatientDTO]>.self)
            )
        protected.get(":id", use: get)
            .openAPI(
                tags: TagObject(name: TagObjectValue.patient),
                summary: "환자 상세 조회",
                description: "특정 병동의 환자 목록을 조회합니다. 디바이스 연결 정보 및 현재 위치 포함",
                response: .type(CommonResponseDTO<PatientDetailResponse>.self)
            )
        protected.post("create", use: create)
            .openAPI(
                tags: TagObject(name: TagObjectValue.patient),
                summary: "환자 등록",
                description: "새로운 환자를 등록합니다. 디바이스 시리얼 넘버를 통해 디바스와 연결 할 수 있다.",
                body: .type(PatientAddRequest.self),
                response: .type(CommonResponseDTO<PatientDTO>.self)
            )
        protected.patch(":id", use: update)
            .openAPI(
                tags: TagObject(name: TagObjectValue.patient),
                summary: "환자 정보 수정",
                description: "기존 환자의 정보를 수정합니다. 병동, 병상, 부서, 메모 등을 업데이트할 수 있습니다.",
                body: .type(PatientUpdateRequest.self),
                response: .type(CommonResponseDTO<PatientDTO>.self)
            )
        protected.delete(":id", use: delete)
            .openAPI(
                tags: TagObject(name: TagObjectValue.patient),
                summary: "환자 삭제",
                description: "환자 정보를 삭제합니다. 연결된 디바이스는 자동으로 해제됩니다",
                response: .type(CommonResponseDTO<EmptyResponse>.self)
            )
    }
    
    func list(_ req: Request) async throws -> CommonResponseDTO<[PatientDetailResponse]> {
        let sessionToken = try req.requireAuth()
        let service = req.di.makePatientService(request: req)
        let patients = try await service.getAllPatients(hospitalId: sessionToken.hospitalId)
        let result = patients.map { PatientDetailResponse(from: $0) }
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "환자 목록 조회 성공", result: result)
    }
    
    func getByWard(_ req: Request) async throws -> CommonResponseDTO<[PatientDTO]> {
        let sessionToken = try req.requireAuth()
        let ward = try req.parameters.require("ward", as: String.self)
        let service = req.di.makePatientService(request: req)
        let patients = try await service.getPatientsByWard(ward: ward, hospitalId: sessionToken.hospitalId)
        let result = patients.map { PatientDTO(from: $0) }
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "병동별 환자 조회 성공", result: result)
    }
    
    func get(_ req: Request) async throws -> CommonResponseDTO<PatientDetailResponse> {
        let sessionToken = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)
        let service = req.di.makePatientService(request: req)
        let patient = try await service.getPatient(id: id, hospitalId: sessionToken.hospitalId)
        let result = PatientDetailResponse(from: patient)
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "환자 상세 조회 성공", result: result)
    }
    
    func create(_ req: Request) async throws -> CommonResponseDTO<PatientDTO> {
        let dto = try req.content.decode(PatientAddRequest.self)
        let sessionToken = try req.requireAuth()
        let service = req.di.makePatientService(request: req)
        
        let patient = try await service.createPatient(
            hospitalId: sessionToken.hospitalId,
            name: dto.name,
            ward: dto.ward,
            bed: dto.bed,
            departmentId: dto.departmentId,
            deviceSerial: dto.deviceSerial,
            memo: dto.memo
        )
        
        try await patient.$device.load(on: req.db)
        try await patient.$department.load(on: req.db)
        
        let result = PatientDTO(from: patient)
        return CommonResponseDTO.success(code: ResponseCode.CREATED201, message: "환자 등록 성공", result: result)
    }
    
    func update(_ req: Request) async throws -> CommonResponseDTO<PatientDTO> {
        let dto = try req.content.decode(PatientUpdateRequest.self)
        let sessionToken = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)
        let service = req.di.makePatientService(request: req)
        
        let patient = try await service.updatePatient(
            id: id,
            hospitalId: sessionToken.hospitalId,
            name: dto.name,
            ward: dto.ward,
            bed: dto.bed,
            departmentId: dto.departmentId,
            memo: dto.memo
        )
        
        try await patient.$device.load(on: req.db)
        try await patient.$department.load(on: req.db)
        
        let result = PatientDTO(from: patient)
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "환자 수정 성공", result: result
        )
    }
    
    func delete(_ req: Request) async throws -> CommonResponseDTO<EmptyResponse> {
        let sessionToken = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)
        let service = req.di.makePatientService(request: req)
        
        try await service.deletePatient(id: id, hospitalId: sessionToken.hospitalId)
        
        return CommonResponseDTO.successNoData(code: ResponseCode.COMMON200, message: "환자 삭제 성공")
    }
}
