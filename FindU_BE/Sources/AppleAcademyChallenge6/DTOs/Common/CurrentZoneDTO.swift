//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

struct CurrentZoneDTO: Content {
    let type: String
    let name: String
    let floor: Int?
}
