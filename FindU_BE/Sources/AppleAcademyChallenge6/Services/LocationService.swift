//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Vapor
import Fluent

final class LocationService {
    let database: any Database
    let deviceService: DeviceService
    let anchorService: AnchorService
    
    init(
        database: any Database,
        deviceService: DeviceService,
        anchorService: AnchorService
    ) {
        self.database = database
        self.deviceService = deviceService
        self.anchorService = anchorService
    }
    
    // MARK: - FTM 위치 계산
    func calculateLocation(
        serialNumber: String,
        batteryLevel: Int,
        floor: Int,
        measurements: [FTMMeasurementDTO]
    ) async throws -> LocationCalculateResponseDTO {
        guard let device = try await Device.query(on: database)
            .filter(\.$serialNumber == serialNumber)
            .with(\.$patient)
            .with(\.$hospital)
            .first() else {
            throw Abort(.notFound, reason: "기기 시리얼을 찾을 수 없습니다.")
        }
        
        let anchors = try await anchorService.getAnchorsByFloor(floor: floor, hospitalId: device.$hospital.id)
        
        guard !anchors.isEmpty else {
            throw Abort(.notFound, reason: "등록된 앵커를 찾을 수 업습니다.")
        }
        
        var closetAnchor: Anchor?
        var closetDistance: Double = Double.infinity
        
        for measurement in measurements {
            if let anchor = anchors.first(where: { $0.macAddress == measurement.anchorMac}),
               measurement.distanceMeters < closetDistance {
                closetAnchor = anchor
                closetDistance = measurement.distanceMeters
            }
        }
        
        guard let nearestAnchor = closetAnchor else {
            throw Abort(.badRequest, reason: "측정된 앵커를 찾을 수 없습니다.")
        }
        
        let currentZone = CurrentZoneResponseDTO(
            type: nearestAnchor.zoneType,
            name: nearestAnchor.zoneName,
            floor: nearestAnchor.floor
        )
        
        var preciseLocatoin: PreciseLocationDTO?
        if measurements.count >= 3 {
            preciseLocatoin = calculateTrilateration(measurements: measurements, anchors: anchors)
        } else {
            preciseLocatoin = PreciseLocationDTO(
                x: nearestAnchor.positionX,
                y: nearestAnchor.positionY,
                z: nearestAnchor.positionZ
            )
        }
        
        device.currentZoneType = currentZone.type
        device.currentZoneName = currentZone.name
        device.currentFloor = currentZone.floor
        device.batteryLevel = batteryLevel
        device.locationX = preciseLocatoin?.x
        device.locationY = preciseLocatoin?.y
        device.lastLocationUpdate = Date()
        try await device.save(on: database)
        
        let nearbyZones = measurements
            .compactMap { measurement in
                anchors.first(where: { $0.macAddress == measurement.anchorMac }).map {
                    NearbyZoneDTO(
                        zoneName: $0.zoneName,
                        zoneType: $0.zoneType,
                        distance: measurement.distanceMeters
                    )
                }
            }
            .sorted { $0.distance < $1.distance }
            .prefix(5)
        
        return LocationCalculateResponseDTO(
            serialNumber: device.serialNumber,
            batteryLevel: device.batteryLevel,
            currentZone: currentZone,
            assignedWard: device.patient?.ward,
            isInAssignedWard: device.patient?.ward == currentZone.name,
            distanceFromAnchor: closetDistance,
            preciseLocation: preciseLocatoin,
            nearbyZones: Array(nearbyZones),
            timestamp: Date()
        )
    }
    
    private func calculateTrilateration(
        measurements: [FTMMeasurementDTO],
        anchors: [Anchor]
    ) -> PreciseLocationDTO {
        var totalX: Double = 0
        var totalY: Double = 0
        var totalWeight: Double = 0
        
        for measurement in measurements.prefix(3) {
            if let anchor = anchors.first(where: { $0.macAddress == measurement.anchorMac }) {
                let weight = 1.0 / (measurement.distanceMeters + 0.1)
                totalX += anchor.positionX * weight
                totalY += anchor.positionY * weight
                totalWeight += weight
            }
        }
        
        return PreciseLocationDTO(x: totalX / totalWeight, y: totalY / totalWeight, z: nil)
    }
}
