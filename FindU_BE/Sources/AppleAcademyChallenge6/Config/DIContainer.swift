//
//  File.swift
//  AppleAcademyChallenge6
//
//  Created by Apple Coding machine on 10/17/25.
//

// Sources/App/DI/DIContainer.swift

import Vapor

/// Dependency Injection Container
///
/// Request 기반으로 Service를 생성합니다.
struct DIContainer {
    
    let request: Request
    
    init(request: Request) {
        self.request = request
    }
    
    // MARK: - Services
    
    /// AuthService 생성
    func makeAuthService(request: Request) -> AuthService {
        return AuthService(
            database: request.db,
            app: request.application
        )
    }
    
    /// RoomService 생성
    func makeRoomService(request: Request) -> RoomService {
        return RoomService(database: request.db)
    }
    
    /// DeviceService 생성
    func makeDeviceService(request: Request) -> DeviceService {
        return DeviceService(database: request.db)
    }
    
    /// PatientService 생성
    func makePatientService(request: Request) -> PatientService {
        let deviceService = makeDeviceService(request: request)
        return PatientService(database: request.db, deviceService: deviceService)
    }
    
    /// DepartmentService 생성
    func makeDepartmentService(request: Request) -> DepartmentService {
        return DepartmentService(database: request.db)
    }
    
    /// AnchorService 생성
    func makeAnchorService(request: Request) -> AnchorService {
        return AnchorService(database: request.db)
    }
    
    /// ReportService 생성
    func makeReportService(request: Request) -> ReportService {
        return ReportService(database: request.db)
    }
    
    func makeLocationService(request: Request) -> LocationService {
        let deviceService = makeDeviceService(request: request)
        let anchorService = makeAnchorService(request: request)
        return LocationService(database: request.db, deviceService: deviceService, anchorService: anchorService)
    }
    
    func makeS3Service(request: Request) -> S3Service {
        return S3Service(app: request.application)
    }

    /// DashboardService 생성
    func makeDashboardService(request: Request) -> DashboardService {
        return DashboardService(database: request.db)
    }
}
