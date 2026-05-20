//
//  AccessTokenRefresher.swift
//  Findew
//
//  Created by Apple Coding machine on 11/6/25.
//

import Foundation
import Moya
import Alamofire

/// AccessTokenRefresher
/// - 역할: Alamofire의 RequestInterceptor를 통해 모든 요청에 Access Token을 자동으로 첨부하고,
///         401(Unauthorized) 응답을 감지하면 토큰을 갱신한 뒤 대기 중인 요청들을 재시도합니다.

/// 액세스 토큰을 헤더에 붙이고, 401 응답 시 토큰을 갱신하여 요청을 재시도하는 인터셉터
/// - 동시성: `NSLock`을 사용해 갱신 상태와 대기열을 안전하게 관리합니다.
class AccessTokenRefresher: @unchecked Sendable, RequestInterceptor {
    private let tokenProviding: TokenProviding // 액세스/리프레시 토큰을 제공하고 갱신하는 주체
    private let lock = NSLock() // 갱신 상태와 대기 요청 큐 보호용 락
    private var isRefreshing: Bool = false // 현재 토큰 갱신 진행 여부 플래그
    private var requestInRetry: [(RetryResult) -> Void] = .init() // 갱신 완료 후 재시도/실패 콜백을 모아두는 큐
    
    /// - Parameter tokenProviding: 토큰 제공 및 갱신 책임 객체
    init(tokenProviding: TokenProviding) {
        self.tokenProviding = tokenProviding
    }
    
    /// 모든 요청에 Authorization 헤더(Access Token)를 추가합니다.
    /// - Parameters:
    ///   - urlRequest: 원본 URLRequest
    ///   - session: Alamofire 세션
    ///   - completion: 수정된 URLRequest를 전달하는 완료 핸들러
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        // 토큰이 존재하면 Bearer 토큰을 헤더에 설정
        if let accessToken = self.tokenProviding.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            Logger.logDebug("AccessTokenRefresher", "Authorization 헤더 추가 완료")
        } else {
            Logger.logDebug("AccessTokenRefresher", "토큰 없음 - 헤더 추가 안 함")
        }
        completion(.success(urlRequest))
    }
    
    /// 응답이 401이면 토큰 갱신을 시도하고, 갱신 완료 후 대기 중인 요청들을 재시도합니다.
    /// - Parameters:
    ///   - request: 실패한 요청
    ///   - session: Alamofire 세션
    ///   - error: 발생한 오류
    ///   - completion: 재시도 여부를 전달하는 핸들러
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
            guard let response = request.task?.response as? HTTPURLResponse,
                  response.statusCode == 401 else {
                Logger.logDebug("Debug: Not 401 error", "재시도 하지 않음")
                completion(.doNotRetryWithError(error))
                return
            }
            Logger.logDebug("AccessTokenRefresher", "401 에러 감지 - 토큰 갱신 시도")
            
            if self.isRefreshing {
                Logger.logDebug("AccessTokenRefresher", "토큰 갱신 중 - 요청을 대기열에 추가")
                self.requestInRetry.append(completion)
                return
            }
            
            self.isRefreshing = true
            self.requestInRetry.append(completion)
            Logger.logDebug("AccessTokenRefresher", "토큰 갱신 시작")
            
            self.refreshAction()
    }
    
    private func refreshAction() {
        tokenProviding.refreshToken { [weak self] accessToken, error in
            guard let self = self else { return }

            if let error = error {
                Logger.logError("AccessTokenRefresher", "토큰 갱신 실패: \(error.localizedDescription)")
                let requests = self.syncGetAndClearRequest()
                requests.forEach { $0(.doNotRetryWithError(error)) }
            } else {
                Logger.logDebug("AccessTokenRefresh", "토큰 갱신 성공 - 대기 중인 요청들 재시도")
                let requests = self.syncGetAndClearRequest()
                requests.forEach { $0(.retry) }
            }
        }
    }
    
    /// 대기 중인 요청 콜백 배열을 락으로 보호하며 가져오고, 내부 상태를 초기화합니다.
    /// - Returns: 보관 중이던 completion 핸들러 목록
    private func syncGetAndClearRequest() -> [(RetryResult) -> Void] {
        lock.lock()
        defer { lock.unlock() }
        
        let requests = self.requestInRetry
        requestInRetry.removeAll()
        isRefreshing = false
        
        return requests
    }
}
