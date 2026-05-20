//
//  FindUTab.swift
//  Findew
//
//  Created by Apple Coding machine on 11/7/25.
//

import SwiftUI

struct FindUTab: View {
    // MARK: - Property
    @Environment(\.appFlow) var appFlow
    @Environment(\.container) var container
    @State var tabCase: TabCaseEnum = .location
    @Namespace var nameSpace
    @State private var previousTab: TabCaseEnum = .location
    @State var showSegment: Bool = true
    
    // MARK: - Constants
    fileprivate enum FindUTabConstant {
        static let labelSpacing: CGFloat = 8
        static let pickerPadding: CGFloat = 16
        static let pickerSize: CGFloat = 200
    }
    
    // MARK: - Body
    var body: some View {
        content(tabCase)
            .transition(.opacity)
            .animation(.easeInOut(duration: DefaultConstants.defaultAnimation), value: tabCase)
            .safeAreaInset(edge: .top, spacing: DefaultConstants.defaultVerticalPadding, content: {
                if showSegment {
                    Picker("", selection: $tabCase, content: {
                        ForEach(TabCaseEnum.allCases, id: \.rawValue) { tab in
                            label(tab)
                                .tag(tab)
                        }
                    })
                    .pickerStyle(.segmented)
                    .frame(width: FindUTabConstant.pickerSize)
                    .controlSize(.large)
                }
            })
    }
    
    /// 탭 내부 라벨
    /// - Parameter tab: 탭 타입
    /// - Returns: 탭 라벨 반환
    private func label(_ tab: TabCaseEnum) -> some View {
        Text(tab.rawValue)
            .fontWeight(.medium)
            .font(.headline)
        
    }
    
    /// 탭 내부 컨텐츠 뷰
    /// - Parameter tab: 탭 타입
    /// - Returns: 탭 뷰 반환
    @ViewBuilder
    private func content(_ tab: TabCaseEnum) -> some View {
        switch tabCase {
        case .location:
            PatientsTableView(container: container, showSegment: $showSegment)
                .id(tab)
        case .device:
            DeviceListView(container: container)
                .id(tab)
        }
    }
}

#Preview {
    FindUTab()
        .environment(AppFlow())
        .environment(DIContainer())
}

extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: super.intrinsicContentSize.height
        )
    }
}
