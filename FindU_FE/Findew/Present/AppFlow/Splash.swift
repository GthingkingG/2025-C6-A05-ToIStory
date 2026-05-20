//
//  Onboarding.swift
//  Findew
//
//  Created by Apple Coding machine on 11/3/25.
//

import SwiftUI

struct Splash: View {
    
    @Environment(\.appFlow) var appFlow
    @Environment(\.container) var container
    
    // MARK: - Splash
    fileprivate enum SplashConstant {
        static let bottomPadding: CGFloat = 100
        static let timer: TimeInterval = 2
        static let title: String = "Find U"
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            Color.blue03.ignoresSafeArea()
            Image(.logoStick)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
        }
        .safeAreaInset(edge: .bottom, content: {
            Text(SplashConstant.title)
                .font(.h3)
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 25, x: 0, y: 2)
        })
        .safeAreaPadding(.bottom, SplashConstant.bottomPadding)
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + SplashConstant.timer , execute: {
                appFlow.checkAppState { success, error in
                    if let error = error {
                        Logger.logError("스플래시 에러", "최초 사용자 혹은 등록된 유저 아님 \(error)")
                    }
                }
            })
        }
    }
}

#Preview {
    Splash()
}
