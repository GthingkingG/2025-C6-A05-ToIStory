//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Foundation
import Vapor

/// 층별로 그룹화된 병실 목록 DTO
struct RoomsGroupedByFloorDTO: Content {
    
    let floors: [FloorRoomsDTO]
    
    init(rooms: [Room]) {
        // 층별로 그룹화
        let grouped = Dictionary(grouping: rooms, by: { $0.floor })
        
        // 층 오름차순 정렬
        self.floors = grouped.keys.sorted().map { floor in
            let roomsInFloor = grouped[floor]!.map { RoomDTO(from: $0) }
            return FloorRoomsDTO(floor: floor, rooms: roomsInFloor)
        }
    }
}

/// 층별 병실 DTO
struct FloorRoomsDTO: Content {
    let floor: Int
    let rooms: [RoomDTO]
}
