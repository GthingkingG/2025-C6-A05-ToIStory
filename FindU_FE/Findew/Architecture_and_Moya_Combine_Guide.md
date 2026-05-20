# Findew 프로젝트 아키텍처 및 Combine + Moya 상세 가이드

이 문서는 Findew 프로젝트의 아키텍처 설계, 폴더 구조, 그리고 Combine 및 Moya를 활용한 네트워크 계층 구현에 대해 아주 상세하게 설명합니다.

## 1. 아키텍처 개요 (Architecture Overview)

이 프로젝트는 **MVVM (Model-View-ViewModel)** 패턴을 기반으로 하며, **Clean Architecture**의 개념을 도입하여 관심사를 분리했습니다.

### 1.1 데이터 흐름 (Data Flow)
`View` ↔ `ViewModel` ↔ `UseCase` ↔ `Service (Repository)` ↔ `Router (Moya Target)`

1.  **View (SwiftUI)**: 사용자 인터페이스. `ViewModel`의 상태를 관찰(`@Observable`)하여 UI를 그립니다.
2.  **ViewModel**: View의 상태 관리 및 비즈니스 로직 트리거. `UseCase`를 호출하고 결과를 받아 View에 반영합니다.
3.  **UseCase**: 도메인 로직의 단위. 여러 `Service`를 조합하거나 데이터를 가공합니다.
4.  **Service (Network Layer)**: 실제 API 호출 담당. `MoyaProvider`를 사용합니다.
5.  **Router (Moya TargetType)**: API 명세(URL, Method, Parameter) 정의.

### 1.2 폴더 구조 (Folder Structure)
프로젝트는 기능과 역할에 따라 다음과 같이 구조화되어 있습니다.

-   **Core**: 앱 전반에서 사용되는 핵심 유틸리티 (예: `DIContainer`, `Logger`).
-   **Model**: 데이터 모델 (DTO, Entity).
    -   `DTO`: 서버와 통신하는 데이터 모델 (`Codable`).
-   **Network**: 네트워크 관련 코드.
    -   `Router`: Moya TargetType 정의 (API 명세).
    -   `Service`: 실제 API 호출 로직 (`MoyaProvider` 사용).
    -   `UseCase`: 비즈니스 로직 캡슐화.
    -   `TokenRefresh`: 토큰 갱신 로직 (`RequestInterceptor`).
    -   `Common`: 공통 네트워크 코드 (`BaseAPIService`).
-   **Present**: UI 및 프레젠테이션 로직.
    -   `Tab`: 탭별 화면 구성.
    -   `Common`: 공통 UI 컴포넌트.

---

## 2. 네트워크 계층 상세 (Network Layer Detail)

네트워크 계층은 **Moya**로 추상화되고 **Combine**으로 비동기 처리되며, **Alamofire**의 Interceptor를 통해 토큰 갱신을 자동화합니다.

### 2.1 Router (API 명세 정의)
`Router`는 `Moya.TargetType`을 채택하여 API의 엔드포인트, HTTP 메서드, 파라미터 등을 정의합니다.

**파일**: `Network/Router/AuthRouter.swift`
```swift
enum AuthRouter {
    case postLogin(login: AuthLoginRequest) // 로그인 요청 케이스
    // ...
}

extension AuthRouter: APITargetType {
    var path: String {
        switch self {
        case .postLogin: return "/api/auth/login" // API 경로
        // ...
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postLogin(let login):
            // Encodable 객체를 JSON Body로 변환하여 전송
            return .requestJSONEncodable(login)
        // ...
        }
    }
    // ...
}
```

### 2.2 BaseAPIService (공통 요청 로직)
모든 서비스는 `BaseAPIService`를 채택하여 중복 코드를 줄입니다. 여기서 `MoyaProvider`를 생성하고 Combine Publisher로 변환하는 작업을 수행합니다.

**파일**: `Network/Common/BaseAPIService.swift`
```swift
protocol BaseAPIService {
    associatedtype Target: TargetType
    var provider: MoyaProvider<Target> { get }
    // ...
}

extension BaseAPIService {
    // 공통 요청 메서드
    func request<T: Codable>(_ target: Target) -> AnyPublisher<ResponseData<T>, MoyaError> {
        provider.requestPublisher(target) // 1. Moya -> Combine Publisher 변환
            .filterSuccessfulStatusCodes() // 2. 200~299 상태 코드만 성공으로 간주
            .map(ResponseData<T>.self, using: decoder) // 3. JSON -> ResponseData<T> 디코딩
            .receive(on: callbackQueue) // 4. 결과 전달 스레드 설정 (Main)
            .eraseToAnyPublisher() // 5. AnyPublisher로 타입 소거
    }
}
```

### 2.3 Token Refresh (토큰 갱신 전략)
JWT 기반 인증에서 Access Token 만료 시(401 에러), 자동으로 토큰을 갱신하고 재시도하는 로직이 구현되어 있습니다.

**구성 요소**:
1.  **AccessTokenRefresher (`RequestInterceptor`)**: Alamofire의 인터셉터입니다.
    -   `adapt`: 모든 요청 헤더에 Access Token을 추가합니다.
    -   `retry`: 401 에러 발생 시 토큰 갱신을 시도하고, 성공 시 이전 요청을 재시도합니다.
2.  **TokenProvider**: 실제 토큰 저장(Keychain) 및 갱신 API 호출을 담당합니다.
3.  **APIManager**: `Session`에 `AccessTokenRefresher`를 주입하여 관리합니다.

**파일**: `Network/TokenRefresh/AccessTokenRefresher.swift`
```swift
func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
    guard let response = request.task?.response as? HTTPURLResponse,
          response.statusCode == 401 else {
        completion(.doNotRetryWithError(error)) // 401이 아니면 에러 전달
        return
    }
    
    // 토큰 갱신 로직 실행
    self.refreshAction()
}
```

---

## 3. 의존성 주입 (Dependency Injection)

프로젝트는 `DIContainer`를 통해 의존성을 관리합니다. 이를 통해 테스트 용이성을 높이고 결합도를 낮춥니다.

**파일**: `Core/DIContainer.swift`
```swift
@Observable
class DIContainer {
    var usecaseProvider: UseCaseProtocol
    
    init(usecaseProvider: UseCaseProtocol = UseCaseProvider()) {
        self.usecaseProvider = usecaseProvider
    }
}
```
-   `ViewModel`은 초기화 시 `DIContainer`를 주입받아 필요한 `UseCase`에 접근합니다.

---

## 4. ViewModel 및 Combine 활용

ViewModel은 `UseCase`를 통해 데이터를 요청하고, Combine의 `sink`를 사용하여 결과를 처리합니다.

**파일**: `Present/Tab/Patients/PatientsTable/PatientsTableViewModel.swift`

```swift
func listPatient() {
    isLoading = true
    
    // 1. UseCase 호출
    container.usecaseProvider.patientUseCase.executeGetList()
        .validateResult() // 커스텀 Operator (ResponseData의 성공 여부 확인)
        .sink { [weak self] completion in
            // 2. 완료/실패 처리
            defer { self?.isLoading = false }
            switch completion {
            case .finished:
                Logger.logDebug("성공")
            case .failure(let error):
                Logger.logError("실패: \(error)")
            }
        } receiveValue: { [weak self] result in
            // 3. 데이터 수신 및 상태 업데이트
            self?._patientsData = result
        }
        .store(in: &cancellables) // 4. 구독 관리
}
```

### 주요 Combine Operator
-   **sink**: Publisher의 이벤트를 구독합니다. `receiveCompletion`은 스트림 종료(성공/실패) 시, `receiveValue`는 데이터 도착 시 호출됩니다.
-   **store(in:)**: `AnyCancellable`을 저장하여 ViewModel 해제 시 구독을 자동으로 취소합니다.

---

## 5. 요약 (Summary)

1.  **구조**: MVVM + Clean Architecture로 역할 분리.
2.  **네트워크**: Moya + Combine으로 선언적이고 반응형으로 구현.
3.  **토큰 관리**: `RequestInterceptor`를 통해 투명하게 토큰 갱신 및 재시도 처리.
4.  **DI**: `DIContainer`를 통해 의존성 주입 및 관리.
