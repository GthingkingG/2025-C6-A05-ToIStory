//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Vapor
import Fluent

struct RoomService: ServiceProtocol {
    var database: any Database
    
    init(database: any Database) {
        self.database = database
    }
    
    // MARK: - 방생성
    func create(
        hospitalId: UUID,
        floor: Int,
        roomNumber: String,
        bedCount: Int,
    ) async throws -> Room {
        let existing = try await Room.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .filter(\.$roomNumber == roomNumber)
            .first()
        
        if existing != nil {
            throw Abort(.conflict, reason: "Room \(roomNumber) 이미 존재합니다.")
        }
        
        let room = Room(
            hospitalId: hospitalId,
            floor: floor,
            roomNumber: roomNumber,
            bedCount: bedCount
        )
        
        try await room.save(on: database)
        
        return room
    }
    
    func bulkCreate(
        hospitalId: UUID,
        floor: Int,
        startRoomNumber: Int,
        endRoomNumber: Int,
        bedCount: Int
    ) async throws -> BulkCreateResult {
        
        guard startRoomNumber <= endRoomNumber else {
            throw Abort(.badRequest, reason: "시작 병실 번호는 끝 병실 번호보다 작거나 같아야 합니다")
        }
        
        var successCount = 0
        var failedRooms: [String] = []
        
        // 각 병실 번호에 대해 생성 시도
        for roomNum in startRoomNumber...endRoomNumber {
            let roomNumber = String(roomNum)
            
            do {
                // 중복 체크
                let existing = try await Room.query(on: database)
                    .filter(\.$hospital.$id == hospitalId)
                    .filter(\.$floor == floor)
                    .filter(\.$roomNumber == roomNumber)
                    .first()
                
                if existing != nil {
                    failedRooms.append("\(floor)층 \(roomNumber)호 (중복)")
                    continue
                }
                
                // 병실 생성
                let room = Room(
                    hospitalId: hospitalId,
                    floor: floor,
                    roomNumber: roomNumber,
                    bedCount: bedCount
                )
                
                try await room.save(on: database)
                successCount += 1
                
            } catch {
                failedRooms.append("\(floor)층 \(roomNumber)호 (오류)")
            }
        }
        
        return BulkCreateResult(
            totalCount: endRoomNumber - startRoomNumber + 1,
            successCount: successCount,
            failedCount: failedRooms.count,
            failedRooms: failedRooms
        )
    }
    
    // MARK: - Update
    func update(
        id: UUID,
        hospitalId: UUID,
        floor: Int?,
        roomNumber: String?,
        bedCount: Int?
    ) async throws -> Room {
        
        // 1. 병실 조회
        guard let room = try await Room.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "병실을 찾을 수 없습니다")
        }
        
        // 2. 층/병실 번호 변경 시 중복 체크
        let newFloor = floor ?? room.floor
        let newRoomNumber = roomNumber ?? room.roomNumber
        
        if floor != nil || roomNumber != nil {
            let existing = try await Room.query(on: database)
                .filter(\.$hospital.$id == hospitalId)
                .filter(\.$floor == newFloor)
                .filter(\.$roomNumber == newRoomNumber)
                .filter(\.$id != id)
                .first()
            
            if existing != nil {
                throw Abort(.conflict, reason: "이미 존재하는 병실입니다 (\(newFloor)층 \(newRoomNumber)호)")
            }
        }
        
        // 3. 수정
        if let floor = floor {
            room.floor = floor
        }
        
        if let roomNumber = roomNumber {
            room.roomNumber = roomNumber
        }
        
        if let bedCount = bedCount {
            room.bedCount = bedCount
        }
        
        try await room.save(on: database)
        
        return room
    }
    
    
    // MARK: - Read
    func list(hospitalId: UUID) async throws -> [Room] {
        try await Room.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .sort(\.$floor, .ascending)
            .sort(\.$roomNumber, .ascending)
            .all()
    }
    
    func listByFloor(hospitalId: UUID, floor: Int) async throws -> [Room] {
        try await Room.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .filter(\.$floor == floor)
            .sort(\.$roomNumber, .ascending)
            .all()
    }
    
    func get(id: UUID, hospitalId: UUID) async throws -> Room {
        guard let room = try await Room.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "병실을 찾을 수 없습니다.")
        }
        
        return room
    }
    
    // MARK: - Delete
    func delete(id: UUID, hospitalId: UUID) async throws {
        guard let room = try await Room.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "병실을 찾을 수 없습니다.")
        }
        
        try await room.delete(on: database)
    }
    
    func deleteAll(hospitalId: UUID) async throws {
        try await Room.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .delete()
    }
    
}
