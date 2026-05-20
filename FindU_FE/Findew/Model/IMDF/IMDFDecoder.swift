//
//  IMDFDecoder.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import Foundation
import MapKit

class IMDFDecoder {
  private let geoJSONDecoder = MKGeoJSONDecoder()
  func decode(_ imdfDirectory: URL) throws -> Venue {
    let archive = Archive(directory: imdfDirectory)

    let venues = try decodeFeatures(Venue.self, from: .venue, in: archive)
    let buildings = try decodeFeatures(Building.self, from: .building, in: archive)
    let levels = try decodeFeatures(Level.self, from: .level, in: archive)
    let units = try decodeFeatures(Unit.self, from: .unit, in: archive)
    let amenities = try decodeFeatures(Amenity.self, from: .amenity, in: archive)

    if venues.isEmpty {
      throw IMDFError.invalidData
    }
    let venue = venues[0]
    venue.buildings = buildings
    venue.levelsByOrdinal = Dictionary(grouping: levels) { level in
      level.properties.ordinal
    }

    // Associate Units and Amenities to levels.
    let unitsByLevel = Dictionary(grouping: units) { unit in
      unit.properties.levelId
    }

    let amenitiesByLevel = Dictionary(grouping: amenities) { amenity in
      amenity.properties.levelId
    }

    // Create a map of unit ID to level for amenities that don't have level_id
    let unitIdToLevel = Dictionary(uniqueKeysWithValues: units.map { ($0.id, $0.properties.levelId) })

    // Associate each Level with its corresponding Units and Amenities.
    for level in levels {
      if let unitsInLevel = unitsByLevel[level.id] {
        level.units = unitsInLevel
      }
      if let amenitiesInLevel = amenitiesByLevel[level.id] {
        level.amenities = amenitiesInLevel
      }
    }

    // Associate Amenities without level_id to levels via their unit_ids
    for amenity in amenities where amenity.properties.levelId == nil {
      if let unitIds = amenity.properties.unitIds, let firstUnitId = unitIds.first,
         let levelId = unitIdToLevel[firstUnitId] {
        if let level = levels.first(where: { $0.id == levelId }) {
          level.amenities.append(amenity)
        }
      }
    }

    // Associate Amenities to the Unit in which they reside.
    _ = units.reduce(into: [UUID: Unit]()) {
      $0[$1.id] = $1
    }

    return venue
  }


  private func decodeFeatures<T: IMDFDecodableFeature>(_ type: T.Type, from file: Archive.File, in archive: Archive) throws -> [T] {
    let fileURL = archive.fileURL(for: file)
    let data = try Data(contentsOf: fileURL)
    let geoJSONFeatures = try geoJSONDecoder.decode(data)
    guard let features = geoJSONFeatures as? [MKGeoJSONFeature] else {
      throw IMDFError.invalidType
    }

    let imdfFeatures = try features.map { try type.init(feature: $0) }
    return imdfFeatures
  }
}

