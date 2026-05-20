//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor
import VaporToOpenAPI

struct DepartmentController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let department = routes.grouped("api", "department")
        let protected = department.grouped(JWTMiddleware())
        
        protected.get("all", use: getAll)
            .openAPI(
                tags: TagObject(name: TagObjectValue.department),
                summary: "부서 전체 조회",
                description: "병원의 모든 부서 목록을 조회",
                response: .type(CommonResponseDTO<[DepartmentDTO]>.self)
            )
        protected.post("regist", use: register)
            .openAPI(
                tags: TagObject(name: TagObjectValue.department),
                summary: "부서 등록",
                description: "새로운 부서를 등록합니다.",
                body: .type(DepartmentAddRequest.self),
                response: .type(CommonResponseDTO<DepartmentDTO>.self)
            )
        protected.patch(":id", use: update)
            .openAPI(
                tags: TagObject(name: TagObjectValue.department),
                summary: "부서 수정",
                description: "기존 부서 정보를 수정합니다.",
                body: .type(DepartmentUpdateRequest.self),
                response: .type(CommonResponseDTO<DepartmentDTO>.self)
            )
        protected.delete(":id", use: delete)
            .openAPI(
                tags: TagObject(name: TagObjectValue.department),
                summary: "부서 삭제",
                description: "부서를 삭제합니다.",
                response: .type(CommonResponseDTO<EmptyResponse>.self)
            )
    }
    
    func getAll(_ req: Request) async throws -> CommonResponseDTO<[DepartmentDTO]> {
        let sessionToken = try req.requireAuth()
        let service = req.di.makeDepartmentService(request: req)
        
        let department = try await service.getAllDepartments(hospitalId: sessionToken.hospitalId)
        let result = department.map { DepartmentDTO(from: $0) }
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "부서 전체 조회 성공", result: result)
    }
    
    func register(_ req: Request) async throws -> CommonResponseDTO<DepartmentDTO> {
        let dto = try req.content.decode(DepartmentAddRequest.self)
        let sessionToken = try req.requireAuth()
        let service = req.di.makeDepartmentService(request: req)
        
        let department = try await service.createDepartment(
            hospitalId: sessionToken.hospitalId,
            name: dto.name,
            code: dto.code,
            description: dto.description
        )
        
        let result = DepartmentDTO(from: department)
        return CommonResponseDTO.success(code: ResponseCode.CREATED201, message: "부서 등록 성공", result: result)
    }
    
    func update(_ req: Request) async throws -> CommonResponseDTO<DepartmentDTO> {
        let dto = try req.content.decode(DepartmentUpdateRequest.self)
        let sessionToken = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)
        let service = req.di.makeDepartmentService(request: req)
        let room = try await service.updateDepartment(
            id: id,
            hospitalId: sessionToken.hospitalId,
            name: dto.name,
            code: dto.code,
            description: dto.description
        )
        
        let result = DepartmentDTO(from: room)
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "부서 수정 성공", result: result)
    }
    
    func delete(_ req: Request) async throws -> CommonResponseDTO<EmptyResponse> {
        let session = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)
        
        let service = req.di.makeDepartmentService(request: req)
        try await service.deleteDepartment(id: id, hospitalId: session.hospitalId)
        
        return CommonResponseDTO.successNoData(code: ResponseCode.COMMON200, message: "부서 삭제 성공")
    }
}
