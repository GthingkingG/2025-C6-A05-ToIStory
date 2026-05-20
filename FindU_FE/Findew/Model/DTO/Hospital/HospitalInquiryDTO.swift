//
//  HospitalInquiryDTO.swift
//  AppleAcademyChallenge6App
//
//  Created by 내꺼다 on 10/21/25.
//

import Foundation

/// 앱 문의 및 신고
struct HospitalInquiryRequest: ReportsData,  Codable {
    var content: String
    let email: String
    let images: [Data]?
}

protocol ReportsData {
    var content: String { get }
    var images: [Data]? { get }
}
