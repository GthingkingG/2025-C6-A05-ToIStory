//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Vapor
import Fluent

protocol ServiceProtocol {
    var database: any Database { get }
    
    init(database: any Database)
}
