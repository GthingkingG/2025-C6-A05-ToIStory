//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor
import Fluent

final class ReportImage: Model, Content, @unchecked Sendable {
    static let schema: String = SchemaValue.reportImages
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "report_id")
    var report: Report
    
    @Field(key: "url")
    var url: String
    
    @Field(key: "filename")
    var filename: String
    
    @Timestamp(key: "uploaded_at", on: .create)
    var uploadedAt: Date?
    
    init() {}
    
    init(
        id: UUID? = nil,
        reportId: UUID,
        url: String,
        filename: String
    ) {
        self.id = id
        self.$report.id = reportId
        self.url = url
        self.filename = filename
    }
}

