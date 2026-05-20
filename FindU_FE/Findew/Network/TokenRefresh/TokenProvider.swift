//
//  TokenProvider.swift
//  Findew
//
//  Created by Apple Coding machine on 11/6/25.
//

import Foundation
import Moya

// MARK: - Token Error
enum TokenError: Error {
    case noRefreshToken
    case refreshFailure
    case invalidResponse
}

// MARK: - Token Provider
final class TokenProvider: TokenProviding {
    
    // MARK: Properties
    @KeychainStored private var userInfo: UserInfo?
    private let provider = MoyaProvider<AuthRouter>()
    
    // MARK: Public Interface
    var accessToken: String? {
        get { userInfo?.accessToken }
        set {
            guard var user = userInfo else { return }
            user.accessToken = newValue
            userInfo = user
            
            Logger.logDebug("유저 액세스 토큰", "토큰 갱신: \(String(describing: newValue))")
        }
    }
    
    var refreshToken: String? {
        get { userInfo?.refreshToken }
        set {
            guard var user = userInfo else { return }
            user.refreshToken = newValue
            userInfo = user
            Logger.logDebug("유저 리프레시 토큰", "토큰 갱신: \(String(describing: newValue))")
        }
    }
    
    func refreshToken(completion: @escaping (String?, (any Error)?) -> Void) {
        guard let refreshToken = refreshToken else {
            return completion(nil, TokenError.refreshFailure)
        }
        
        provider.request(.getReissue(token: refreshToken)) { [weak self] result in
            self?.handleTokenRefreshResponse(result, completion: completion)
        }
    }
    
    private func handleTokenRefreshResponse(
        _ result: Result<Response, MoyaError>,
        completion: @escaping (String?, Error?) -> Void
    ) {
        switch result {
        case .success(let response):
            handleSuccessResponse(response, completion: completion)
        case .failure(let error):
            completion(nil, error)
        }
    }
    
    private func handleSuccessResponse(_ response: Response, completion: @escaping (String?, Error?) -> Void) {
        do {
            let tokenData = try JSONDecoder().decode(ResponseData<AuthReissueResponse>.self, from: response.data)
            guard tokenData.isSuccess, let result = tokenData.result else {
                return completion(nil, TokenError.refreshFailure)
            }
            
            self.accessToken = result.accessToken
            self.refreshToken = result.refreshToken
            completion(result.accessToken, nil)
        }
        catch {
            completion(nil, error)
        }
    }
}

