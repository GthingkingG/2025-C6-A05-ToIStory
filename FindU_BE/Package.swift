// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "AppleAcademyChallenge6",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.8.0"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "5.1.2"),
        .package(url: "https://github.com/soto-project/soto.git", from: "7.10.0"),
        // 📝 OpenAPI/Swagger 문서 생성
        .package(url: "https://github.com/dankinsoid/VaporToOpenAPI.git", from: "4.9.1")
    ],
    targets: [
        .executableTarget(
            name: "AppleAcademyChallenge6",
            dependencies: [
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "JWT", package: "jwt"),
                .product(name: "SotoS3", package: "soto"),
                .product(name: "VaporToOpenAPI", package: "VaporToOpenAPI")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AppleAcademyChallenge6Tests",
            dependencies: [
                .target(name: "AppleAcademyChallenge6"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
