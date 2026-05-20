# 📱 Findew (FindU iOS Client)

> **Findew**는 병원 내 환자 및 의료 기기의 실시간 위치 추적과 병동 관리를 지원하는 **FindU** 서비스의 iOS 클라이언트 애플리케이션입니다. SwiftUI와 Combine, Moya를 사용하여 현대적이고 선언적인 반응형 아키텍처로 구현되었습니다.

---

## 🛠️ Tech Stack & Architecture

- **UI Framework:** SwiftUI (iOS 17+)
- **Architecture:** MVVM + Clean Architecture (관심사 분리)
- **Reactive Programming:** Combine
- **Networking:** Moya (Alamofire 기반 네트워크 추상화)
- **Token Management:** `RequestInterceptor`를 활용한 JWT Access Token 자동 갱신 및 재시도 전략
- **Dependency Injection:** `DIContainer`를 사용한 유연한 의존성 관리 및 테스트성 확보

---

## 🚀 실행 방법 (Getting Started)

프로젝트를 로컬 Xcode 환경에서 빌드하고 실행하는 방법입니다.

### 1. 사전 요구사항 (Prerequisites)
- **macOS** 운영체제
- **Xcode 15.0** 이상 (Swift 6.0 호환 권장)
- 실행 중인 **FindU 백엔드 서버** (로컬 또는 원격)

### 2. 백엔드 API URL 설정
애플리케이션은 서버와의 통신을 위해 `Info.plist`에 정의된 `API_URL` 값을 참조합니다.
1. Xcode로 `Findew.xcodeproj`를 엽니다.
2. 프로젝트 타겟 설정의 **Build Settings** 또는 **Info.plist**에서 `API_URL` 변수의 값을 현재 가동 중인 백엔드 서버 주소(예: `http://localhost:8080` 또는 실배포 서버 주소)로 수정합니다.

### 3. 프로젝트 빌드 및 실행
1. Xcode에서 `Findew` 스킴(Scheme)을 선택합니다.
2. 실행할 시뮬레이터(Simulator) 또는 연결된 iOS 기기를 선택합니다.
3. `Product` -> `Run` 또는 단축키 `Cmd + R`을 입력하여 앱을 빌드하고 실행합니다.
   * Swift Package Manager(SPM)를 통해 자동으로 필요한 외부 패키지(Moya, Alamofire 등)가 다운로드되고 빌드가 시작됩니다.*

---

## 🗂️ 폴더 구조 (Folder Structure)

```text
Findew/
├── Findew.xcodeproj/     # Xcode 프로젝트 설정 파일
├── Findew/
│   ├── App/              # 애플리케이션 진입점 및 전반적인 화면 흐름 제어 (AppFlow)
│   ├── Core/             # 의존성 주입(DIContainer), 로거 및 API 설정(Config) 등 공통 핵심 유틸리티
│   ├── Model/            # 데이터 모델 (DTO 및 Entity 클래스/구조체)
│   ├── Network/          # Combine 및 Moya를 활용한 네트워크 레이어
│   │   ├── Common/       # API 호출 기본 프로토콜 및 Base 서비스 정의
│   │   ├── Router/       # Moya TargetType을 준수하는 각 API 라우터 명세 (엔드포인트 설정)
│   │   ├── Service/      # 실제 서버 통신을 담당하는 API 서비스 클래스
│   │   ├── TokenRefresh/ # JWT 토큰 만료(401) 대응 자동 갱신 미들웨어 (RequestInterceptor)
│   │   └── UseCase/      # 비즈니스 단위 로직을 캡슐화한 유스케이스 계층
│   ├── Present/          # SwiftUI 뷰 및 뷰모델 프레젠테이션 레이어
│   │   ├── Tab/          # 메인 탭 화면 구성 (Dashboard, Patients, Rooms 등)
│   │   └── Common/       # 앱 전역에서 재사용되는 커스텀 UI 컴포넌트
│   └── Resources/        # Assets.xcassets, 로컬라이징 파일, 폰트 등 리소스 폴더
└── README.md
```

---

## 🌀 코딩 컨벤션 (Coding Convention)

- 파라미터 이름을 기준으로 줄바꿈 한다.
```swift
let actionSheet = UIActionSheet(
  title: "정말 계정을 삭제하실 건가요?",
  delegate: self,
  cancelButtonTitle: "취소",
  destructiveButtonTitle: "삭제해주세요"
)
```

- `if let` 구문이 길 경우에 줄바꿈 한다.
```swift
if let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
   let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
   user.gender == .female {
  // ...
}
```

- 나중에 추가로 작업해야 할 부분에 대해서는 `// TODO: - xxx` 주석을 남기도록 한다.
- 코드의 섹션을 분리할 때는 `// MARK: - xxx` 주석을 남기도록 한다.
- 함수에 대해 전부 주석을 남기도록 하여 무슨 액션을 하는지 알 수 있도록 한다.

---

## 🔖 브랜치 컨벤션 (Branch Convention)

* `main` - 제품 출시 브랜치
* `develop` - 출시를 위해 개발하는 브랜치
* `feat/xx` - 기능 단위로 독립적인 개발 환경을 위해 작성
* `refac/xx` - 개발된 기능을 리팩토링 하기 위해 작성
* `hotfix/xx` - 출시 버전에서 발생한 버그를 수정하는 브랜치
* `chore/xx` - 빌드 작업, 패키지 매니저 설정 등
* `design/xx` - 디자인 변경
* `bugfix/xx` - 버그 수정

---

## 📁 PR 컨벤션 (Pull Request Convention)

PR 시 제공되는 템플릿에 맞추어 아래 내용을 작성합니다.

1. **PR 유형 작성**: 어떤 변경 사항이 있었는지 `[ ]` 괄호 사이에 `x`를 입력하여 체크합니다.
2. **작업 내용 작성**: 작업 내용에 대해 자세하게 기술합니다.
3. **추후 진행할 작업**: PR 이후 이어서 작업할 사항을 작성합니다.
4. **리뷰 포인트**: 리뷰어가 특히 중점적으로 확인해야 할 부분을 작성합니다.
5. **PR 제목 태그**: PR 제목은 아래 태그 종류를 따릅니다.

### 🌟 태그 종류
| 태그 | 설명 |
|:---|:---|
| `[Feat]` | 새로운 기능 추가 |
| `[Fix]` | 버그 수정 |
| `[Refactor]` | 코드 리팩토링 (기능 변경 없이 구조 개선) |
| `[Style]` | 코드 포맷팅, 들여쓰기 수정 등 |
| `[Docs]` | 문서 관련 수정 (README 등) |
| `[Test]` | 테스트 코드 추가 또는 수정 |
| `[Chore]` | 빌드/설정 관련 작업 |
| `[Design]` | UI 디자인 수정 |
| `[Hotfix]` | 운영 중 긴급 수정 |
| `[CI/CD]` | 배포 및 워크플로우 관련 작업 |

---

## 📑 커밋 컨벤션 (Commit Convention)

### 💬 깃모지 가이드
| 아이콘 | 코드 | 설명 | 원문 |
| :---: | :---: | :---: | :---: |
| 🐛 | bug | 버그 수정 | Fix a bug |
| ✨ | sparkles | 새 기능 | Introduce new features |
| 💄 | lipstick | UI/스타일 파일 추가/수정 | Add or update the UI and style files |
| ♻️ | recycle | 코드 리팩토링 | Refactor code |
| ➕ | heavy_plus_sign | 의존성 추가 | Add a dependency |
| 🔀 | twisted_rightwards_arrows | 브랜치 합병 | Merge branches |
| 💡 | bulb | 주석 추가/수정 | Add or update comments in source code |
| 🔥 | fire | 코드/파일 삭제 | Remove code or files |
| 🚑 | ambulance | 긴급 수정 | Critical hotfix |
| 🎉 | tada | 프로젝트 시작 | Begin a project |
| 🔒 | lock | 보안 이슈 수정 | Fix security issues |
| 🔖 | bookmark | 릴리즈/버전 태그 | Release / Version tags |
| 📝 | memo | 문서 추가/수정 | Add or update documentation |
| 🔧 | wrench | 구성 파일 추가/삭제 | Add or update configuration files. |
| ⚡️ | zap | 성능 개선 | Improve performance |
| 🎨 | art | 코드 구조 개선 | Improve structure / format of the code |
| 📦 | package | 컴파일된 파일 추가/수정 | Add or update compiled files |
| 👽 | alien | 외부 API 변경 반영 | Update code due to external API changes |
| 🚚 | truck | 리소스 이동, 이름 변경 | Move or rename resources |
| 🙈 | see_no_evil | .gitignore 추가/수정 | Add or update a .gitignore file |

### 🏷️ 커밋 태그 가이드
| 태그 | 설명 |
|:---|:---|
| `[Feat]` | 새로운 기능 추가 |
| `[Fix]` | 버그 수정 |
| `[Refactor]` | 코드 리팩토링 (기능 변경 없이 구조 개선) |
| `[Style]` | 코드 포맷팅, 세미콜론 누락, 들여쓰기 수정 등 |
| `[Docs]` | README, 문서 수정 |
| `[Test]` | 테스트 코드 추가 및 수정 |
| `[Chore]` | 패키지 매니저 설정, 빌드 설정 등 기타 작업 |
| `[Design]` | UI, CSS, 레이아웃 등 디자인 관련 수정 |
| `[Hotfix]` | 운영 중 긴급 수정이 필요한 버그 대응 |
| `[CI/CD]` | 배포 관련 설정, 워크플로우 구성 등 |

### ✅ 커밋/PR 예시 모음
> 🎉 `[Chore] 프로젝트 초기 세팅` <br>
> ✨ `[Feat] 프로필 화면 UI 구현` <br>
> 🐛 `[Fix] iOS 17에서 버튼 클릭 오류 수정` <br>
> 💄 `[Design] 로그인 화면 레이아웃 조정` <br>
> 📝 `[Docs] README에 프로젝트 소개 추가`
