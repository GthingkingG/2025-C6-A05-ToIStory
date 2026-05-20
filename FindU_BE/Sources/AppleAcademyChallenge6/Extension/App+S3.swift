//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor

extension Application {
    var s3: S3Service {
        get {
            guard let service = self.storage[S3ServiceKey.self] else {
                fatalError("S3Service Not configured")
            }
            return service
        }
        set {
            self.storage[S3ServiceKey.self] = newValue
        }
    }
    
    struct S3ServiceKey: StorageKey {
        typealias Value = S3Service
        
        static let defaultValue: S3Service? = nil
    }
}
