//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/12/25.
//

import Foundation
import Vapor

struct DIMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        request.storage[DIContainerKey.self] = DIContainer(request: request)
        return try await next.respond(to: request)
    }
}

struct DIContainerKey: StorageKey {
    typealias Value = DIContainer
}

extension Request {
    var di: DIContainer {
        guard let container = storage[DIContainerKey.self] else {
            fatalError("DIContainer 찾을 수 없습니다.")
        }
        return container
    }
}
