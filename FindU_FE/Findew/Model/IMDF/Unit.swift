//
//  Unit.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import MapKit
import UIKit

class Unit: Feature<Unit.Properties> {
  struct Properties: Codable {
    let category: String
    let levelId: UUID
  }
}

extension Unit: StylableFeature {
  private enum StylableCategory: String {
    case elevator
    case escalator
    case stairs
    case restroom
    case restroomMale = "restroom.male"
    case restroomFemale = "restroom.female"
    case room
    case nonpublic
    case walkway
  }

  func configure(overlayRenderer: MKOverlayPathRenderer) {
    if let category = StylableCategory(rawValue: properties.category) {
      switch category {
      case .elevator, .escalator, .stairs:
        overlayRenderer.fillColor = UIColor(named: "ElevatorFill")
      case .restroom, .restroomMale, .restroomFemale:
        overlayRenderer.fillColor = UIColor(named: "RestroomFill")
      case .room:
        overlayRenderer.fillColor = UIColor(named: "RoomFill")
      case .nonpublic:
        overlayRenderer.fillColor = UIColor(named: "NonPublicFill")
      case .walkway:
        overlayRenderer.fillColor = UIColor(named: "WalkwayFill")
      }
    } else {
      overlayRenderer.fillColor = UIColor(named: "DefaultUnitFill")
    }

    overlayRenderer.strokeColor = UIColor(named: "UnitStroke")
    overlayRenderer.lineWidth = 1.3
  }
}

