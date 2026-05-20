//
//  KeychainSessionStore.swift
//  Findew
//
//  Created by Apple Coding machine on 11/6/25.
//

import Foundation

final class KeychainSessionStore: SessionStore {
    @KeychainStored
    var userInfo: UserInfo?
}
