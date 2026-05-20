# 📍 FindU Backend Server

> **FindU**는 병원 내 환자 및 의료 기기의 실시간 위치 추적(FTM/RTT/UWB 기반)과 효율적인 병동 관리를 위한 백엔드 시스템입니다. Swift의 고성능 비동기 웹 프레임워크인 **Vapor**를 기반으로 개발되었습니다.

---

## 🛠️ Tech Stack & Architecture

- **Language:** Swift 6.0
- **Framework:** [Vapor 4](https://vapor.codes/) (Asynchronous, Non-blocking I/O)
- **Database:** PostgreSQL (with Fluent ORM)
- **Authentication:** JWT (JSON Web Tokens)
- **Storage:** AWS S3 (via SotoS3 SDK)
- **API Documentation:** OpenAPI / Swagger UI (via VaporToOpenAPI)
- **Containerization:** Docker & Docker Compose

---

## 🚀 실행 방법 (Getting Started)

프로젝트를 로컬 환경 또는 Docker 환경에서 시작하는 방법입니다.

### 1. 환경 변수 설정 (`.env`)
프로젝트 루트 디렉토리에 `.env` 파일을 만들고 아래 설정들을 알맞게 입력합니다. (기본 설정은 제공된 `.env`를 참고하세요)

```bash
# Database
DATABASE_HOST=localhost # 로컬 실행 시 localhost, Docker compose 실행 시 db
DATABASE_PORT=5432
DATABASE_NAME=FindU_db
DATABASE_USERNAME=admin
DATABASE_PASSWORD=your_password

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRATION_SECONDS=604800

# Server
PORT=8080
LOG_LEVEL=debug
SERVER_URL=http://localhost:8080

# AWS S3
AWS_ACCOUNT_ID=your-aws-account-id
AWS_REGION=ap-northeast-2
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_S3_BUCKET=your_s3_bucket_name
```

---

### 2. 로컬에서 실행하기 (Swift CLI / Xcode)

#### 데이터베이스 실행
로컬에서 서버를 바로 실행하려면 PostgreSQL 데이터베이스가 먼저 실행 중이어야 합니다. Docker Compose를 사용하여 데이터베이스만 실행할 수 있습니다.
```bash
# PostgreSQL DB 백그라운드 실행
docker compose up db -d
```

#### 프로젝트 빌드 및 실행
Swift CLI를 통해 종속성을 설치하고 서버를 빌드 및 실행합니다.
```bash
# 의존성 패키지 다운로드 및 빌드
swift build

# 데이터베이스 마이그레이션 실행 (최초 실행 또는 스키마 변경 시 필요)
swift run AppleAcademyChallenge6 migrate --yes

# 서버 실행 (기본 포트: 8080)
swift run AppleAcademyChallenge6 serve
```
*또는 Xcode에서 `Package.swift`를 열어 실행 대상을 `AppleAcademyChallenge6` 타겟으로 지정하고 `Cmd + R`로 실행할 수 있습니다.*

---

### 3. Docker Compose로 일괄 실행하기

애플리케이션과 데이터베이스를 Docker 컨테이너 환경에서 한 번에 띄울 수 있습니다.

```bash
# 1. 전체 빌드 및 실행 (DB 및 애플리케이션)
docker compose up --build -d

# 2. 마이그레이션 실행 (최초 실행 시 반드시 실행해야 테이블이 생성됩니다)
docker compose run --rm migrate

# 3. 서비스가 정상 작동하는지 확인
docker compose ps
```

- **전체 중지 및 리소스 정리:**
  ```bash
  docker compose down
  # 데이터베이스 데이터까지 모두 초기화하려면 -v 옵션을 사용합니다.
  docker compose down -v
  ```

---

## 📖 API 문서 확인 (OpenAPI & Swagger)

서버가 실행 중인 상태에서 아래 주소를 통해 대화형 API 문서를 확인하고 API를 테스트할 수 있습니다.

- **Swagger UI:** [http://localhost:8080/docs](http://localhost:8080/docs) (또는 `/swagger-ui.html`로 리다이렉트)
- **OpenAPI Spec (JSON):** [http://localhost:8080/openapi](http://localhost:8080/openapi)

대부분의 API 요청은 `/api/auth/login`을 통해 발급받은 **JWT Bearer 토큰** 인증이 필요합니다. Swagger UI 우측 상단의 `Authorize` 버튼을 눌러 발급된 토큰(`Bearer <Token>`)을 입력하면 인증이 유지됩니다.

---

## 🗂️ 폴더 구조 (Folder Structure)

```text
FindU_BE/
├── Sources/
│   └── AppleAcademyChallenge6/
│       ├── Config/          # CORS, DB, JWT, OpenAPI 설정 및 의존성 주입(DIContainer)
│       ├── Controllers/     # 요청을 처리하고 비즈니스 로직(Services)을 호출하는 컨트롤러
│       ├── DTOs/            # Request / Response 데이터 전송 객체 정의
│       ├── Extension/       # Swift Extension (유틸리티 및 데이터 타입 확장)
│       ├── Middleware/      # JWT 인증, CORS 및 공통 미들웨어
│       ├── Migration/       # Fluent 데이터베이스 스키마 마이그레이션 파일들
│       ├── Model/           # Fluent 데이터베이스 모델 (Anchor, Patient, Room 등)
│       ├── Routes/          # API 엔드포인트 라우팅 설정
│       ├── Services/        # 비즈니스 핵심 로직 (S3 업로드, 대시보드 통계 계산 등)
│       ├── Utils/           # 공통 유틸리티 기능
│       ├── configure.swift  # 애플리케이션 초기 설정 및 모듈 등록
│       ├── entrypoint.swift # Main 진입점
│       └── routes.swift     # 전체 라우터 등록 및 엔드포인트 관리
├── Tests/                   # 단위 및 통합 테스트 코드
├── Public/                  # Swagger UI HTML 및 정적 리소스 파일
├── Package.swift            # Swift Package Manager 프로젝트 매니페스트 (의존성 관리)
├── Dockerfile               # Production 빌드를 위한 도커 파일
├── docker-compose.yml       # DB 및 웹 앱 통합 배포 및 오케스트레이션 구성
└── .env                     # 로컬/도커 환경 설정 파일 (Git 제외 권장)
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
