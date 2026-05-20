//
//  IndoorMapViewModel.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import SwiftUI
import MapKit
import Combine

@Observable
class IndoorMapViewModel {
    var venue: Venue?
    var currentLevelOverlays: [OverlayData] = .init()
    var availableLevels: [Int] = .init()
    
    private var decoder: IMDFDecoder = .init()
    private var currentLevelFeature: [StylableFeature] = .init()
    
    func loadIndoorData(floor: Int) {
        guard let imdfDirectory = Bundle.main.url(forResource: "IMDF", withExtension: nil) else {
            print("Error: 프로젝트 내에서 IMDF 폴더를 찾을 수 없습니다.")
            return
        }
        
        do {
            venue = try decoder.decode(imdfDirectory)
            
            if let venue = venue {
                availableLevels = Array(venue.levelsByOrdinal.keys).sorted()
            }
            
            showFeature(floor)
        } catch let error {
            print(error)
        }
    }
    
    private func showFeature(_ ordinal: Int) {
        guard venue != nil else { return }
        
        // Clear previous data
        currentLevelFeature.removeAll()
        currentLevelOverlays.removeAll()
        
        // Get features for the specified ordinal level
        if let levels = venue?.levelsByOrdinal[ordinal] {
            for level in levels {
                currentLevelFeature.append(level)
                currentLevelFeature += level.units
                currentLevelFeature += level.amenities
            }
        }
        
        // Create overlay data for each feature
        for feature in currentLevelFeature {
            for geometry in feature.geometry {
                let overlay: MKOverlay

                // Handle Point geometry by converting to MKCircle
                if let point = geometry as? MKPointAnnotation {
                    overlay = MKCircle(center: point.coordinate, radius: 1.5)
                } else if let existingOverlay = geometry as? MKOverlay {
                    overlay = existingOverlay
                } else {
                    continue
                }

                let overlayData = createOverlayData(for: feature, overlay: overlay)
                currentLevelOverlays.append(overlayData)
            }
        }
        
        Logger.logDebug("IMDF", "Loaded \(currentLevelOverlays.count) overlays for level ordinal \(ordinal)")
    }
    
    private func createOverlayData(for feature: StylableFeature, overlay: MKOverlay) -> OverlayData {
        let renderer: MKOverlayPathRenderer

        switch overlay {
        case is MKCircle:
            renderer = MKCircleRenderer(overlay: overlay)
        case is MKMultiPolygon:
            renderer = MKMultiPolygonRenderer(overlay: overlay)
        case is MKPolygon:
            renderer = MKPolygonRenderer(overlay: overlay)
        case is MKMultiPolyline:
            renderer = MKMultiPolylineRenderer(overlay: overlay)
        case is MKPolyline:
            renderer = MKPolylineRenderer(overlay: overlay)
        default:
            renderer = MKOverlayPathRenderer(overlay: overlay)
        }
        
        feature.configure(overlayRenderer: renderer)
        
        return OverlayData(
            shape: overlay as! (MKShape & MKOverlay),
            fillColor: Color(uiColor: renderer.fillColor ?? .clear),
            strokeColor: Color(uiColor: renderer.strokeColor ?? .black),
            lineWidth: renderer.lineWidth
        )
    }
}
