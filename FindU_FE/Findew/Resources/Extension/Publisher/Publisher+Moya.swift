//
//  Publisher+Moya.swift
//  Findew
//
//  Created by 내꺼다 on 11/12/25.
//

import Foundation
import Moya
import Combine

extension Publisher where Failure == MoyaError {
    func validateResult<T>(
        onFailureAction: (() -> Void)? = nil
    ) -> AnyPublisher<T, MoyaError> where Output == ResponseData<T> {
        self.tryMap { response in
            guard response.isSuccess else {
                throw MoyaError.underlying(APIError.serverError(message: response.message, code: response.code), nil)
            }
            
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            
            guard let result = response.result else {
                throw MoyaError.underlying(APIError.emptyResult, nil)
            }
            return result
        }
        .mapError { error in
            if let moyaError = error as? MoyaError {
                return moyaError
            } else {
                return MoyaError.underlying(error, nil)
            }
        }
        .handleEvents(receiveCompletion: { completion in
            guard case .failure = completion else { return }
            if let action = onFailureAction {
                if Thread.isMainThread {
                    action()
                } else {
                    DispatchQueue.main.async {
                        action()
                    }
                }
            }
        })
        .eraseToAnyPublisher()
    }
}
