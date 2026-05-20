//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Vapor
import Fluent

final class AnchorService: ServiceProtocol {
    var database: any Database
    
    init(database: any Database) {
        self.database = database
    }
    
    // MARK: - 앵커 전체 조회
    func getAllAnchors(hospitalId: UUID) async throws -> [Anchor] {
        try await Anchor.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .all()
    }
    
    // MARK: - 층별 앵커 조회
    func getAnchorsByFloor(floor: Int, hospitalId: UUID) async throws -> [Anchor] {
        try await Anchor.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .filter(\.$floor == floor)
            .all()
    }
    
    // MARK:  - 앵커 등록
    func createAnchor(
        hospitalId: UUID,
        macAddress: String,
        zoneType: String,
        zoneName: String,
        floor: Int,
        positionX: Double,
        positionY: Double,
        positionZ: Double?
    ) async throws -> Anchor {
        if let _ = try await Anchor.query(on: database)
            .filter(\.$macAddress == macAddress)
            .first() {
            throw Abort(.conflict, reason: "앵커 맥 주소 이미 존재합니다.")
        }

        // 디버깅: Service에서 받은 position 값 로깅
        print("🔧 [AnchorService] createAnchor 파라미터 - X: \(positionX), Y: \(positionY), Z: \(positionZ?.description ?? "nil")")

        let anchor = Anchor(
            hospitalId: hospitalId,
            macAddress: macAddress,
            zoneType: zoneType,
            zoneName: zoneName,
            floor: floor,
            positionX: positionX,
            positionY: positionY,
            positionZ: positionZ
        )

        // 디버깅: DB 저장 전 Anchor 객체의 position 값 로깅
        print("🔧 [AnchorService] DB 저장 전 Anchor 객체 - X: \(anchor.positionX), Y: \(anchor.positionY), Z: \(anchor.positionZ?.description ?? "nil")")

        try await anchor.save(on: database)

        // 디버깅: DB 저장 후 Anchor 객체의 position 값 로깅
        print("🔧 [AnchorService] DB 저장 후 Anchor 객체 - X: \(anchor.positionX), Y: \(anchor.positionY), Z: \(anchor.positionZ?.description ?? "nil")")

        return anchor
    }
    
    // MARK: - 앵커 수정
    func updateAnchor(
        id: UUID,
        hospitalId: UUID,
        zoneType: String?,
        zoneName: String?,
        floor: Int?,
        positionX: Double?,
        positionY: Double?,
        positionZ: Double?
    ) async throws -> Anchor {
        guard let anchor = try await Anchor.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "앵커를 찾을 수 없습니다.")
        }
        
        if let zoneType = zoneType {
            anchor.zoneType = zoneType
        }
        
        if let zoneName = zoneName {
            anchor.zoneName = zoneName
        }
        
        if let floor = floor {
            anchor.floor = floor
        }

        if let positionX = positionX {
            anchor.positionX = positionX
        }

        if let positionY = positionY {
            anchor.positionY = positionY
        }

        if let positionZ = positionZ {
            anchor.positionZ = positionZ
        }

        try await anchor.save(on: database)
        
        return anchor
    }
    
    // MARK:  - 앵커 삭제
    func deleteAnchort(id: UUID, hospitalId: UUID) async throws {
        guard let anchor = try await Anchor.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "앵커를 찾을 수 없습니다.")
        }
        
        try await anchor.delete(on: database)
    }
}
