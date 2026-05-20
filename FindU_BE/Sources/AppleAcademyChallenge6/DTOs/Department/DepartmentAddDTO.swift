//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/14/25.
//

import Vapor

/// 진료과 생성 Request
struct DepartmentAddRequest: Content {
    let name: String
    let code: String
    let description: String?
}

