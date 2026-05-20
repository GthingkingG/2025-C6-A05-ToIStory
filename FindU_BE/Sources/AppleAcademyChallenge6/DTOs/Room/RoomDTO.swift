//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/10/25.
//

import Vapor
import Foundation

/// 병실 응답 DTO
struct RoomDTO: Content {
    
    let id: UUID
    let floor: Int
    let roomNumber: String
    let bedCount: Int
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case floor
        case roomNumber = "room_number"
        case bedCount = "bed_count"
        case createdAt = "created_at"
    }
    
    init(from room: Room) {
        self.id = room.id!
        self.floor = room.floor
        self.roomNumber = room.roomNumber
        self.bedCount = room.bedCount
        self.createdAt = room.createdAt
    }
}
