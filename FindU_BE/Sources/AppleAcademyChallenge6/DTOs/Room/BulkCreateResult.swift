//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor

/// 일괄 생성 결과
struct BulkCreateResult: Content {
    let totalCount: Int      // 시도한 총 개수
    let successCount: Int    // 성공한 개수
    let failedCount: Int     // 실패한 개수
    let failedRooms: [String] // 실패한 병실 목록
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case successCount = "success_count"
        case failedCount = "failed_count"
        case failedRooms = "failed_rooms"
    }
}
