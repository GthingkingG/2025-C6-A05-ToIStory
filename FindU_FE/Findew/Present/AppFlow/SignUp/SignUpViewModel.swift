//
//  SignUpViewMode.swift
//  Findew
//
//  Created by Apple Coding machine on 11/20/25.
//

import Foundation
import Combine
import SwiftUI

@Observable
class SignUpViewModel {
    /// 회원가입 성공 및 실패
    var isSignUpEnabled: Bool {
        !id.isEmpty && !password.isEmpty && !name.isEmpty
    }
    
    var isLoading: Bool = false

    // 입력 필드 값들
    var id: String = ""
    var password: String = ""
    var business: String = ""
    var name: String = ""
    var alertPrompt: AlertPrompt?

    let container: DIContainer
    var cancellables: Set<AnyCancellable> = .init()

    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    private func generateSignUp() -> AuthSignUpRequest {
        .init(businessNumber: business, email: id, hospitalName: name, password: password)
    }
    
    private func clearSignUp() {
        self.id = ""
        self.password = ""
        self.business = ""
        self.name = ""
    }

    public func signUp(completion: @escaping () -> Void) {
        self.isLoading = true
        
        container.usecaseProvider.authUseCase.signUp(signUp: generateSignUp())
            .validateResult(onFailureAction: {
                self.clearSignUp()
                self.alertAction()
            })
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                defer { isLoading = false }
                switch completion {
                case .finished:
                    Logger.logDebug("회원가입", "회원가입 성공")
                case .failure(let failure):
                    Logger.logDebug("회원가입", "회원가입 실패: \(failure)")
                }
            }, receiveValue: { result in
                Logger.logDebug("회원가입 결과", "\(result)" )
                completion()
            })
            .store(in: &cancellables)
    }

    func binding(for type: SignUpData) -> Binding<String> {
        switch type {
        case .id:
            return Binding(
                get: { self.id },
                set: { self.id = $0 }
            )
        case .password:
            return Binding(
                get: { self.password },
                set: { self.password = $0 }
            )
        case .name:
            return Binding(
                get: { self.name },
                set: { self.name = $0 }
            )
        }
    }
    
    private func alertAction() {
        alertPrompt = .init(id: .init(), title: "회원가입에 실패", message: "비밀번호 8자 이상 혹은 올바른 이메일 형식으로 작성해주세요", positiveBtnTitle: "확인" ,positiveBtnAction: {
            self.alertPrompt = nil
        })
    }
}
