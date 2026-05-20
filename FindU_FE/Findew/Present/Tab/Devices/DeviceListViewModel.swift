//
//  DeviceListViewModel.swift
//  Findew
//
//  Created by 내꺼다 on 11/5/25.
//

import Foundation
import Combine

@Observable
class DeviceListViewModel {
    var devices: [DeviceDTO] {
          guard !searchText.isEmpty else { return _devices }

          return _devices.filter { device in
              (device.patient?.name.contains(searchText) ?? false) ||
              (device.patient?.ward.contains(searchText) ?? false)
          }
      }
    
    var _devices: [DeviceDTO] = []
    
    var searchText: String = ""
    var isSelectionMode: Bool = false
    var selectedDeviceIds: Set<String> = []
    var isLoading: Bool = false
    var alertPrompt: AlertPrompt?
    
    // MARK: - Dependency
    private let container: DIContainer
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - API Method
    /// 기기 목록 조회 API 호출
    func listDevices() {
        isLoading = true
        
        container.usecaseProvider.deviceUseCase
            .executeGetList()
            .validateResult()
            .sink { [weak self] completion in
                guard let self else { return }
                
                defer { self.isLoading = false }
                switch completion {
                case .finished:
                    Logger.logDebug("기기 목록 조회", "요청 완료 (finished)")
                case .failure(let error):
                    Logger.logError("기기 목록 조회", "실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] deviceList in
                guard let self else { return }
                Logger.logDebug("기기 목록 조회", "성공: \(deviceList.count)")
                self._devices = deviceList
            }
            .store(in: &cancellables)
    }
    
    /// 기기 신고 API 호출
    func reportDevices() {
        guard !selectedDeviceIds.isEmpty else {
            Logger.logError("기기 신고", "선택된 기기 없음")
            return
        }
        
        let request = generateReportRequest()
        
        container.usecaseProvider.deviceUseCase
            .executePostReports(report: request)
            .validateResult()
            .sink { [weak self] completion in
                guard let self else { return }
                
                defer { self.isLoading = false }
                switch completion {
                case .finished:
                    Logger.logDebug("기기 신고", "요청 완료 (finished)")
                case .failure(let error):
                    Logger.logError("기기 신고", "요청 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                Logger.logDebug("기기 신고", "성공: \(selectedDeviceIds.count)개 신고 완료")
                
                self.handleReportSuccess()
            }
            .store(in: &cancellables)
    }
    
    /// 신고 요청
    private func generateReportRequest() -> DeviceReportsRequest {
        let serialNumbers = selectedDeviceIds.compactMap { id in
            _devices.first(where: { $0.serialNumber == id })?.serialNumber
        }
        
        return DeviceReportsRequest(serialNumber: serialNumbers)
    }
    
    /// 신고 성공 후
    private func handleReportSuccess() {
        selectedDeviceIds.removeAll()
        isSelectionMode = false
        showReportConfirmationAlert()
    }
    
    /// 선택 취소 (cancel 버튼)
    func cancelSelection() {
        selectedDeviceIds.removeAll()
        isSelectionMode = false
    }
    
    /// 기기 선택/해제 토글
    func toggleDeviceSelection(_ deviceId: String) {
        if selectedDeviceIds.contains(deviceId) {
            selectedDeviceIds.remove(deviceId)
        } else {
            selectedDeviceIds.insert(deviceId)
        }
    }
    
    /// 신고 확인 Alert - 완료용으로 변경
    private func showReportConfirmationAlert() {
        let count = selectedDeviceIds.count
        
        alertPrompt = .init(
            id: .init(),
            title: "기기 신고 완료",
            message: "\(count)개 신고 완료되었습니다.",
            positiveBtnTitle: "확인",
            positiveBtnAction: { [weak self] in
                guard let self else { return }
                self.alertPrompt = nil
            }
        )
    }
}
