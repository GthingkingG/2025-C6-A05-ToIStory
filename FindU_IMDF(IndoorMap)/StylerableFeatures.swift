//
//  StylerableFeatures.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import Foundation
import MapKit

protocol StylableFeature {
  var geometry: [MKShape & MKGeoJSONObject] { get }
  func configure(overlayRenderer: MKOverlayPathRenderer)
  func configure(annotationView: MKAnnotationView)
}

extension StylableFeature {
  func configure(overlayRenderer: MKOverlayPathRenderer) {}
  func configure(annotationView: MKAnnotationView) {}
}
