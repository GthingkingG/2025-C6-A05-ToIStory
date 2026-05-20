//
//  View+Alert.swift
//  Findew
//
//  Created by Apple Coding machine on 11/5/25.
//

import SwiftUI

extension View {
    func alertPrompt(item: Binding<AlertPrompt?>) -> some View {
        self.alert(
            item.wrappedValue?.title ?? "",
            isPresented: Binding(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            ),
            presenting: item.wrappedValue
        ) { alert in
            if let positiveBtnTitle = alert.positiveBtnTitle {
                Button(
                    positiveBtnTitle,
                    role: alert.isPositiveBtnDestructive ? .destructive : nil
                ) {
                    alert.positiveBtnAction?()
                }
            }
            
            if let negativeBtnTitle = alert.negativeBtnTitle {
                Button(negativeBtnTitle, role: .cancel) {
                    alert.negativeBtnAction?()
                }
            }
        } message: { alert in
            Text(alert.message)
        }
    }
    
    func drawPrompt(item: Binding<WithdrawPrompt?>) -> some View {
        self.alert(
            item.wrappedValue?.title ?? "",
            isPresented: Binding(
                get: { item.wrappedValue != nil },
                set: {if !$0 { item.wrappedValue = nil }}
            ),
            presenting: item.wrappedValue) { (alert: WithdrawPrompt) in
                TextField(alert.placeholder, text: Binding(
                    get: { item.wrappedValue?.password ?? "" },
                    set: { item.wrappedValue?.password = $0 }
                ), axis: .horizontal)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                Button("탈퇴", role: .destructive) {
                    alert.submitAction?(
                        item.wrappedValue?.password ?? ""
                    )
                }
                
                Button("취소", role: .cancel) {}
            } message: { (alert: WithdrawPrompt) in
                if let message = alert.message {
                    Text(message)
                }
            }
    }
}
