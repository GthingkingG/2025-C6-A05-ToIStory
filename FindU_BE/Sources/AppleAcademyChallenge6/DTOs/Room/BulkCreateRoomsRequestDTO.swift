//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/10/25.
//

import Vapor

/// 병실 일괄 생성 요청 DTO
struct BulkCreateRoomsRequestDTO: Content, Validatable {
    
    let floor: Int
    let startRoomNumber: Int
    let endRoomNumber: Int
    let bedCount: Int
    let roomType: String?
    
    enum CodingKeys: String, CodingKey {
        case floor
        case startRoomNumber = "start_room_number"
        case endRoomNumber = "end_room_number"
        case bedCount = "bed_count"
        case roomType = "room_type"
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add("floor", as: Int.self, is: .range(1...100))
        validations.add("start_room_number", as: Int.self, is: .range(1...9999))
        validations.add("end_room_number", as: Int.self, is: .range(1...9999))
        validations.add("bed_count", as: Int.self, is: .range(1...10))
    }
    
    func validate() throws {
        if startRoomNumber > endRoomNumber {
            throw Abort(.badRequest, reason: "시작 병실 번호는 끝 병실 번호보다 작거나 같아야 합니다")
        }
    }
}
