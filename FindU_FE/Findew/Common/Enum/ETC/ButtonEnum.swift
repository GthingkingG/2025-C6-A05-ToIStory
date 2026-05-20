//
//  ButtonEnum.swift
//  Findew
//
//  Created by 진아현 on 10/29/25.
//

import SwiftUI

// 버튼 Enum
enum ButtonEnum {
    case refresh
    case search
    case side
    case plus
    case check
    case before
    case cancel
    case select
    case report
    case close
    case send
    
    var buttonColor: Color? {
        switch self {
        case .refresh:
            return .blue04
        default:
            return nil
        }
    }
    
    var buttonContent: String {
        switch self {
        case .refresh:
            return "arrow.clockwise"
        case .search:
            return "magnifyingglass"
        case .side:
            return "sidebar.left"
        case .plus:
            return "plus"
        case .check:
            return "checkmark"
        case .before:
            return "chevron.left"
        case .cancel:
            return "xmark"
        case .select:
            return "선택"
        case .report:
            return "기기신고"
        case .close:
            return "취소"
        case .send:
            return "보내기"
        }
    }
    
    var buttonFont: Font {
        return .symbolText01
    }
    
    var buttonFontColor: Color {
        return .gray08
    }
}
