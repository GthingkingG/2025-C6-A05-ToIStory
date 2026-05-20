//
//  Font.swift
//  AppleAcademyChallenge6App
//
//  Created by 내꺼다 on 10/26/25.
//

import Foundation
import SwiftUI

extension Font {
    enum Pretend {
        case semibold
        case medium
        case regular
        
        var value: String {
            switch self {
            case .semibold:
                return "PretendardVariable-SemiBold"
            case .medium:
                return "PretendardVariable-Medium"
            case .regular:
                return "PretendardVariable-Regular"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // MARK: - Head
    static var h3: Font {
        return .system(size: 24, weight: .semibold)
    }
    
    static var h4: Font {
        return .pretend(type: .semibold, size: 24)
    }
    
    static var h5: Font {
        return .system(size: 14, weight: .semibold)
    }
    
    // MARK: - Body
    static var b1: Font {
        return .pretend(type: .regular, size: 17)
    }
    
    static var b2: Font {
        return .pretend(type: .regular, size: 24)
    }
    
    static var b3: Font {
        return .pretend(type: .medium, size: 17)
    }
    
    static var b4: Font {
        return .pretend(type: .medium, size: 16)
    }
    
    static var b5: Font {
        return .pretend(type: .medium, size: 18)
    }
    
    static var b6: Font {
        return .system(size: 10, weight: .bold)
    }
    
    static var symbolText01: Font {
        return .system(size: 19, weight: .semibold)
    }
    
    static var symbolText02: Font {
        return .system(size: 15, weight: .medium)
    }
    
    // MARK: - Etc
    static var title01: Font {
        return .pretend(type: .medium, size: 32)
    }
}
