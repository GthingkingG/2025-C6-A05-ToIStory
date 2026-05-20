//
//  Config.swift
//  Findew
//
//  Created by Apple Coding machine on 11/18/25.
//

import Foundation

enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist cannot be fount")
        }
        return dict
    }()
    
    static let baseURL: String = {
        guard let baseURL = Config.infoDictionary["API_URL"] as? String else {
            fatalError("APIURL not found")
        }
        print("APIURL:\(baseURL)")
        return baseURL
    }()
}
