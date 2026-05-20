//
//  GeneratePatientsViewModel.swift
//  Findew
//
//  Created by Apple Coding machine on 11/3/25.
//

import Foundation
import Combine

@Observable
class PatientPopOverViewModel {
    
    var patient: PatientGenerateRequest
    var departments: [DepartmentDTO] = .init()
    var devices: [DeviceDTO] = .init()
    let patientType: PatientEnum
    
    // 원본 환자 데이터 (수정 시 비교용)
    private let originalPatient: PatientGenerateRequest
    
    // MARK: - StateProperty
    var createLoading: Bool = false
    var updateLoading: Bool = false
    var isBtnActivity: Bool {
        if patientType == .registration {
            // 환자 등록: 모든 필수 데이터가 채워져야 함
            return !patient.name.isEmpty &&
            !patient.ward.isEmpty &&
            patient.bed > 0 &&
            patient.deviceSerial != nil &&
            patient.departmentId != UUID()
        } else {
            // 환자 수정: 변경된 데이터가 하나라도 있어야 함
            return patient.name != originalPatient.name ||
            patient.ward != originalPatient.ward ||
            patient.bed != originalPatient.bed ||
            patient.departmentId != originalPatient.departmentId ||
            patient.deviceSerial != originalPatient.deviceSerial ||
            patient.memo != originalPatient.memo
        }
    }
    
    // MARK: - Dependency
    let container: DIContainer
    var cancellables: Set<AnyCancellable> = .init()
    
    
    // MARK: - Init
    init(patientType: PatientEnum,
         patient: PatientGenerateRequest,
         container: DIContainer
    ) {
        self.patientType = patientType
        self.patient = patient
        self.originalPatient = patient
        self.container = container
    }
    
    // MARK: - Patients Method
    /// 환자 생성 API 호출
    func generatePatient(completion: @escaping () -> Void) {
        createLoading = true
        
        container.usecaseProvider.patientUseCase
            .executePostGenerate(generate: patient)
            .validateResult()
            .sink { [weak self] completion in
                guard let self else { return }
                defer { self.createLoading = false }
                
                switch completion {
                case .finished:
                    Logger.logDebug("환자 생성", "요청 완료 (Finished)")
                case .failure(let error) :
                    Logger.logError("환자 생성", "실패: \(error.localizedDescription)")
                }
            } receiveValue: { result in
                Logger.logDebug("환자 생성", "성공: \(result)")
                completion()
            }
            .store(in: &cancellables)
    }
    
    /// 환자 수정 API 호출
    func updatePatient(patientId: UUID, completion: @escaping () -> Void) {
        updateLoading = true
        
        let updateRequest = PatientUpdateRequest(
            name: patient.name,
            ward: patient.ward,
            bed: patient.bed,
            departmentId: patient.departmentId,
            memo: patient.memo
        )
        
        let path = PatientUpdatePath(id: patientId)
        
        container.usecaseProvider.patientUseCase
            .executePutUpdate(path: path, update: updateRequest)
            .validateResult()
            .sink { [weak self] completionResult in
                guard let self else { return }
                defer { self.updateLoading = false }
                
                if case .failure(let error) = completionResult {
                    Logger.logError("환자 수정", "실패: \(error.localizedDescription)")
                }
            } receiveValue: { result in
                Logger.logDebug("환자 수정", "성공: \(result)")
                completion()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Department
    /// 부서 조회
    func getDepartments() {
        container.usecaseProvider.departmentUseCase.executeGetList()
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.logDebug("부서 조회", "부서 조회 성공")
                case .failure(let failure):
                    Logger.logDebug("부서 조회 실패", "부서 조회 실패 \(failure)")
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.departments = result
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Device
    /// 장비 조회
    func getDeviceList() async {
        container.usecaseProvider.deviceUseCase.executeGetList()
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.logDebug("장비 조회", "미할당 장비 조회 성공")
                case .failure(let failure):
                    Logger.logDebug("장비 조회", "미할당 장비 조회 실패 \(failure)")
                }
                
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                let device: [DeviceDTO] = result.filter { $0.patient == nil }
                self.devices = device
            })
            .store(in: &cancellables)
    }
}
