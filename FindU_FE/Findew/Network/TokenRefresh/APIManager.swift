//
//  APIManager.swift
//  Findew
//
//  Created by Apple Coding machine on 11/6/25.
//

import Foundation
import Moya
import Alamofire


class APIManager: @unchecked Sendable {
    static let shared = APIManager()
    
    private let tokenProvider: TokenProviding
    private let accessTokenRefresher: AccessTokenRefresher
    private let session: Session
    
    lazy var sharedDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .useDefaultKeys
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    
    private init() {
        tokenProvider = TokenProvider()
        accessTokenRefresher = AccessTokenRefresher(tokenProviding: tokenProvider)
        session = Session(interceptor: accessTokenRefresher)
    }
    
    public func createProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        let logger = NetworkLoggerPlugin(configuration: .init(
            logOptions: [
                .requestBody,
                .successResponseBody,
                .errorResponseBody,
                .formatRequestAscURL,
                .verbose
            ]
        ))
        return MoyaProvider<T>(session: session, plugins: [logger])
    }
    
    public func testProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return MoyaProvider<T>(stubClosure: MoyaProvider.immediatelyStub)
    }
}
