//
//  PatientsTable.swift
//  Findew
//
//  Created by Apple Coding machine on 11/4/25.
//

import SwiftUI

struct PatientsTableView: View {
    // MARK: - Property
    @State var tabCase: TabCaseEnum = .location
    @State var viewModel: PatientsTableViewModel
    @State private var columnVisibility: NavigationSplitViewVisibility = .detailOnly
    @State private var editMode: EditMode = .inactive
    @State private var isRefreshing: Bool = false
    @State private var showDetailSheet: Bool = false
    @Binding var showSegment: Bool

    let container: DIContainer
    
    // MARK: - Constant
    fileprivate enum PatientsTableConstant {
        static let columnsSize: [CGFloat] = [160, 169, 174, 321, 371]
        static let containerSpacing: CGFloat = 40
        
        static let placeholder: String = "환자 이름 또는 병동 번호"
        static let notCurrent: String = "위치 정보 없음"
        static let tableColumns: [String] = ["이름", "병동 번호", "소속 과", "현   위치", "기타" ]
        static let navigationTitle: String = "환자 목록"
    }
    
    // MARK: - Init
    init(container: DIContainer, showSegment: Binding<Bool>) {
        self.container = container
        self.viewModel = .init(container: container)
        self._showSegment = showSegment
    }
    
    // MARK: - Body
    var body: some View {
        
        NavigationSplitView(columnVisibility: $columnVisibility, sidebar: {
            SideBarView(viewModel: viewModel)
        }, detail: {
            tableContents
                .navigationBarTitleDisplayMode(.large)
                .navigationTitle(viewModel.searchText)
                .toolbar(content: {
                    ToolBarCollection.PatientManagementToolbar(
                        editMode: $editMode,
                        refreshText: viewModel.lastRefeshTimeText,
                        refresh: { Task { await viewModel.refresh() } },
                        add: { viewModel.isShowAdd.toggle() },
                        trash: { self.multiDeleteAction() },
                        cancell: { editMode = .inactive })
                })
                .alertPrompt(item: $viewModel.alertPrompt)
                .sheet(item: $viewModel.editPatient, onDismiss: {
                    Task {
                        await viewModel.refresh()
                    }
                }, content: { patient in
                    PatientPopOverView(patientType: .correction, patient: patient, container: container)
                })
                .sheet(isPresented: $viewModel.isShowAdd, onDismiss: {
                    Task {
                        await viewModel.refresh()
                    }
                }, content: {
                    PatientPopOverView(patientType: .registration, patient: .init(name: "", ward: "", bed: 0, departmentId: UUID()), container: container)
                        .presentationDetents([.large])
                })
                .sheet(isPresented: $showDetailSheet) {
                    if let selectedId = viewModel.selectionPatient.first,
                       let patient = viewModel.patientsData.first(where: { $0.id == selectedId }) {
                        PatientDetailView(patient: patient)
                    }
                }
                .onChange(of: viewModel.selectionPatient) { oldValue, newValue in
                    if !newValue.isEmpty && editMode == .inactive {
                        showDetailSheet = true
                    }
                }
        })
        .navigationSplitViewStyle(.prominentDetail)
        .task {
            viewModel.roomList()
            await viewModel.onViewAppear()
            
        }
        .onDisappear {
            viewModel.onViewDisappear()
        }
        .onChange(of: columnVisibility, { old, new in
            if new == .detailOnly {
                showSegment = true
            } else if new == .all {
                showSegment = false
            }
        })
        .onChange(of: showDetailSheet, { old, new in
            if !new {
                viewModel.selectionPatient = []
            }
        })
    }
    
    private var navigationTitleText: Text {
        let text: String
        if viewModel.searchText.isEmpty {
            text = "환자 목록"
        } else if Int(viewModel.searchText) != nil {
            text = "\(viewModel.searchText)호"
        } else {
            text = "환자 목록"
        }

        return Text(text)
    }
    
    // MARK: - Middle
    @ViewBuilder
    private var tableContents: some View {
        Table(of: PatientDTO.self, selection: $viewModel.selectionPatient, sortOrder: $viewModel.sortOrder, columns: {
            /* 이름 */
            TableColumn(tableTitle(PatientsTableConstant.tableColumns[0]), value: \.name) { patient in
                cellText(patient.name, for: patient)
            }
            .width(max: PatientsTableConstant.columnsSize[0])

            /* 병동번호 */
            TableColumn(tableTitle(PatientsTableConstant.tableColumns[1]), value: \.wardBedNumber) { patient in
                cellText(patient.wardBedNumber, for: patient)
            }
            .width(max: PatientsTableConstant.columnsSize[1])

            /* 소속과 */
            TableColumn(tableTitle(PatientsTableConstant.tableColumns[2]), value: \.department.name) { patient in
                cellText(patient.department.name, for: patient)
            }
            .width(max: PatientsTableConstant.columnsSize[2])

            /* 현 위치 */
            TableColumn(tableTitle(PatientsTableConstant.tableColumns[3]), value: \.currentLocationText) { patient in
                cellText(patient.currentLocationText, for: patient)
            }
            .width(ideal: PatientsTableConstant.columnsSize[3])

            /* 기타 */
            TableColumn(tableTitle(PatientsTableConstant.tableColumns[4])) { patient in
                cellText(patient.memo ?? "", for: patient)
            }
            .width(ideal: PatientsTableConstant.columnsSize[4])
        }, rows: {
            ForEach(viewModel.patientsData) { patient in
                TableRow(patient)
                    .contextMenu {
                        ForEach(PatientsContextMenu.allCases, id: \.self) { menu in
                            Button(role: menu.role) {
                                handleContextMenuAction(menu, for: patient)
                            } label: {
                                Label(menu.title, systemImage: menu.iconName)
                                    .foregroundStyle(menu.color, menu.color)
                            }

                            Divider()
                        }
                    }
            }
        })
        .font(.b3)
        .tint(.blue02)
        .searchable(
            text: $viewModel.searchText,
            prompt: placeholderText)
        .onChange(of: viewModel.sortOrder, { _, new in
            viewModel._patientsData.sort(using: new)
        })
        .environment(\.editMode, $editMode)
        .overlay(content: {
            if viewModel.patientsData.isEmpty {
                NotPatientsView()
            }
        })
        .refreshable {
            isRefreshing = true
            await viewModel.refresh()

            try? await Task.sleep(nanoseconds: 2_000_000_000)
            isRefreshing = false
        }
        .tint(.blue03)
    }
    
    // MARK: - Context Menu
    /// 컨텍스트 메뉴 액션 핸들러
    /// - Parameters:
    ///   - menu: 선택된 메뉴 타입
    ///   - patient: 대상 환자 정보
    private func handleContextMenuAction(_ menu: PatientsContextMenu, for patient: PatientDTO) {
        switch menu {
        case .edit:
            viewModel.editPatient = viewModel.edit(patient)
        case .detail:
            self.viewModel.selectionPatient = [patient.id]
            showDetailSheet = true
        case .delete:
            viewModel.delete(patient)
        }
    }
    
    // MARK: - ETC
    /// 검색 placeholder
    private var placeholderText: Text {
        Text(PatientsTableConstant.placeholder)
    }

    /// 테이블 상단 고정 타이틀
    /// - Parameter text: 테이틀 텍스트 값
    /// - Returns: 텍스트 뷰 반환
    private func tableTitle(_ text: String) -> Text {
        Text(text)
    }

    /// 테이블 셀 텍스트 생성 (선택 상태에 따른 색상 적용)
    /// - Parameters:
    ///   - text: 표시할 텍스트
    ///   - patient: 환자 정보
    /// - Returns: 스타일이 적용된 텍스트 뷰
    @ViewBuilder
    private func cellText(_ text: String, for patient: PatientDTO) -> some View {
        let selected = viewModel.selectionPatient.contains(patient.id)
        Text(text)
            .foregroundStyle(selected ? .white : .black)
    }
    
    // MARK: - Delete
    /// 환자 삭제 액션
    private func multiDeleteAction() {
        guard !viewModel.selectionPatient.isEmpty else { return }
        Task {
            for patientId in viewModel.selectionPatient {
                await viewModel.deletePatient(id: patientId)
            }
            await viewModel.refresh()
        }
    }
}
