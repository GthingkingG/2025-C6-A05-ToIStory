//
//  AuthUseCaseProtocol.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Moya
import Combine

protocol AuthUseCaseProtocol {
    /// 로그인
    func executePostLogin(login: AuthLoginRequest) -> AnyPublisher<ResponseData<AuthResponse>, MoyaError>
    /// 토큰 갱신
    func executeGetReissue(token: String) -> AnyPublisher<ResponseData<AuthReissueResponse>, MoyaError>
    /// 병원 계정 로그아웃
    func executeLogout(refreshToken: String) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
    /// 게정 생성
    func signUp(signUp: AuthSignUpRequest) -> AnyPublisher<ResponseData<AuthResponse>, MoyaError>
    /// 병원 계정 탈퇴
    func withdraw(password: String) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError>
}
