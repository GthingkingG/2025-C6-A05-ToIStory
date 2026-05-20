//
//  TokenProviding.swift
//  Findew
//
//  Created by Apple Coding machine on 11/6/25.
//

import Foundation

protocol TokenProviding: Sendable {
    var accessToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}

