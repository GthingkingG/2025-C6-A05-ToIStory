//
//  RoomListDTO.swift
//  Findew
//
//  Created by 내꺼다 on 11/14/25.
//

import Foundation

struct RoomListResponse: Codable, Identifiable {
    var id: UUID = .init()
    let floors: [Floor]
    
    enum CodingKeys: CodingKey {
        case floors
    }
}

struct Floor: Codable, Identifiable {
    var id: Int { floor }
    let floor: Int
    let rooms: [Room]
}

struct Room: Codable, Identifiable {
    let id: UUID
    let floor: Int
    let roomNumber: String
    let bedCount: Int
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case floor
        case roomNumber = "room_number"
        case bedCount = "bed_count"
        case createdAt = "created_at"
    }
}
