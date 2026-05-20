//
//  MapPolygonView.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import SwiftUI
import MapKit

struct MapPolygonView: MapContent {
    let overlay: OverlayData

    var body: some MapContent {
        if let circle = overlay.shape as? MKCircle {
            MapCircle(center: circle.coordinate, radius: circle.radius)
                .foregroundStyle(overlay.fillColor)
                .stroke(overlay.strokeColor, lineWidth: overlay.lineWidth)
        } else if let polygon = overlay.shape as? MKPolygon {
            MapPolygon(polygon)
                .foregroundStyle(overlay.fillColor)
                .stroke(overlay.strokeColor, lineWidth: overlay.lineWidth)
        } else if let multiPolygon = overlay.shape as? MKMultiPolygon {
            ForEach(Array(multiPolygon.polygons.enumerated()), id: \.offset) { _, polygon in
                MapPolygon(polygon)
                    .foregroundStyle(overlay.fillColor)
                    .stroke(overlay.strokeColor, lineWidth: overlay.lineWidth)
            }
        } else if let polyline = overlay.shape as? MKPolyline {
            MapPolyline(polyline)
                .stroke(overlay.strokeColor, lineWidth: overlay.lineWidth)
        } else if let multiPolyline = overlay.shape as? MKMultiPolyline {
            ForEach(Array(multiPolyline.polylines.enumerated()), id: \.offset) { _, polyline in
                MapPolyline(polyline)
                    .stroke(overlay.strokeColor, lineWidth: overlay.lineWidth)
            }
        }
    }
}

extension MKMapRect {
    var center: CLLocationCoordinate2D {
        let centerPoint = MKMapPoint(x: midX, y: midY)
        return centerPoint.coordinate
    }
}
