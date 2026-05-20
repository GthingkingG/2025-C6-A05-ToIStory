//
//  PatientsTableViewModel.swift
//  Findew
//
//  Created by Apple Coding machine on 11/4/25.
//

import Foundation
import Combine

@Observable
class PatientsTableViewModel {
    
    // MARK: - Refresh {
    private var refreshManager = RefreshManager()
    private var autoRefreshTask: Task<Void, Never>?
    
    var lastRefeshTimeText: String {
        refreshManager.timeSinceLastRefresh
    }
    
    // MARK: - StateProperty
    var isShowSearch: Bool = false
    var isShowDetail: Bool = false
    var isShowAdd: Bool = false
    var isShowInquiry: Bool = false
    var isShowReport: Bool = false
    var isLoading: Bool = false
    var isAvailableDelete: Bool = true
    
    // MARK: - StoreProperty
    let keychain: KeychainSessionStore = .init()
    /// API로부터 가져오는 환자 데이터
    var _patientsData: [PatientDTO] = []
    /// 필터링된 환자 데이터
    var patientsData: [PatientDTO] {
        var data: [PatientDTO] = _patientsData
        if !searchText.isEmpty {
            data = _patientsData.filter { patient in
                patient.name.contains(searchText) ||
                patient.ward.contains(searchText)
            }
        }
        
        return data
    }
    
    /// 정렬기준 값
    var sortOrder: [KeyPathComparator<PatientDTO>] = .init()
    /// 선택된 환자 값
    var selectionPatient: Set<PatientDTO.ID> = .init()
    /// 검색 값
    var searchText: String = ""
    /// Alert 데이터
    var alertPrompt: AlertPrompt?
    /// 탈퇴 데이터
    var deletePrompt: WithdrawPrompt?
    /// 탈퇴 패스워드
    var password: String = ""
    /// 사이드바 층 데이터 API
    var sideFloor: RoomListResponse? = nil
    /// 편집한 환자
    var editPatient: PatientGenerateRequest? = nil
    /// 병원 삭제 텍스트
    var deleteAuthText: String {
        isAvailableDelete ? "계정을 삭제하겠습니까?" : "패스워드가 일치하지 않습니다."
    }
    
    // MARK: - SideBar
    /// 사이드 바 선택한 층
    var selectedRoom: String? = nil
    /// 사이드 바 전체 층 섹션
    var expandedSection: Set<Int> = .init()

    
    // MARK: - Dependency
    let container: DIContainer
    private var cancellables: Set<AnyCancellable> = .init()
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - Method
    /// 환자 삭제 시 액션
    /// - Parameter patient: 선택한 환자
    func delete(_ patient: PatientDTO) {
        alertPrompt = .init(
            id: .init(),
            title: "환자 삭제하기",
            message: "환자를 삭제하겠습니까?",
            positiveBtnTitle: "삭제하기",
            positiveBtnAction: { [weak self] in
                guard let self else { return }
                self.alertPrompt = nil
                
                Task {
                    await self.deletePatient(id: patient.id)
                }
            },
            negativeBtnTitle: "취소하기",
            negativeBtnAction: { [weak self] in
                self?.alertPrompt = nil
            },
            isPositiveBtnDestructive: true
        )
    }
    
    /// 환자 편집
    /// - Parameter patient: 선택한 환자
    /// - Returns: 편집 데이터
    func edit(_ patient: PatientDTO) -> PatientGenerateRequest {
        .init(
            id: patient.id,
            name: patient.name,
            ward: patient.ward,
            bed: patient.bed,
            departmentId: patient.department.id,
            deviceSerial: patient.device?.serialNumber,
            memo: patient.memo
        )
    }
    
    // MARK: - Patient Method
    /// 환자 목록 조회 API 호출
    func listPatient() {
        isLoading = true
        
        container.usecaseProvider.patientUseCase.executeGetList()
            .validateResult()
            .sink { [weak self] completion in
                guard let self else { return }
                defer { self.isLoading = false}
                
                switch completion {
                case .finished:
                    Logger.logDebug("환자 목록 조회", "요청 완료 (finished)")
                case .failure(let error):
                    Logger.logError("환자 목록 조회", "실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] result in
                guard let self else { return }
                self._patientsData = result
            }
            .store(in: &cancellables)
    }
    
    /// 환자 삭제 API 호출
    func deletePatient(id: UUID) async {
        let path = PatientDeletPath(id: id)
        
        container.usecaseProvider.patientUseCase
            .executeDeletePatient(path: path)
            .validateResult()
            .sink { [weak self] completion in
                guard let self else { return }
                defer { self.isLoading = false}
                switch completion {
                case .finished:
                    Logger.logDebug("환자 삭제", "요청 완료 (finished)")
                case .failure(let error):
                    Logger.logError("환자 삭제", "실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                self._patientsData.removeAll(where: { $0.id == id })
                Logger.logDebug("환자 삭제", "성공")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Room Method
    /// 사이드 바 병동 조회
    public func roomList() {
        guard self.sideFloor == nil else { return }
        
        container.usecaseProvider.roomUseCase.executeGetList()
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.logDebug("호실 병동 조회", "층/병실 방 번호 조회 성공")
                case .failure(let failure):
                    Logger.logDebug("호실 병동 조회", "층/병실 방 번호 조회 실패 \(failure)")
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.sideFloor = result
            })
            .store(in: &cancellables)
    }
    
    // MARK: - LogoutMethod
    public func logout() {
        guard let userInfo = keychain.userInfo,
              let refreshToken = userInfo.refreshToken
        else { return }
        
        container.usecaseProvider.authUseCase.executeLogout(refreshToken: refreshToken)
            .validateResult()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.logDebug("로그아웃", "로그아웃 성공")
                case .failure(let failure):
                    Logger.logDebug("로그아웃", "로그아웃 실패: \(failure)")
                }
            }, receiveValue: { [weak self] result in
                self?.keychain.userInfo = nil
                Logger.logDebug("로그아웃 결과", "\(result)")
            })
            .store(in: &cancellables)
    }
    
    // MARK: - LogoutMethod
    private func withdraw(password: String, onSuccess: (() -> Void)? = nil) {
        container.usecaseProvider.authUseCase.withdraw(password: password)
            .validateResult(onFailureAction: {
                self.isAvailableDelete = false
            })
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Logger.logDebug("회원 탈퇴", "회원 탈퇴 성공")
                case .failure(let failure):
                    Logger.logDebug("회원 탈퇴 실패", "회원 탈퇴 실패: \(failure)")
                }
            }, receiveValue: { [weak self] _ in
                self?.isAvailableDelete = true
                self?.keychain.userInfo = nil
                onSuccess?()
            })
            .store(in: &cancellables)
    }
    
    public func deleteAlertPrompt(onSuccess: (() -> Void)? = nil) {
        self.deletePrompt = .init(
            title: "회원 탈퇴",
            message: deleteAuthText,
            submitAction: { [weak self] password in
                self?.withdraw(password: password, onSuccess: onSuccess)
            }, password: self.password)
    }
    
    // MARK: - Refresh Mthod
    func refresh() async {
        Logger.logDebug("새로고침", "데이터 새로 고침 중")
        refreshManager.markRefreshed()
        listPatient()
    }
    
    private func startAutoRefresh() {
        autoRefreshTask?.cancel()
        autoRefreshTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 3_600_000_000_000)
                if refreshManager.shouldRefreshTime {
                    await refresh()
                }
            }
        }
    }
    
    private func stopAutoRefresh() {
        autoRefreshTask?.cancel()
        autoRefreshTask = nil
    }
    
    func onViewAppear() async {
        listPatient()
        if refreshManager.shouldRefreshTime {
            Task { await refresh() }
        }
        startAutoRefresh()
    }
    
    func onViewDisappear() {
        stopAutoRefresh()
    }
    
    func onSearchChange() {
        Task { await refresh() }
    }
}

