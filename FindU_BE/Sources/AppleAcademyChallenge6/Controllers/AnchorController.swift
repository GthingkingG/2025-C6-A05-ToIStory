//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor
import Fluent
import VaporToOpenAPI

struct AnchorController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let anchors = routes.grouped("api", "anchors")
        let protected = anchors.grouped(JWTMiddleware())
        
        protected.get("all", use: list)
            .openAPI(
                tags: TagObject(name: TagObjectValue.anchors),
                summary: "앵커 전체 조회",
                description: "병원의 모든 앵커 목록을 조회합니다.",
                response: .type(CommonResponseDTO<[AnchorDTO]>.self)
            )
        protected.get("floor", ":floor", use: getByFloor)
            .openAPI(
                tags: TagObject(name: TagObjectValue.anchors),
                summary: "층별 앵커 조회",
                description: "특정 층의 앵커 목록을 조회합니다.",
                response: .type(CommonResponseDTO<[AnchorDTO]>.self)
            )
        protected.post("create", use: create)
            .openAPI(
                tags: TagObject(name: TagObjectValue.anchors),
                summary: "앵커 생성",
                description: "새로운 앵커를 생성합니다.",
                body: .type(AnchorAddRequest.self),
                response: .type(CommonResponseDTO<AnchorDTO>.self)
            )
        protected.patch("update", ":id", use: update)
            .openAPI(
                tags: TagObject(name: TagObjectValue.anchors),
                summary: "앵커 수정",
                description: "기존 앵커 정보를 수정합니다.",
                body: .type(AnchorUpdateRequest.self),
                response: .type(CommonResponseDTO<AnchorDTO>.self)
            )
        protected.delete(":id", use: delete)
            .openAPI(
                tags: TagObject(name: TagObjectValue.anchors),
                summary: "앵커 삭제",
                description: "앵커를 삭제합니다.",
                response: .type(CommonResponseDTO<EmptyResponse>.self)
            )
    }
    
    func list(_ req: Request) async throws -> CommonResponseDTO<[AnchorDTO]> {
        let sessionToken = try req.requireAuth()
        let service = req.di.makeAnchorService(request: req)
        let anchors = try await service.getAllAnchors(hospitalId: sessionToken.hospitalId)
        let result = anchors.map { AnchorDTO(from: $0) }
        
        return CommonResponseDTO.success(
            code: ResponseCode.COMMON200,
            message: "앵커 목록 조회 성공",
            result: result)
    }
    
    func getByFloor(_ req: Request) async throws -> CommonResponseDTO<[AnchorDTO]> {
        let sessionToken = try req.requireAuth()
        let floor = try req.parameters.require("floor", as: Int.self)
        let service = req.di.makeAnchorService(request: req)
        let anchors = try await service.getAnchorsByFloor(floor: floor, hospitalId: sessionToken.hospitalId)
        let result = anchors.map { AnchorDTO(from: $0) }
        
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "층별 앵커 조회 성공", result: result)
    }
    
    func create(_ req: Request) async throws -> CommonResponseDTO<AnchorDTO> {
        let dto = try req.content.decode(AnchorAddRequest.self)
        let sessionToken = try req.requireAuth()
        let service = req.di.makeAnchorService(request: req)

        // 디버깅: 요청으로 들어온 position 값 로깅
        req.logger.info("📍 [Anchor Create] 요청 받은 좌표 - X: \(dto.positionX), Y: \(dto.positionY), Z: \(dto.positionZ?.description ?? "nil")")

        let anchor = try await service.createAnchor(
            hospitalId: sessionToken.hospitalId,
            macAddress: dto.macAddress,
            zoneType: dto.zoneType,
            zoneName: dto.zoneName,
            floor: dto.floor,
            positionX: dto.positionX,
            positionY: dto.positionY,
            positionZ: dto.positionZ
        )

        let result = AnchorDTO(from: anchor)

        // 디버깅: 응답으로 반환되는 position 값 로깅
        req.logger.info("📍 [Anchor Create] 반환 좌표 - X: \(result.positionX), Y: \(result.positionY), Z: \(result.positionZ?.description ?? "nil")")

        return CommonResponseDTO.success(code: ResponseCode.CREATED201, message: "앵커 생성 성공", result: result
        )
    }
    
    func update(_ req: Request) async throws -> CommonResponseDTO<AnchorDTO> {
        let dto = try req.content.decode(AnchorUpdateRequest.self)
        let sesstionToken = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)
        let service = req.di.makeAnchorService(request: req)
        
        let anchor = try await service.updateAnchor(
            id: id,
            hospitalId: sesstionToken.hospitalId,
            zoneType: dto.zoneType,
            zoneName: dto.zoneName,
            floor: dto.floor,
            positionX: dto.positionX,
            positionY: dto.positionY,
            positionZ: dto.positionZ
        )
        
        let result = AnchorDTO(from: anchor)
        return CommonResponseDTO.success(code: ResponseCode.COMMON200, message: "앵커 수정 성공", result: result)
    }
    
    func delete(_ req: Request) async throws -> CommonResponseDTO<EmptyResponse> {
        let sessionToken = try req.requireAuth()
        let id = try req.parameters.require("id", as: UUID.self)
        let service = req.di.makeAnchorService(request: req)
        
        try await service.deleteAnchort(id: id, hospitalId: sessionToken.hospitalId)
        
        return CommonResponseDTO.successNoData(code: ResponseCode.COMMON200, message: "앵커 삭제 성공")
    }
}
