//
//  AuthLoginDTO.swift
//  AppleAcademyChallenge6App
//
//  Created by 내꺼다 on 10/20/25.
//

import Foundation

/// 로그인
struct AuthLoginRequest: Codable {
    let email: String
    let password: String
}
