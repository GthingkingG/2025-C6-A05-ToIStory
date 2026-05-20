//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/16/25.
//

import Foundation
import Fluent

enum CommonField {
    static let createdAt: FieldKey = "created_at"
    static let updatedAt: FieldKey = "updated_at"
    static let expiresAt: FieldKey = "expires_at"
}

enum HospitalAccountField {
    static let email: FieldKey = "email"
    static let password: FieldKey = "password_hash"
    static let name: FieldKey = "hospital_name"
    static let businessNumber: FieldKey = "business_number"
}

enum TokenField {
    static let accessToken: FieldKey = "access_token"
    static let refreshToken: FieldKey = "refresh_token"
}

enum DepartmentField {
    static let departmentName: FieldKey = "name"
    static let code: FieldKey = "code"
    static let description: FieldKey = "description"
}

enum DeviceField {
    static let serialNumber: FieldKey = "serial_number"
    static let batteryLevel: FieldKey = "battery_level"
    static let isMalfunctioning: FieldKey = "is_malfunctioning"
    static let currentZoneType: FieldKey = "current_zone_type"
    static let currentZoneName: FieldKey = "current_zone_name"
    static let currentFloor: FieldKey = "current_floor"
    static let locationX: FieldKey = "location_x"
    static let locationY: FieldKey = "location_y"
    static let lastUpdate: FieldKey = "last_location_update"
}

enum PatientField {
    static let name: FieldKey = "name"
    static let ward: FieldKey = "ward"
    static let bed: FieldKey = "bed"
    static let memo: FieldKey = "memo"
}

enum AnchorField {
    static let macAddress: FieldKey = "mac_address"
    static let zoneName: FieldKey = "zone_name"
    static let zoneType: FieldKey = "zone_type"
    static let floor: FieldKey = "floor"
    static let positionX: FieldKey = "position_x"
    static let positionY: FieldKey = "position_y"
    static let positionZ: FieldKey = "position_z"
    static let isActive: FieldKey = "is_active"
}

enum ReportField {
    static let type: FieldKey = "type"
    static let content: FieldKey = "content"
    static let email: FieldKey = "email"
    static let status: FieldKey = "status"
    static let adminReply: FieldKey = "admin_reply"
    static let repliedBy: FieldKey = "replied_by"
    static let repliedAt: FieldKey = "replied_at"
}

enum ReportImageField {
    static let url: FieldKey = "url"
    static let filename: FieldKey = "filename"
    static let uploadedAt: FieldKey = "uploaded_at"
}

enum IdKeyField {
    static let hospitalId: FieldKey = "hospital_id"
    static let departmentId: FieldKey = "department_id"
    static let deviceId: FieldKey = "device_id"
    static let reportId: FieldKey = "report_id"
}

enum RoomField {
    static let floor: FieldKey = "floor"
    static let roomNumber: FieldKey = "room_number"
    static let bedCount: FieldKey = "bed_count"
    static let roomType: FieldKey = "room_type"
    static let isAvailable: FieldKey = "is_available"
}

enum ErrorLogField {
    static let endpoint: FieldKey = "endpoint"
    static let method: FieldKey = "method"
    static let statusCode: FieldKey = "status_code"
    static let errorMessage: FieldKey = "error_message"
    static let stackTrace: FieldKey = "stack_trace"
    static let requestBody: FieldKey = "request_body"
    static let userAgent: FieldKey = "user_agent"
    static let ipAddress: FieldKey = "ip_address"
}
