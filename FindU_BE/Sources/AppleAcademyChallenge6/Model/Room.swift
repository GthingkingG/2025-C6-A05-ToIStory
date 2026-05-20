//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/10/25.
//

import Fluent
import Vapor

final class Room: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.rooms
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: IdKeyField.hospitalId)
    var hospital: HospitalAccount
    
    @Field(key: RoomField.floor)
    var floor: Int
    
    @Field(key: RoomField.roomNumber)
    var roomNumber: String
    
    @Field(key: RoomField.bedCount)
    var bedCount: Int
    
    @Field(key: RoomField.isAvailable)
    var isAvailable: Bool
    
    @Timestamp(key: CommonField.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: CommonField.updatedAt, on: .update)
    var updatedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        hospitalId: UUID,
        floor: Int,
        roomNumber: String,
        bedCount: Int = 1,
        isAvailable: Bool = true
    ) {
        self.id = id
        self.$hospital.id = hospitalId
        self.floor = floor
        self.roomNumber = roomNumber
        self.bedCount = bedCount
        self.isAvailable = isAvailable

    }
}
