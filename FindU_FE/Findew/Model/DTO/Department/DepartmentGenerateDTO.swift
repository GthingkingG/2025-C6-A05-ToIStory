//
//  DepartmentGenerateDTO.swift
//  AppleAcademyChallenge6App
//
//  Created by 내꺼다 on 10/20/25.
//

import Foundation

/// 소속과 생성
struct DepartmentGenerateRequest: Codable {
    let name: String
    let code: String
    let description: String?
}
