//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 11/13/25.
//

import Vapor
import VaporToOpenAPI

struct OpenAPIConfiguration {
    
    // MARK: - Configure (configure.swift에서 호출용)
    static func configure(_ app: Application) throws {
        // 필요시 초기 설정을 여기에 추가
        // 현재는 generateOpenAPI가 모든 설정을 처리
    }
    
    static func generateOpenAPI(for app: Application) -> OpenAPIObject {
        return app.routes.openAPI(
            info: createInfo(),
            servers: createServers(environment: app.environment),
            components: createComponents(),
            commonAuth: createCommonAuth(),
            externalDocs: createExternalDocs()
        )
    }
    
    private static func createInfo() -> InfoObject {
        return .init(
            title: "FindU API",
            description: """
                병원 내 환자 위치 추적 시스템 API (자동 생성)
                  ## 주요 기능
                  > 환자 및 디바이스 관리
                  > 시간 위치 추적 (FTM 기반)
                  > 병실, 병동, 앵커 관리
                  > 문의 및 신고 (이미지 업로드 지원)
                  
                  ## 인증
                  대부분의 엔드포인트는 JWT Bearer 토큰 인증이 필요합니다.
                  `/api/auth/login` 엔드포인트로 토큰을 발급받으세요.
                """,
            license: .init(name: "MIT", url: .init(string: "https://opensource.org/licenses/MIT")),
            version: "1.0.0"
        )
    }
    
    private static func createServers(environment: Environment)
    -> [ServerObject]
    {
        // 환경 변수에서 서버 URL 가져오기, 없으면 기본값 사용
        let serverUrl = Environment.get(EnvironmentValue.serverUrl) ?? "http://localhost:8080"

        switch environment {
        case .production:
            return [
                .init(url: serverUrl, description: "Production Server")
            ]
        case .development:
            return [
                .init(url: serverUrl, description: "Development Server")
            ]
        default:
            return [
                .init(url: serverUrl, description: "Server")
            ]
        }
    }
    
    private static func createComponents() -> ComponentsObject {
        var components = ComponentsObject()
        
        components.securitySchemes = [
            "Authorization": .init(securitySchemeObject: SecuritySchemeObject(
                type: .http,
                description: "JWT Bearer 토큰을 Authorization 헤더에 포함하세요",
                name: nil,
                in: nil,
                scheme: .bearer,
                bearerFormat: "JWT",
                flows: nil,
                openIdConnectUrl: nil
            ))
        ]
        
        return components
    }
    
    private static func createCommonAuth() -> [AuthSchemeObject] {
        let bearerScheme = SecuritySchemeObject(
            type: .http,
            description: "JWT Bearer 토큰",
            scheme: .bearer,
            bearerFormat: "JWT"
        )
        
        return [
            AuthSchemeObject(
                id: "Authorization",
                scopes: [],
                scheme: bearerScheme
            )
        ]
    }
    
    private static func createExternalDocs() -> ExternalDocumentationObject? {
        return ExternalDocumentationObject(
            description: "FindU 개발 문서",
            url: URL(string: "https://github.com/ADA6-IoT/VaporServer")
        )
    }
}
