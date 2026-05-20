//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/30/25.
//

import Vapor

struct SimplePatientDTO: Content {
    let id: UUID
    let name: String
    let ward: String
    let bed: Int
    
    init(from patient: Patient) {
        self.id = patient.id!
        self.name = patient.name
        self.ward = patient.ward
        self.bed = patient.bed
    }
}
