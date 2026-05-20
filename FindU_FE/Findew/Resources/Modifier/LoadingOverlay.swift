//
//  LoadingOverlay.swift
//  Findew
//
//  Created by Apple Coding machine on 11/7/25.
//

import SwiftUI

struct LoadingOverlay: ViewModifier {
    
    // MARK: - Property
    let isLoading: Bool
    let loadingTextType: LoadingTextType
    
    // MARK: - Constants
    fileprivate enum LoadingOverlayConstants {
        static let opacity: Double = 0.7
        static let lineSpacing: CGFloat = 2.5
    }
    
    // MARK: - Enum
    enum LoadingTextType: String {
        case defaulLoading = "잠시만 기다려주세요"
        case loginLoading = "로그인 중입니다. \n잠시만 기다려주세요"
        case createPatients = "환자 생성중입니다. \n잠시만 기다려주세요"
        case updatePatienst = "환자 수정중입니다. \n잠시만 기다려주세요"
        case signUpLoading = "회원가입 중입니다. \n잠시만 기다려주세요"
    }
    
    // MARK: - Init
    init(isLoading: Bool, loadingTextType: LoadingTextType) {
        self.isLoading = isLoading
        self.loadingTextType = loadingTextType
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                if isLoading {
                    ZStack {
                        Color.black.opacity(LoadingOverlayConstants.opacity)
                            .ignoresSafeArea()
                            .glassEffectTransition(.matchedGeometry)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        ProgressView(label: {
                            Text(loadingTextType.rawValue)
                                .multilineTextAlignment(.center)
                                .lineSpacing(LoadingOverlayConstants.lineSpacing)
                                .font(.b3)
                                .foregroundStyle(Color.white)
                        })
                        .tint(Color.blue04)
                        .controlSize(.large)
                    }
                }
            })
    }
}

extension View {
    func loadingOverlay(_ isLoading: Bool, loadingTextType: LoadingOverlay.LoadingTextType) -> some View {
        self.modifier(LoadingOverlay(isLoading: isLoading, loadingTextType: loadingTextType))
    }
}
