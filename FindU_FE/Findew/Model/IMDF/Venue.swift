//
//  Venue.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import Foundation

class Venue: Feature<Venue.Properties> {
  struct Properties: Codable {
    let category: String
  }

  var levelsByOrdinal: [Int: [Level]] = [:]
  var buildings: [Building] = []
}
