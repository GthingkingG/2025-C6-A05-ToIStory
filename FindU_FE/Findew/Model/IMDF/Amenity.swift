//
//  Amenity.swift
//  Findew
//
//  Created by Apple Coding machine on 11/24/25.
//

import MapKit
import UIKit

class Amenity: Feature<Amenity.Properties> {
  struct Properties: Codable {
    let category: String
    let accessibility: String?
    let name: LocalizedName?
    let altName: LocalizedName?
    let hours: String?
    let phone: String?
    let website: String?
    let unitIds: [UUID]?
    let addressId: UUID?
    let correlationId: UUID?
    let levelId: UUID?
  }
}

extension Amenity: StylableFeature {
  private enum StylableCategory: String {
    case elevator
    case escalator
    case stairs
    case restroom
    case restroomMale = "restroom.male"
    case restroomFemale = "restroom.female"
    case restroomUnisexWheelchair = "restroom.unisex.wheelchair"
    case phone
    case atm
    case vendingMachine = "vending.machine"
    case parking
    case information
  }

  func configure(overlayRenderer: MKOverlayPathRenderer) {
    if let category = StylableCategory(rawValue: properties.category) {
      switch category {
      case .elevator, .escalator, .stairs:
        overlayRenderer.fillColor = UIColor(named: "ElevatorFill")?.withAlphaComponent(0.8)
        overlayRenderer.strokeColor = UIColor(named: "UnitStroke")
      case .restroom, .restroomMale, .restroomFemale, .restroomUnisexWheelchair:
        overlayRenderer.fillColor = UIColor(named: "RestroomFill")?.withAlphaComponent(0.8)
        overlayRenderer.strokeColor = UIColor(named: "UnitStroke")
      case .phone:
        overlayRenderer.fillColor = UIColor.systemBlue.withAlphaComponent(0.6)
        overlayRenderer.strokeColor = UIColor.systemBlue
      case .atm, .vendingMachine:
        overlayRenderer.fillColor = UIColor.systemGreen.withAlphaComponent(0.6)
        overlayRenderer.strokeColor = UIColor.systemGreen
      case .parking:
        overlayRenderer.fillColor = UIColor.systemPurple.withAlphaComponent(0.6)
        overlayRenderer.strokeColor = UIColor.systemPurple
      case .information:
        overlayRenderer.fillColor = UIColor.systemOrange.withAlphaComponent(0.6)
        overlayRenderer.strokeColor = UIColor.systemOrange
      }
    } else {
      overlayRenderer.fillColor = UIColor.systemGray.withAlphaComponent(0.5)
      overlayRenderer.strokeColor = UIColor.systemGray
    }

    overlayRenderer.lineWidth = 2.0
  }
}
