//
//  DepartmentUpdateDTO.swift
//  Findew
//
//  Created by 내꺼다 on 10/28/25.
//

import Foundation

/// 소속과 수정
struct DepartmentUpdatePath: Codable {
    let id: UUID
}

struct DepartmentUpdateRequest: Codable {
    let name: String?
    let code: String?
    let description: String?
}
