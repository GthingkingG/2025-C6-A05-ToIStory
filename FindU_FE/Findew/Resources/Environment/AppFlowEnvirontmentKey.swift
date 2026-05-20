//
//  AppFlowEnvirontmentKey.swift
//  Findew
//
//  Created by Apple Coding machine on 11/7/25.
//

import Foundation
import SwiftUI

class AppFlowEnvirontmentKey: EnvironmentKey {
    static var defaultValue: AppFlow = .init()
}

extension EnvironmentValues {
    var appFlow: AppFlow {
        get { self[AppFlowEnvirontmentKey.self] }
        set { self[AppFlowEnvirontmentKey.self] = newValue }
    }
}
