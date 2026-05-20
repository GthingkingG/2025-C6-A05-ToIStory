//
//  Archive.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import Foundation

struct Archive {
  let directory: URL?

  init(directory: URL?) {
    self.directory = directory
  }

  enum File {
    case address
    case amenity
    case anchor
    case building
    case detail
    case fixture
    case footprint
    case geofence
    case kiosk
    case level
    case manifest
    case occupant
    case opening
    case relationship
    case section
    case unit
    case venue

    var filename: String {
      return "\(self).geojson"
    }
  }

  func fileURL(for file: File) -> URL {
    // If directory exists, use it (folder reference approach)
    if let directory = directory {
      return directory.appendingPathComponent(file.filename)
    }

    // Otherwise, try to find the file directly in the bundle (individual files approach)
    if let bundleURL = Bundle.main.url(forResource: file.filename, withExtension: nil) {
      return bundleURL
    }

    // Fallback: construct a path that will fail gracefully
    return URL(fileURLWithPath: "/nonexistent/\(file.filename)")
  }
}
