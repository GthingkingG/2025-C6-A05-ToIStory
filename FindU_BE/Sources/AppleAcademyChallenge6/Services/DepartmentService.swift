//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Foundation
import Vapor
import Fluent

final class DepartmentService: ServiceProtocol {
    var database: any Database
    
    init(database: any FluentKit.Database) {
        self.database = database
    }
    
    // MARK: - 진료과 전체 조회
    func getAllDepartments(hospitalId: UUID) async throws -> [Department] {
        try await Department.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .with(\.$patients)
            .all()
    }
    
    // MARK: - 진료과 등록
    func createDepartment(
        hospitalId: UUID,
        name: String,
        code: String,
        description: String?
    ) async throws -> Department {
        if let _ = try await Department.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .filter(\.$code == code)
            .first() {
            throw Abort(.conflict, reason: "진료과가 이미 존재합니다.")
        }
        
        if let _ = try await Department.query(on: database)
            .filter(\.$hospital.$id == hospitalId)
            .filter(\.$name == name)
            .first() {
            throw Abort(.conflict, reason: "진료과 이미 존재합니다.")
        }
        
        let department = Department(
            hospitalId: hospitalId,
            name: name,
            code: code,
            description: description
        )
        
        try await department.save(on: database)
        
        return department
    }
    
    // MARK: - 진려과 수정
    func updateDepartment(
        id: UUID,
        hospitalId: UUID,
        name: String?,
        code: String?,
        description: String?
    ) async throws -> Department {
        guard let department = try await Department.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .first() else {
            throw Abort(.notFound, reason: "진료과 찾을 수 없습니다.")
        }
        
        if let name = name {
            department.name = name
        }
        
        if let code = code {
            department.code = code
        }
        
        if let description = description {
            department.description = description
        }
        
        try await department.save(on: database)
        
        return department
    }
    
    // MARK: - 진료과 삭제
    
    func deleteDepartment(id: UUID, hospitalId: UUID) async throws {
        guard let department = try await Department.query(on: database)
            .filter(\.$id == id)
            .filter(\.$hospital.$id == hospitalId)
            .with(\.$patients)
            .first() else {
            throw Abort(.notFound, reason: "진료과 찾을 수 없습니다.")
        }
        
        let patientCount = department.patients.count
        if patientCount > 0 {
            throw Abort(.conflict, reason: "해당 진료과에 소속된 환자가 있어 삭제할 수 없습니다. \(patientCount)")
        }
        
        try await department.delete(on: database)
    }
}
