//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/15/25.
//

import Vapor

struct MiddleWareConfiguration {
    static func configure(_ app: Application) async {
        // 1. 에러 로깅 미들웨어 (에러를 DB에 기록)
        app.middleware.use(ErrorLoggingMiddleware())

        // 2. 에러 처리 미들웨어 (모든 에러를 캐치하고 CommonResponseDTO 형식으로 응답 반환)
        app.middleware.use(CustomErrorMiddleware())

        // 3. 정적 파일 제공 미들웨어
        app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

        // 4. 요청 로깅 미들웨어 (개발/프로덕션 환경에서 요청 로그 출력)
        app.middleware.use(RouteLoggingMiddleware(logLevel: .info))
        
        // 6. DI 컨테이너 미들웨어
        app.middleware.use(DIMiddleware())
    }
}
