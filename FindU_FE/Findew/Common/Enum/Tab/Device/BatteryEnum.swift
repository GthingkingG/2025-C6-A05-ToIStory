//
//  BatteryEnum.swift
//  Findew
//
//  Created by 진아현 on 10/30/25.
//

import Foundation
import SwiftUI

// 배터리 아이콘 Enum
enum BatteryEnum {
    case lowBattery
    case middleBattery
    case highBattery
    
    var iconFont: Font {
        return .b4
    }
    
    var iconStrokeFontColor: Color {
        return .gray06
    }
    
    var iconStrokeWeight: CGFloat {
        return 3
    }
    
    var iconStrokeBigRoundness: CGFloat {
        return 10
    }
    
    var iconStrokeSmallRoundness: CGFloat {
        return 4
    }
    
    var iconBatteryRoundness: CGFloat {
        return 6
    }
    
    var iconSize: CGSize {
        return CGSize(width: 88, height: 43)
    }
    
    var iconSmallSize: CGSize {
        return CGSize(width: 9, height: 19)
    }
    
    var batteryHeight: CGFloat {
        return 33
    }
    
    var iconBatteryColor: Color {
        switch self {
        case .lowBattery:
            return .low
        case .middleBattery:
            return .middle
        case .highBattery:
            return .high
        }
    }
}
