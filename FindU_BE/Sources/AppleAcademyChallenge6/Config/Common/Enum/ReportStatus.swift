//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/29/25.
//

import Vapor

enum ReportStatus: String, Codable {
    case pending = "pending"
    case inProgress = "in_progress"
    case resolved = "resolved"
    case closed = "closed"
}
