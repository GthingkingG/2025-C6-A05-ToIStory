//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Foundation
import Vapor
import Fluent

final class ReportService: ServiceProtocol {
    var database: any Database
    
    init(database: any Database) {
        self.database = database
    }
    
    // MARK: -  문의 및 신고
    func submitInquiry(
        hospitalId: UUID,
        content: String,
        email: String,
        images: [String]
    ) async throws -> Report {
        let report = Report(hospitalId: hospitalId, content: content, email: email, status: .pending)

        print("🔍 DEBUG: Attempting to save report to database...")
        do {
            try await report.save(on: database)
            print("✅ DEBUG: Report saved successfully")
        } catch {
            print("❌ DEBUG: Failed to save report: \(String(reflecting: error))")
            throw error
        }
        
        guard let reportId = report.id else {
            throw Abort(.internalServerError, reason: "Report ID 생성 실패")
        }
        
        for imageURrl in images {
            let fileName = URL(string: imageURrl)?.lastPathComponent ?? "unknwon.jpp"
            
            let reportImage = ReportImage(
                reportId: reportId,
                url: imageURrl,
                filename: fileName
            )
            
            try await reportImage.save(on: database)
        }
        
        return report
    }
}
