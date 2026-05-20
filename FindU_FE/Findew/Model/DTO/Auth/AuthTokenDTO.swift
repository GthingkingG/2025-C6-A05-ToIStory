//
//  AuthLogOutDTO.swift
//  Findew
//
//  Created by 내꺼다 on 11/14/25.
//

import Foundation

/// 로그아웃, refresh
struct AuthTokenRequest: Codable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
