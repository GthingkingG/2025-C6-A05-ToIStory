//
//  AuthService.swift
//  Findew
//
//  Created by 내꺼다 on 11/10/25.
//

import Foundation
import Combine
import Moya

class AuthService: AuthServiceProtocol, BaseAPIService {
    typealias Target = AuthRouter
    
    var provider: MoyaProvider<Target>
    var decoder: JSONDecoder
    var callbackQueue: DispatchQueue
    
    init(
        decoder: JSONDecoder = APIManager.shared.sharedDecoder,
        callbackQueue: DispatchQueue = .main
    ) {
        self.provider = APIManager.shared.createProvider(for: Target.self)
        self.decoder = decoder
        self.callbackQueue = callbackQueue
    }
    
    func postLogin(login: AuthLoginRequest) -> AnyPublisher<ResponseData<AuthResponse>, MoyaError> {
        request(.postLogin(login: login))
    }
    
    func getReissue(token: String) -> AnyPublisher<ResponseData<AuthReissueResponse>, MoyaError> {
        request(.getReissue(token: token))
    }
    
    func logout(refreshToken: String) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError> {
        request(.logout(refreshToken: refreshToken))
    }
    
    func signUp(signUp: AuthSignUpRequest) -> AnyPublisher<ResponseData<AuthResponse>, MoyaError> {
        request(.signUp(signUp: signUp))
    }
    
    func withdraw(password: String) -> AnyPublisher<ResponseData<EmptyResponse>, MoyaError> {
        request(.withdraw(password: password))
    }
}
