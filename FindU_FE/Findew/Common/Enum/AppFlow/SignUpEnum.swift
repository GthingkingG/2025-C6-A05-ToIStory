//
//  SignUp.swift
//  Findew
//
//  Created by Apple Coding machine on 11/20/25.
//

import Foundation
import SwiftUI

enum SignUpData: String, CaseIterable, Hashable {
    case id
    case password
    case name
    
    var text: String {
        switch self {
        case .id:
            return "아이디"
        case .password:
            return "비밀번호"
        case .name:
            return "이름"
        }
    }
    
    var placeholder: String {
        switch self {
        case .id:
            return "ex) example123@example.com"
        case .password:
            return "최소 8자리의 영문, 숫자, 특수문자를 포함한 비밀번호를 입력해주세요"
        case .name:
            return "이름을 입력해주세요"
        }
    }
    
    var signUpFont: Font {
        return .b3
    }
    
    var signUpFontColor: Color {
        return .black
    }
    
    var signUpPlaceColor: Color {
        return .gray03
    }
    
    var keyboardStyle: UIKeyboardType {
        switch self {
        case .id:
            return .emailAddress
        case .password:
            return .default
        case .name:
            return .default
        }
    }
    
    var isSecure: Bool {
        return self == .password
    }
}
