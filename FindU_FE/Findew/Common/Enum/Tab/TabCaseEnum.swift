//
//  TabCase.swift
//  Findew
//
//  Created by 진아현 on 10/30/25.
//

import Foundation
import SwiftUI

// 탭바 Enum
enum TabCaseEnum: String, CaseIterable {
    case location = "환자 목록"
    case device = "기기 목록"
    
    var tabTitle: String { rawValue }
    
    var icon: String {
        switch self {
        case .location:
            return "tablecells"
        case .device:
            return "rectangle.grid.3x3"
        }
    }
}
