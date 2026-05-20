//
//  Feature.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import Foundation
import MapKit

protocol IMDFDecodableFeature {
  init(feature: MKGeoJSONFeature) throws
}

class Feature<Properties: Decodable>: NSObject, IMDFDecodableFeature {
  let id: UUID
  let properties: Properties
  let geometry: [MKShape & MKGeoJSONObject]

  required init(feature: MKGeoJSONFeature) throws {
    guard let uuid = feature.identifier else {
      throw IMDFError.invalidData
    }

    if let identifier = UUID(uuidString: uuid) {
      id = identifier
    } else {
      throw IMDFError.invalidData
    }

    if let data = feature.properties {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      properties = try decoder.decode(Properties.self, from: data)
    } else {
      throw IMDFError.invalidData
    }

    geometry = feature.geometry

    super.init()
  }
}
