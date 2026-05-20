//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Vapor

extension Request {
    func requireAuth() throws -> SessionToken {
        guard let sessionToken = self.auth.get(SessionToken.self) else {
            throw Abort(.unauthorized, reason: "authenticated 없음")
        }
        
        return sessionToken
    }
    
    func optoinalAuth() -> SessionToken? {
        return self.auth.get(SessionToken.self)
    }
}
