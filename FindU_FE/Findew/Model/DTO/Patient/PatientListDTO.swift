//
//  PatientListDTO.swift
//  AppleAcademyChallenge6App
//
//  Created by 내꺼다 on 10/21/25.
//

import Foundation

/// 환자 전체 조회
struct PatientListQuery: Codable {
    let floor: Int?
    let ward: String?
}
