//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/28/25.
//

import Vapor

/// 진료과 수정 DTO
struct DepartmentUpdateRequest: Content {
    let name: String?
    let code: String?
    let description: String?
}
