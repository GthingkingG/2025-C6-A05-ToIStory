//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

/// 진료과 간단 조회 DTO
struct SimpleDepartmentDTO: Content {
    let id: UUID
    let name: String
    let code: String
    
    init(id: UUID, name: String, code: String) {
        self.id = id
        self.name = name
        self.code = code
    }
    
    init(from department: Department) {
        self.id = department.id!
        self.name = department.name
        self.code = department.code
    }
}
