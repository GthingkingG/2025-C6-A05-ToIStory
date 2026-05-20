//
//  TableTitleEnum.swift
//  Findew
//
//  Created by 진아현 on 10/30/25.
//

import Foundation
import SwiftUI

enum PatientColumn: Int, CaseIterable, Identifiable {
    case name = 0
    case wardBed = 1
    case department = 2
    case location = 3
    case memo = 4
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .name: return "이름"
        case .wardBed: return "병동 번호"
        case .department: return "소속 과"
        case .location: return "현 위치"
        case .memo: return "기타"
        }
    }
    
    var width: CGFloat {
        [160, 169, 174, 321, 371][rawValue]
    }
    
    var useMaxWidth: Bool {
        switch self {
        case .name, .wardBed, .department: return true
        case .location, .memo: return false
        }
    }
    
    var keyPath: PartialKeyPath<PatientDTO> {
        switch self {
        case .name:
            return \.name
        case .wardBed:
            return \.wardBedNumber
        case .department:
            return \.department.name
        case .location:
            return \.device?.currentZone
        case .memo:
            return \.memo
        }
    }
}
