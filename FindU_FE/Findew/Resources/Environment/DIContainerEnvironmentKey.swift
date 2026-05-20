//
//  DIContainerEnvironmentKey.swift
//  Findew
//
//  Created by Apple Coding machine on 11/7/25.
//

import Foundation
import SwiftUI

class DIContainerEnvironmentKey: EnvironmentKey {
    static var defaultValue: DIContainer = .init()
}

extension EnvironmentValues {
    var container: DIContainer {
        get { self[DIContainerEnvironmentKey.self] }
        set { self[DIContainerEnvironmentKey.self] = newValue }
    }
}
