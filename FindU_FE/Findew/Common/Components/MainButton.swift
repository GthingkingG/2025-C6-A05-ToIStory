//
//  MainButton.swift
//  Findew
//
//  Created by Apple Coding machine on 11/20/25.
//

import SwiftUI

struct MainButton: View {
    
    // MARK: - Property
    let action: () -> Void
    let label: String
    let fontColor: Color
    let tint: Color
    let disabled: Bool
    
    // MARK: - Init
    init(action: @escaping () -> Void, label: String, fontColor: Color, tint: Color, disabled: Bool) {
        self.action = action
        self.label = label
        self.fontColor = fontColor
        self.tint = tint
        self.disabled = disabled
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }, label: {
            Text(label)
                .font(.b3)
                .foregroundStyle(fontColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
        })
        .buttonStyle(.glassProminent)
        .tint(tint)
        .disabled(disabled)
    }
}
