//
//  LoginView.swift
//  Findew
//
//  Created by Apple Coding machine on 11/3/25.
//

import Foundation
import SwiftUI

struct LoginView: View {
    // MARK: - Property
    @State var viewModel: LoginViewModel
    @FocusState var isFocused: LoginFieldEnum?
    @Environment(\.appFlow) var appFlow
    @Environment(\.container) var container
    
    // MARK: - Costant
    fileprivate enum LoginConstant {
        static let fieldSpacing: CGFloat = 10
        static let middleVspacing: CGFloat = 20
        static let portraitContent: CGFloat = 20
        static let bottomContentSpacing: CGFloat = 40
        
        static let mainSpacer: (CGFloat, CGFloat) = (56, 29)
        static let mainPadding: EdgeInsets = .init(top: 90, leading: 76, bottom: 120, trailing: 76)
        static let fieldPadding: EdgeInsets = .init(top: 18, leading: 29, bottom: 18, trailing: 29)
        static let safePadding: CGFloat = 340
        static let btnVerticalPadding: CGFloat = 8
        
        static let imageSize: CGSize = .init(width: 68, height: 68)
        
        static let corenrRadius: CGFloat = 20
        static let fieldCornerRadius: CGFloat = 10
        
        static let loginText: String = "Login"
        static let signUpText: String = "회원가입"
    }
    
    // MARK: - Init
    init(container: DIContainer, appFlow: AppFlow) {
        self.viewModel = .init(container: container, appFlow: appFlow)
    }
    
    // MARK: - Body
    var body: some View {
        Color.blue03.ignoresSafeArea()
            .overlay(alignment: .center, content: {
                topArea
            })
            .alertPrompt(item: $viewModel.alertPrompt)
            .loadingOverlay(viewModel.isLoading, loadingTextType: .loginLoading)
            .sheet(isPresented: $viewModel.isShowSignUp, content: {
                SignUpLoginView(container: container)
            })
    }
    
    private var topArea: some View {
        GeometryReader { geo in
            ViewThatFits {
                deviceFitsContents(geometry: geo, horizon: geo.size.width * 0.25)
                deviceFitsContents(geometry: geo, horizon: geo.size.width * 0.1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func deviceFitsContents(geometry: GeometryProxy, horizon: CGFloat) -> some View {
        VStack {
            topContent
            Spacer().frame(height: LoginConstant.mainSpacer.0)
            middleContent
            Spacer().frame(height: LoginConstant.mainSpacer.1)
            bottomContent
        }
        .padding(LoginConstant.mainPadding)
        .background {
            RoundedRectangle(cornerRadius: LoginConstant.corenrRadius)
                .fill(.white)
                .frame(maxWidth: .infinity)
        }
        .safeAreaPadding(.horizontal, horizon)
    }
    
    // MARK: - Top
    /// 상단 로고
    private var topContent: some View {
        Image(.logo)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: LoginConstant.imageSize.width, height: LoginConstant.imageSize.height)
    }
    
    // MARK: - Middle
    /// 중간 아이디 및 비밀번호 입력
    private var middleContent: some View {
        VStack(spacing: LoginConstant.middleVspacing, content: {
            generateField(type: .id, submitLabel: .next) {
            }
            generateField(type: .password, submitLabel: .done) {
                viewModel.loginAction()
            }
        })
    }
    
    /// 입력 필드 생성 함수
    /// - Parameters:
    ///   - type: 입력 필드 타입
    ///   - submitLabel: 키보드 라벨
    ///   - action: 입력
    /// - Returns: 키보드 다음 버튼 액션
    private func generateField(type: LoginFieldEnum, submitLabel: SubmitLabel, action: @escaping () -> Void) -> some View {
        HStack(spacing: LoginConstant.fieldSpacing, content: {
            textFieldContent(type)
                .font(type.loginFieldFont)
                .foregroundStyle(.black)
                .keyboardType(type.keyboardStyle)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(submitLabel)
                .onSubmit {
                    action()
                }
            
            if let image = type.eyeBtnImage(showPassword: viewModel.showPassword) {
                Button(action: {
                    viewModel.showPassword.toggle()
                }, label: {
                    image
                        .tint(.black)
                })
            }
        })
        .padding(LoginConstant.fieldPadding)
        .overlay(content: {
            RoundedRectangle(cornerRadius: LoginConstant.fieldCornerRadius)
                .fill(.clear)
                .stroke(type.loginFieldStrokeColor, style: .init(lineWidth: type.loginFieldStrokeWidth))
        })
        
    }
    
    /// 아이디 및 비밀번호에 해당하는 텍스트 필드 생성
    /// - Parameter type: 필드 타입
    /// - Returns: 텍스트 필드 반환 혹은 시큐어 필드 반환
    @ViewBuilder
    private func textFieldContent(_ type: LoginFieldEnum) -> some View {
        switch type {
        case .id:
            TextField("", text: $viewModel.id, prompt: placeholder(type))
        case .password:
            ZStack {
                TextField("", text: $viewModel.password, prompt: placeholder(type))
                    .opacity(viewModel.showPassword ? 1 : 0)
                SecureField("", text: $viewModel.password, prompt: placeholder(type))
                    .opacity(viewModel.showPassword ? 0 : 1)
            }
        }
    }
    
    /// 필드 내부 placeholder.
    /// - Parameter type: 필드 타입
    /// - Returns: placeholder 텍스트 반환
    private func placeholder(_ type: LoginFieldEnum) -> Text {
        Text(type.placeholder)
            .font(type.loginFieldFont)
            .foregroundStyle(type.placeholderColor)
    }
    
    // MARK: - Bottom
    
    /// 로그인 버튼
    private var bottomContent: some View {
        VStack(spacing: LoginConstant.bottomContentSpacing, content: {
            MainButton(
                action: {
                    viewModel.loginAction()
                },
                label: LoginConstant.loginText,
                fontColor: viewModel.isLoginEnabled ? .white : .black,
                tint: viewModel.isLoginEnabled ? .blue02 : .gray02,
                disabled: !viewModel.isLoginEnabled
            )
            
           Button(action: {
               viewModel.isShowSignUp.toggle()
           }, label: {
               Text(LoginConstant.signUpText)
                   .font(.caption)
                   .foregroundStyle(.black)
                   .underline()
           })
        })
    }
}
