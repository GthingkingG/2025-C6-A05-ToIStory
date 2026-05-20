//
//  OverlayData.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import Foundation
import MapKit
import SwiftUI

struct OverlayData: Identifiable {
    let id: UUID = .init()
    let shape: MKShape & MKOverlay
    let fillColor: Color
    let strokeColor: Color
    let lineWidth: CGFloat
}

extension OverlayData: Hashable {
    static func  == (lhs: OverlayData, rhs: OverlayData) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
