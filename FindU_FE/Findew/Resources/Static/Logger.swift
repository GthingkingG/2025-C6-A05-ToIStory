//
//  Logger.swift
//  Findew
//
//  Created by Apple Coding machine on 11/6/25.
//

import Foundation

class Logger {
    static func logDebug(_ logTitle: String, _ message: String) {
        #if DEBUG
        print("\(logTitle) \(message)")
        #endif
    }

    static func logError(_ logTitle: String,_ message: String) {
        #if DEBUG
        print("\(logTitle) \(message)")
        #endif
    }
}
