//
//  DIContainer.swift
//  Findew
//
//  Created by Apple Coding machine on 11/7/25.
//

import Foundation

@Observable
class DIContainer {
    var usecaseProvider: UseCaseProtocol
    
    init(usecaseProvider: UseCaseProtocol = UseCaseProvider()) {
        self.usecaseProvider = usecaseProvider
    }
}
