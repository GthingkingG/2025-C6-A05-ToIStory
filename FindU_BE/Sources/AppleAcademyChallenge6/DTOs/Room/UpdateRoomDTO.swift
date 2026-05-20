//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor

/// 병실 수정 요청 DTO
struct UpdateRoomRequestDTO: Content {
    
    let floor: Int?
    let roomNumber: String?
    let bedCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case floor
        case roomNumber = "room_number"
        case bedCount = "bed_count"
    }
}
