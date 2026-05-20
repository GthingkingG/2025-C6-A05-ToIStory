//
//  Level.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import MapKit
import UIKit

class Level: Feature<Level.Properties> {
  struct Properties: Codable {
    let ordinal: Int
    let category: String
    let shortName: LocalizedName
    let outdoor: Bool
    let buildingIds: [String]?
  }

  var units: [Unit] = []
  var amenities: [Amenity] = []
}

extension Level: StylableFeature {
  func configure(overlayRenderer: MKOverlayPathRenderer) {
    overlayRenderer.fillColor = UIColor(named: "LevelFill") ?? UIColor.systemGray6
    overlayRenderer.strokeColor = UIColor(named: "LevelStroke")
    overlayRenderer.lineWidth = 2.0
  }
}
