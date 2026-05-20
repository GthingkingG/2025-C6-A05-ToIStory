//
//  UseCaseProvider.swift
//  Findew
//
//  Created by Apple Coding machine on 11/7/25.
//

import Foundation

protocol UseCaseProtocol {
    var authUseCase: AuthUseCaseProtocol { get }
    var patientUseCase: PatientUseCaseProtocol { get }
    var hospitalUseCase: HospitalUseCaseProtocol { get }
    var deviceUseCase: DeviceUseCaseProtocol { get }
    var departmentUseCase: DepartmentUseCaseProtocol { get }
    var roomUseCase: RoomUseCaseProtocol { get }
}

class UseCaseProvider: UseCaseProtocol {
    let authUseCase: AuthUseCaseProtocol
    let patientUseCase: PatientUseCaseProtocol
    let hospitalUseCase: HospitalUseCaseProtocol
    let deviceUseCase: DeviceUseCaseProtocol
    let departmentUseCase: DepartmentUseCaseProtocol
    let roomUseCase: RoomUseCaseProtocol

    init(
        authUseCase: AuthUseCaseProtocol = AuthUseCase(),
        patientUseCase: PatientUseCaseProtocol = PatientUseCase(),
        hospitalUseCase: HospitalUseCaseProtocol = HospitalUseCase(),
        deviceUseCase: DeviceUseCaseProtocol = DeviceUseCase(),
        departmentUseCase: DepartmentUseCaseProtocol = DepartmentUseCase(),
        roomUseCase: RoomUseCase = RoomUseCase()
    ) {
        self.authUseCase = authUseCase
        self.patientUseCase = patientUseCase
        self.hospitalUseCase = hospitalUseCase
        self.deviceUseCase = deviceUseCase
        self.departmentUseCase = departmentUseCase
        self.roomUseCase = roomUseCase
    }
}
