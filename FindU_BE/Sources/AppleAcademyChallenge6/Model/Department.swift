//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor
import Fluent


/// 소속과 테이블
final class Department: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.departments
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "hospital_id")
    var hospital: HospitalAccount
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "code")
    var code: String
    
    @OptionalField(key: "description")
    var description: String?
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Children(for: \.$department)
    var patients: [Patient]
    
    init() {}
    
    init(
        id: UUID? = nil,
        hospitalId: UUID,
        name: String,
        code: String,
        description: String? = nil
    ) {
        self.id = id
        self.$hospital.id = hospitalId
        self.name = name
        self.code = code
        self.description = description
    }
}
