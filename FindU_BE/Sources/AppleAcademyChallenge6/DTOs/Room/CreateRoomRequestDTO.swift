//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/10/25.
//

import Vapor

/// 병실 생성 요청 DTO
struct CreateRoomRequestDTO: Content, Validatable {
    let floor: Int
    let roomNumber: String
    let bedCount: Int
    
    enum CodingKeys: String, CodingKey {
        case floor
        case roomNumber = "room_number"
        case bedCount = "bed_count"
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add("floor", as: Int.self, is: .range(1...100))
        validations.add("room_number", as: String.self, is: !.empty && .count(...10))
        validations.add("bed_count", as: Int.self, is: .range(1...10))
    }
}
