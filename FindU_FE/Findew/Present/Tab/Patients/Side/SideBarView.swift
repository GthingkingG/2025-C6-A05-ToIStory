//
//  SideBarView.swift
//  Findew
//
//  Created by Apple Coding machine on 11/5/25.
//

import SwiftUI

struct SideBarView: View {
    
    // MARK: - Property
    @Bindable var viewModel: PatientsTableViewModel
    @State var contactAlert: ContactAlertPromprt? = nil
    @Environment(\.appFlow) var appFlow
    @Namespace var nameSpace
    
    // MARK: - Constant
    fileprivate enum SideBarConstants {
        static let mainVspacing: CGFloat = 8
        static let imagePadding: CGFloat = 5
        static let sideBtnPadding: CGFloat = 10
        static let floorSpacing: CGFloat = 20
        static let menuPadding: EdgeInsets = .init(top: 10, leading: 8, bottom: 10, trailing: 8)
        static let settingImage: CGSize = .init(width: 30, height: 30)
        
        static let allText: String = "전체"
        static let systemImage: String = "gear"
        static let downImage: String = "chevron.down"
    }
    
    // MARK: - Init
    init(viewModel: PatientsTableViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: SideBarConstants.mainVspacing, content: {
            topContent
            middleContent
            Spacer()
        })
        .safeAreaBar(edge: .bottom, alignment: .leading, content: {
            bottomContent
        })
        .safeAreaPadding(.horizontal, DefaultConstants.defaultHorizonPadding)
        .sheet(isPresented: $viewModel.isShowInquiry, content: {
            ReportInquiry(contactType: .inquiry, container: viewModel.container)
        })
        .drawPrompt(item: $viewModel.deletePrompt)
    }
    
    // MARK: - Top
    /// 상단 전체 선택 버튼 영역
    private var topContent: some View {
        generateText(SideBarConstants.allText,
                     isSelected: viewModel.selectedRoom == nil ? true : false,
                     action: {
            viewModel.selectedRoom = nil
            viewModel.searchText.removeAll()
            viewModel.expandedSection.removeAll()
        })
    }
    
    // MARK: - Middle
    /// 중간 층 섹션 및 층별 병실 버튼
    private var middleContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SideBarConstants.floorSpacing, content: {
                if let floor = viewModel.sideFloor {
                    ForEach(floor.floors, id: \.id) { floor in
                        VStack(spacing: .zero, content: {
                            floorHeaderButton(floor.floor)
                            
                            if viewModel.expandedSection.contains(floor.floor) {
                                ForEach(floor.rooms, id: \.id) { room in
                                    roomButton(room: room.roomNumber)
                                }
                            }
                        })
                    }
                }
            })
        }
    }
    
    // MARK: - BottomContents
    /// 하단 옵션 도구 모음 버튼
    private var bottomContent: some View {
        Menu(content: {
            Section {
                ForEach(SystemSettingType.allCases.filter { $0.isDestructive }, id: \.self) { menu in
                    generateSystemSetting(menu.title, role: menu.role, action: {
                        systemAction(menu)
                    })
                }
            }
            Section {
                ForEach(SystemSettingType.allCases.filter { !$0.isDestructive }, id: \.self) { menu in
                    generateSystemSetting(menu.title, role: menu.role, action: {
                        systemAction(menu)
                    })
                }
            }
        }, label: {
            Image(systemName: SideBarConstants.systemImage)
                .resizable()
                .frame(width: SideBarConstants.settingImage.width, height: SideBarConstants.settingImage.height)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.black)
        })
    }
    
    // MARK: - FloorHeader
    /// 층 섹션 버튼
    /// - Parameter floor: 층 번호
    /// - Returns: 층 섹셕 버튼
    private func floorHeaderButton(_ floor: Int) -> some View {
        Button(action: {
            withAnimation {
                if viewModel.expandedSection.contains(floor) {
                    viewModel.expandedSection.remove(floor)
                } else {
                    viewModel.expandedSection.insert(floor)
                }
            }
        }, label: {
            HStack {
                Text("\(floor)층")
                Spacer()
                Image(systemName: SideBarConstants.downImage)
                    .rotationEffect(.degrees(viewModel.expandedSection.contains(floor) ? -180 : .pi))
            }
            .font(.b3)
            .foregroundStyle(Color.gray07)
            .padding(SideBarConstants.sideBtnPadding)
        })
    }
    
    /// 층 내부 병 버튼
    /// - Parameter room: 병실 번호
    /// - Returns: 병실 번호
    private func roomButton(room: String) -> some View {
        generateText(room, isSelected: viewModel.selectedRoom == room, action: {
            viewModel.selectedRoom = room
            viewModel.searchText = viewModel.selectedRoom ?? ""
        })
    }
    
    /// 사이드바 내부 층 섹션 및 병실 텍스트 버튼 생성
    /// - Parameters:
    ///   - text: 텍스트 값
    ///   - isSelected: 선택되었는지 값
    ///   - action: 버튼 액션
    /// - Returns: 층/병실 번호 텍스트 버튼
    private func generateText(_ text: String, isSelected: Bool, action: @escaping () -> Void) -> some View{
        Button(action: {
            action()
        }, label: {
            Text(text)
                .font(.b3)
                .foregroundStyle(isSelected ? .white : .gray03)
                .padding(SideBarConstants.sideBtnPadding)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background {
                    Capsule()
                        .fill(isSelected ? .blue03 : .clear)
                        .glassEffect(.regular.interactive(), in: .capsule)
                        .glassEffectUnion(id: text, namespace: nameSpace)
                }
        })
    }
    
    // MARK: - SystemSetting
    /// 환경 설정 내부 메뉴 버튼
    /// - Parameters:
    ///   - text: 메뉴 버튼 텍스트
    ///   - role: 버튼 역할
    ///   - action: 버튼 액션
    /// - Returns: 내부 메뉴 버튼 반환
    private func generateSystemSetting(_ text: String, role: ButtonRole?, action: @escaping () -> Void) -> some View {
        Button(role: role, action: {
            action()
        }, label: {
            Text(text)
                .font(.b3)
                .padding(SideBarConstants.menuPadding)
        })
    }
    
    /// 내부 메뉴 버튼 액션
    /// - Parameter menu: 메뉴 버튼
    private func systemAction(_ menu: SystemSettingType) {
        switch menu {
        case .inquiry:
            viewModel.isShowInquiry.toggle()
        case .logout:
            Task {
                viewModel.logout()
                await appFlow.logout()
            }
        case .withdraw:
            viewModel.deleteAlertPrompt {
                Task {
                    await appFlow.logout()
                }
            }
        }
    }
}

#Preview {
    SideBarView(viewModel: .init(container: DIContainer()))
}
