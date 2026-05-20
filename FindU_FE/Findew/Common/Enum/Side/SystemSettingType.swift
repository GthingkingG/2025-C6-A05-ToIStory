//
//  SystemSetting.swift
//  Findew
//
//  Created by Apple Coding machine on 11/5/25.
//

import SwiftUI

enum SystemSettingType: String, CaseIterable {
    case withdraw = "회원탈퇴"
    case logout = "로그아웃"
    case inquiry = "문의하기 및 신고하기"

    var isDestructive: Bool {
        switch self {
        case .logout, .withdraw:
            return true
        default:
            return false
        }
    }
    
    var title: String { rawValue }
    
    var color: Color {
        switch self {
        case .logout, .withdraw:
            return .red
        default:
            return .black
        }
    }
    
    var role: ButtonRole? {
        switch self {
        case .logout, .withdraw:
            return .destructive
        default:
            return .none
        }
    }
}
