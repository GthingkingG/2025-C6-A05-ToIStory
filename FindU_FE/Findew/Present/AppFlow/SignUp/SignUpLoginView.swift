//
//  SignUpLogiinView.swift
//  Findew
//
//  Created by Apple Coding machine on 11/20/25.
//

import SwiftUI

struct SignUpLoginView: View {
    
    // MARK: - Property
    @State var viewModel: SignUpViewModel
    @Environment(\.dismiss) var dismiss
    @Namespace var nameSpace
    @FocusState var focusedField: SignUpData?
    
    // MARK: - Constant
    fileprivate enum SignUpLoginConstant {
        static let title: String = "회원가입"
        static let btnTitle: String = "완료"
        static let mainSpacing: CGFloat = 20
        static let fieldSpacing: CGFloat = 30
        static let middleContentsHspacing: CGFloat = 10
        static let fieldCorner: CGFloat = 10
        static let mainPadding: EdgeInsets = .init(top: 50, leading: 76, bottom: 120, trailing: 76)
        static let fieldPadding: EdgeInsets = .init(top: 18, leading: 29, bottom: 18, trailing: 29)
        static let corenrRadius: CGFloat = 20
        static let closeSize: CGSize = .init(width: 20, height: 20)
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            ViewThatFits {
                landscapeContent()
            }
        }
    }
    
    @ViewBuilder
    private func landscapeContent() -> some View {
        VStack(spacing: SignUpLoginConstant.mainSpacing, content: {
            topController
            Spacer()
            middleContents
            Spacer()
            bottomContent
        })
        .safeAreaPadding(SignUpLoginConstant.mainPadding)
        .background {
            RoundedRectangle(cornerRadius: SignUpLoginConstant.corenrRadius)
                .fill(.white)
                .frame(maxWidth: .infinity)
        }
        .loadingOverlay(viewModel.isLoading, loadingTextType: .signUpLoading)
        .alertPrompt(item: $viewModel.alertPrompt)
    }
    
    // MARK: - TopContent
    
    /// 상단 버튼 컨트롤러
    private var topController: some View {
        ZStack(alignment: .topLeading) {
            topTitle
            closeBtn
        }
    }
    
    /// 상단 탑 타이틀
    private var topTitle: some View {
        Text(SignUpLoginConstant.title)
            .frame(maxWidth: .infinity)
            .scenePadding()
            .font(.h3)
            .foregroundStyle(.black)
    }
    
    /// 상탄 닫기 버튼
    private var closeBtn: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark")
                .renderingMode(.template)
                .resizable()
                .tint(.black)
                .scaledToFit()
                .frame(width: SignUpLoginConstant.closeSize.width, height: SignUpLoginConstant.closeSize.height)
        })
        .padding()
        .glassEffect(.regular.interactive(), in: .circle)
        .glassEffectID("1", in: nameSpace)
    }
    
    // MARK: - Middle
    private var middleContents: some View {
        VStack(spacing: SignUpLoginConstant.fieldSpacing) {
            ForEach(SignUpData.allCases, id: \.self) { fieldType in
                generateField(
                    type: fieldType,
                    submitLabel: fieldType == SignUpData.allCases.last ? .done : .next,
                    action: {
                        focusNextField(current: fieldType)
                    }
                )
                .padding(SignUpLoginConstant.fieldPadding)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: SignUpLoginConstant.fieldCorner)
                        .fill(.clear)
                        .stroke(.gray02, style: .init(lineWidth: 2))
                })
            }
        }
    }
    
    // MARK: - Bottom Content
    /// 하단 회원가입 버튼
    private var bottomContent: some View {
        MainButton(
            action: {
                viewModel.signUp {
                    dismiss()
                }
            },
            label: SignUpLoginConstant.btnTitle,
            fontColor: viewModel.isSignUpEnabled ? .white : .black,
            tint: viewModel.isSignUpEnabled ? .blue02 : .gray02,
            disabled: !viewModel.isSignUpEnabled
        )
    }
    
    @ViewBuilder
    private func generateField(type: SignUpData, submitLabel: SubmitLabel, action: @escaping () -> Void) -> some View {
        if type.isSecure {
            SecureField(type.placeholder, text: viewModel.binding(for: type))
                .font(type.signUpFont)
                .foregroundStyle(type.signUpFontColor)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(submitLabel)
                .focused($focusedField, equals: type)
                .onSubmit(action)
        } else {
            TextField(type.placeholder, text: viewModel.binding(for: type))
                .font(type.signUpFont)
                .foregroundStyle(type.signUpFontColor)
                .keyboardType(type.keyboardStyle)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(submitLabel)
                .focused($focusedField, equals: type)
                .onSubmit(action)
        }
    }
    
    private func focusNextField(current: SignUpData) {
        let allCases = SignUpData.allCases
        guard let currentIndex = allCases.firstIndex(of: current) else { return }
        
        if currentIndex + 1 < allCases.count {
            focusedField = allCases[currentIndex + 1]
        } else {
            focusedField = nil
            viewModel.signUp {
                dismiss()
            }
        }
    }
}
