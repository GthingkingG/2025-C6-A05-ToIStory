//
//  IndoorMap.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import SwiftUI
import MapKit

struct IndoorMapView: View,Equatable {
    @State var viewModel: IndoorMapViewModel = .init()
    @State var cameraPosition: MapCameraPosition = .automatic
    let floor: Int
    
    // MARK: - Equtable
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.floor == rhs.floor
    }
    
    // MARK: - Init
    init(floor: Int) {
        self.floor = floor
    }
    
    var body: some View {
        mapView
    }
    private var mapView: some View {
        Map(position: $cameraPosition) {
            ForEach(viewModel.currentLevelOverlays, id: \.id) { overlay in
                MapPolygonView(overlay: overlay)
            }
            
            UserAnnotation()
        }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .task {
            viewModel.loadIndoorData(floor: floor)
        }
    }
    
    private func setupIntialCamera() {
        if let building = viewModel.venue?.buildings.first {
            let coordinate = building.properties.displayPoint.coordinate
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.0006,
                    longitudeDelta: 0.0006
                )
            )
            cameraPosition = .region(region)
        } else if let venueOverlay = viewModel.venue?.geometry.first as? MKOverlay {
            let region = MKCoordinateRegion(
                center: venueOverlay.boundingMapRect.center,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.0001,
                    longitudeDelta: 0.0001
                )
            )
            cameraPosition = .region(region)
        }
    }
}
