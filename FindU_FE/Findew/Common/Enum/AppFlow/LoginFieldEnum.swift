//
//  LoginFieldType.swift
//  Findew
//
//  Created by 진아현 on 10/30/25.
//

import Foundation
import SwiftUI

// 로그인 구역 Enum
enum LoginFieldEnum: Hashable {
    case id
    case password
    
    var placeholder: String {
        switch self {
        case .id:
            return "아이디를 입력해주세요"
        case .password:
            return "비밀번호를 입력해주세요"
        }
    }
    
    var loginFieldStrokeColor: Color {
        return .gray02
    }
    
    var loginFieldStrokeWidth: CGFloat {
        return 2
    }
    
    var loginFieldFont: Font {
        return .b3
    }
    
    var loginFieldFontColor: Color {
        return .black
    }
    
    var placeholderColor: Color {
        return .gray03
    }
    
    func eyeBtnImage(showPassword: Bool) -> Image? {
        switch self {
        case .id:
            return nil
        case .password:
            return showPassword ? Image(systemName: "eye.fill") : Image(systemName: "eye.slash")
        }
    }
    
    var keyboardStyle: UIKeyboardType {
        switch self {
        case .id:
            return .emailAddress
        case .password:
            return .default
        }
    }
}
