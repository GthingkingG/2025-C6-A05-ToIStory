//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor
import Fluent

/// 환자 테이블
final class Patient: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.patients
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "hospital_id")
    var hospital: HospitalAccount
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "ward")
    var ward: String
    
    @Field(key: "bed")
    var bed: Int
    
    @Parent(key: "department_id")
    var department: Department
    
    @OptionalParent(key: "device_id")
    var device: Device?
    
    @OptionalField(key: "memo")
    var memo: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        hospitalId: UUID,
        name: String,
        ward: String,
        bed: Int,
        departmentId: UUID,
        deviceId: UUID? = nil,
        memo: String? = nil
    ) {
        self.id = id
        self.$hospital.id = hospitalId
        self.name = name
        self.ward = ward
        self.bed = bed
        self.$department.id = departmentId
        self.$device.id = deviceId
        self.memo = memo
    }
}
