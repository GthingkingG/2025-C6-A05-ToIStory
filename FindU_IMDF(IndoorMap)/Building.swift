//
//  Building.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import Foundation
import MapKit

class Building: Feature<Building.Properties> {
  struct DisplayPoint: Codable {
    let coordinates: [Double]
    let type: String

    var coordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(latitude: coordinates[1], longitude: coordinates[0])
    }
  }

  struct Properties: Codable {
    let category: String
    let name: LocalizedName?
    let altName: LocalizedName?
    let displayPoint: DisplayPoint
    let addressId: String?
    let restriction: String?
  }
}
