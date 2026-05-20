//
//  AuthUseCase.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

class AuthUseCase: AuthUseCaseProtocol {
    private let service: AuthServiceProtocol
    
    init(service: AuthServiceProtocol = AuthService()) {
        self.service = service
    }
    
    /// 로그인
    func executePostLogin(login: AuthLoginRequest) -> AnyPublisher<ResponseData<AuthResponse>, MoyaError> {
        service.postLogin(login: login)
    }
    /// 토큰 갱신
    func executeGetReissue(token: String) -> AnyPublisher<ResponseData<AuthReissueResponse>, MoyaError> {
        service.getReissue(token: token)
    }
    /// 로그아웃
    func executeLogout(refreshToken: String) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError> {
        service.logout(refreshToken: refreshToken)
    }
    /// 병원 계정 생성
    func signUp(signUp: AuthSignUpRequest) -> AnyPublisher<ResponseData<AuthResponse>, MoyaError> {
        service.signUp(signUp: signUp)
    }
    /// 병원 계정 삭제
    func withdraw(password: String) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError> {
        service.withdraw(password: password)
    }
}
