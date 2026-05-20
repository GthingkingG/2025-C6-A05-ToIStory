//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/14/25.
//

import Vapor

/// 전체 환자 조회 시 사용하는 응답 DTO
struct PatientAllQuery: Content {
    let floor: Int?
    let ward: Int?
}
