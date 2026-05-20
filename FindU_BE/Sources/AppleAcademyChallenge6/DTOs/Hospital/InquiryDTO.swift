//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

struct InquiryRequest: Content {
    let content: String
    let email: String
    let images: [File]?
}
