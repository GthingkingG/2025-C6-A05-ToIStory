//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Vapor
import Fluent

final class PatientService {
    
    var database: any Database
    let deviceService: DeviceService
    
    init(database: any Database, deviceService: DeviceService) {
        self.database = database
        self.deviceService = deviceService
    }
    
    // MARK: - 환자 전체 조회
    func getAllPatients(hospitalId: UUID) async throws -> [Patient] {
        try await Patient.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .with(\.$device)
            .with(\.$department)
            .all()
    }
    
    // MARK: - 병동별 환자 조회
    func getPatientsByWard(ward: String, hospitalId: UUID) async throws -> [Patient] {
        try await Patient.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .filter(\.$ward == ward)
            .with(\.$device)
            .with(\.$department)
            .all()
    }
    
    // MARK: - 환자 상세 조회
    func getPatient(id: UUID, hospitalId: UUID) async throws -> Patient {
        guard let patient = try await Patient.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .with(\.$device)
            .with(\.$department)
            .first() else {
            throw Abort(.notFound, reason: "환자 찾을 수 없습니다.")
        }
        
        return patient
    }
    
    // MARK: - 환자 등록
    func createPatient(
        hospitalId: UUID,
        name: String,
        ward: String,
        bed: Int,
        departmentId: UUID,
        deviceSerial: String?,
        memo: String?
    ) async throws -> Patient {
        var deviceId: UUID? = nil
        if let deviceSerial = deviceSerial {
            guard let device = try await deviceService.searchDevice(serialNumber: deviceSerial, hospitalId: hospitalId) else {
                throw Abort(.notFound, reason: "Device 찾을 수 없습니다.")
            }
            deviceId = device.id
        }
        
        let patient = Patient(
            hospitalId: hospitalId,
            name: name,
            ward: ward,
            bed: bed,
            departmentId: departmentId,
            deviceId: deviceId,
            memo: memo
        )
        
        try await patient.save(on: database)
        
        return patient
    }
    
    // MARK: - 환자 수정
    func updatePatient(
        id: UUID,
        hospitalId: UUID,
        name: String?,
        ward: String?,
        bed: Int?,
        departmentId: UUID?,
        memo: String?
    ) async throws -> Patient {
        guard let patient = try await Patient.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "환자 찾을 수 없어요")
        }
        
        if let name = name {
            patient.name = name
        }
        
        if let ward = ward {
            patient.ward = ward
        }
        
        if let bed = bed {
            patient.bed = bed
        }
        
        if let departmentId = departmentId {
            patient.$department.id = departmentId
        }
        
        if let memo = memo {
            patient.memo = memo
        }
        
        try await patient.save(on: database)
        
        return patient
    }
    
    // MARK:  - 환자 삭제
    func deletePatient(id: UUID, hospitalId: UUID) async throws {
        guard let patient = try await Patient.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .with(\.$device)
            .first() else {
            throw Abort(.notFound, reason: "환자를 찾지 못했습니다.")
        }
        
        if patient.$device.id != nil {
            patient.$device.id = nil
            try await patient.save(on: database)
        }
        
        try await patient.delete(on: database)
    }
}
