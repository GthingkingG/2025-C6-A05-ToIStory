//
//  AppFlow.swift
//  Findew
//
//  Created by Apple Coding machine on 11/7/25.
//

import Foundation
import SwiftUI

@Observable
class AppFlow {
    private(set) var appState: AppState = .splash
    private var tokenProvider: TokenProvider
    private var sessionStore: SessionStore
    
    init(
        tokenProvider: TokenProvider = TokenProvider(),
        sessionStore: SessionStore = KeychainSessionStore()
    ) {
        self.tokenProvider = tokenProvider
        self.sessionStore = sessionStore
    }
    
    func checkAppState(completion: @escaping (Bool, Error?) -> Void) {
        tokenProvider.refreshToken { [weak self] accessToken, error in
            guard let self = self else { return }

            if let error = error as? TokenError, error == .noRefreshToken {
                Logger.logDebug("AppFlow", "등록된 유저 정보 없음 - 로그인 필요")

                withAnimation(.easeInOut(duration: 0.6)) {
                    self.appState = .login
                }
                self.sessionStore.userInfo = nil
                completion(false, nil)

            } else if let error = error {
                Logger.logError("AppFlow", "토큰 갱신 실패: \(error.localizedDescription)")

                withAnimation(.easeInOut(duration: 0.6)) {
                    self.appState = .login
                }
                self.sessionStore.userInfo = nil
                completion(false, error)

            } else {
                Logger.logDebug("AppFlow", "유저 정보 존재 - 토큰 유효")

                withAnimation(.easeInOut(duration: 0.6)) {
                    self.appState = .home
                }
                completion(true, nil)
            }
        }
    }
    
    /// 로그인 성공 시 홈 이동
    func loginSuccess() {
        Logger.logDebug("AppFlow", "로그인 성공 - 홈으로 이동")
        appState = .home
    }
    
    /// 로그아웃 성공 시 홈 이동
    func logout() async {
          Logger.logDebug("AppFlow", "로그아웃 - 로그인 화면으로 이동")
          
          appState = .login
          sessionStore.userInfo = nil
      }
}
