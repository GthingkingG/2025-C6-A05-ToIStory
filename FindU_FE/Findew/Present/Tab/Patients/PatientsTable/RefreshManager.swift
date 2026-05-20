//
//  RefreshManager.swift
//  Findew
//
//  Created by Apple Coding machine on 11/8/25.
//

import Foundation
import SwiftUI

@Observable
class RefreshManager {
    private static let lastRefreshKey = "patientRefreshTime"
    private static let refreshInterval: TimeInterval = 3600
    
    var lastRefreshTime: Date? {
        didSet {
            if let date = lastRefreshTime {
                UserDefaults.standard.set(date, forKey:  Self.lastRefreshKey)
            }
        }
    }
    
    init() {
        self.lastRefreshTime = UserDefaults.standard.object(forKey: Self.lastRefreshKey) as? Date
        
    }
    
    var shouldRefreshTime: Bool {
        guard let lastTime = lastRefreshTime else { return true }
        return Date().timeIntervalSince(lastTime) >= Self.refreshInterval
    }
    
    var timeSinceLastRefresh: String {
        guard let lastTime = lastRefreshTime else { return "갱신 필요"}
        let interval = Date().timeIntervalSince(lastTime)
        
        if interval < 60 {
            return "방금 전"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)분 전"
        } else {
            let hours = Int(interval / 3600)
            return "\(hours)시간 전"
        }
    }
    
    func markRefreshed() {
        lastRefreshTime = Date()
    }
}
