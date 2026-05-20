//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Fluent
import Vapor

final class DeviceService: ServiceProtocol {
    var database: any Database
    
    init(database: any Database) {
        self.database = database
    }
    
    // MARK: - 기기 전체 조회
    func getAllDevices(hospitalId: UUID) async throws -> [Device] {
        try await Device.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .with(\.$hospital)
            .with(\.$patient)
            .sort(\.$createdAt, .descending)
            .all()
    }
    
    // MARK: - 미배정 기기 조회
    func getUnassigneDevices(hospitalId: UUID) async throws -> [Device] {
        let useDeviceIds = try await Patient.query(on: database)
            .filter(\.$device.$id != nil)
            .all()
            .compactMap { $0.$device.id }

        return try await Device.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .filter(\.$id !~ useDeviceIds)
            .with(\.$hospital)
            .with(\.$patient)
            .all()
    }
    
    // MARK: - 기기 검색
    func searchDevice(serialNumber: String, hospitalId: UUID) async throws -> Device? {
        try await Device.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .filter(\.$serialNumber == serialNumber)
            .with(\.$patient)
            .first()
    }
    
    // MARK: - 기기 생성
    func creatreDevice(
        hospitalId: UUID,
        serialNumber: String
    ) async throws -> Device {
        if let _ = try await Device.query(on: database)
            .filter(\.$serialNumber == serialNumber)
            .first() {
            throw Abort(.conflict, reason: "디바이스 이미 존재합니다.")
        }

        let device = Device(
            hospitalId: hospitalId,
            serialNumber: serialNumber
        )

        try await device.save(on: database)

        // Reload with relationships
        guard let savedDevice = try await Device.query(on: database)
            .filter(\.$id == device.id!)
            .with(\.$hospital)
            .with(\.$patient)
            .first() else {
            throw Abort(.internalServerError, reason: "디바이스 저장 후 조회 실패")
        }

        return savedDevice
    }
    
    // MARK: - 기기 수정
    func updateDevice(
        id: UUID,
        hospitalId: UUID,
        serialNumber: String?
    ) async throws -> Device {
        guard let device = try await Device.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .with(\.$hospital)
            .with(\.$patient)
            .first() else {
            throw Abort(.notFound, reason: "디바이스 찾을 수 없습니다.")
        }

        if let serialNumber = serialNumber {
            device.serialNumber = serialNumber
        }

        try await device.save(on: database)

        return device
    }
    
    // MARK: - 기기 삭제
    func deleteDevice(serialNumber: String, hospitalId: UUID) async throws {
        guard let device = try await Device.query(on: database)
            .filter(\.$serialNumber == serialNumber)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "디바이스 찾을 수 없습니다.")
        }
        
        try await device.$patient.load(on: database)
        
        if device.patient != nil {
            throw Abort(.conflict, reason: "환자에게 배정된 기기는 삭제할 수 없습닏")
        }
        
        try await device.delete(on: database)
    }
    
    // MARK: - 기기 고장 신고
    func reportMalfunctions(
        serialNumbers: [String],
        hospitalId: UUID
    ) async throws -> BulkMalfunctionResult {
        
        var successCount = 0
        var failedDevices: [String] = []
        
        for serialNumber in serialNumbers {
            do {
                guard let device = try await Device.query(on: database)
                    .filter(\.$serialNumber == serialNumber)
                    .filter(\.$hospital.$id == hospitalId)
                    .first() else {
                    failedDevices.append("\(serialNumber) (없음)")
                    continue
                }
                
                device.isMalfunctioning = true
                try await device.save(on: database)
                successCount += 1
                
            } catch {
                failedDevices.append("\(serialNumber) (오류)")
            }
        }
        
        return BulkMalfunctionResult(
            totalCount: serialNumbers.count,
            successCount: successCount,
            failedCount: failedDevices.count,
            failedDevices: failedDevices
        )
    }
    
}
