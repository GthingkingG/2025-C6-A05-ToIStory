//
//  ToolBarCollection.swift
//  Findew
//
//  Created by Apple Coding machine on 11/8/25.
//

import SwiftUI

struct ToolBarCollection {
    
    struct RefreshText: ToolbarContent {
        let text: String
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .bottomBar, content: {
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.gray03)
                    .frame(width: 50)
                    .padding(.horizontal, 5)
            })
        }
    }
    
    struct RefreshButton: ToolbarContent {
        let action: () -> Void
        var tintColor: Color = .blue02
        var isDisabled: Bool = false
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .bottomBar, content: {
                withAnimation {
                    Button(action: {
                        action()
                    }, label: {
                        Image(systemName: "arrow.clockwise")
                    })
                    .tint(tintColor)
                    .disabled(isDisabled)
                }
            })
        }
    }
    
    struct CancellButton: ToolbarContent {
        let action: () -> Void
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .bottomBar, content: {
                Button(role: .cancel, action: {
                    withAnimation {
                        action()
                    }
                })
            })
        }
    }
    
    struct ReeportCancell: ToolbarContent {
        let action: () -> Void
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(role: .cancel, action: {
                    withAnimation {
                        action()
                    }
                })
            })
        }
    }
    
    struct AddButton: ToolbarContent {
        let action: () -> Void
        var icon: String = "plus"
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .topBarLeading, content: {
                Button(action: {
                    action()
                }, label: {
                    Image(systemName: icon)
                })
            })
        }
    }
    
    struct EditButton: ToolbarContent {
        @Binding var editMode: EditMode
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    Task {
                        withAnimation {
                            editMode = .active
                        }
                    }
                }, label: {
                    Image(systemName: "circle.grid.2x2.topleft.checkmark.filled")
                        .tint(.black)
                })
            }
        }
    }
    
    struct TrashButton: ToolbarContent {
        @Binding var editMode: EditMode
        let action: () -> Void
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    Task {
                        withAnimation {
                            action()
                            editMode = .inactive
                        }
                    }
                }, label: {
                    Image(systemName: "trash")
                        .renderingMode(.template)
                        .foregroundStyle(.red)
                })
            }
        }
    }
    
    struct DeviceReportButton: ToolbarContent {
        @Binding var selectedMode: Bool
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    Task {
                        withAnimation {
                            selectedMode = true
                        }
                    }
                }, label: {
                    Text("기기 신고")
                        .font(.b3)
                        .foregroundStyle(.red02)
                })
            })
        }
    }
    
    struct SendReportButton: ToolbarContent {
        @Binding var selectedMode: Bool
        let isAvailable: Bool
        let action: () -> Void
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    Task {
                        withAnimation {
                            action()
                            selectedMode.toggle()
                        }
                    }
                }, label: {
                    Text("보내기")
                        .font(.b3)
                        .foregroundStyle(isAvailable ? .black : .gray03)
                })
                .disabled(!isAvailable)
            })
        }
    }
}

extension ToolBarCollection {
    struct PatientManagementToolbar: ToolbarContent {
        @Binding var editMode: EditMode
        let refreshText: String
        let refresh: () -> Void
        let add: () -> Void
        let trash: () -> Void
        let cancell: () -> Void
        
        var body: some ToolbarContent {
            if editMode.isEditing {
                CancellButton(action: cancell)
                TrashButton(editMode: $editMode, action: trash)
            } else {
                AddButton(action: add)
                RefreshText(text: refreshText)
                RefreshButton(action: refresh)
                EditButton(editMode: $editMode)
            }
        }
    }
    
    struct DeviceManagementToolbar: ToolbarContent {
        @Binding var selectedMode: Bool
        let isAvailable: Bool
        let send: () -> Void
        let cancel: () -> Void
        
        var body: some ToolbarContent {
            if selectedMode {
                ReeportCancell(action: cancel)
                SendReportButton(selectedMode: $selectedMode, isAvailable: isAvailable, action: send)
            } else {
                DeviceReportButton(selectedMode: $selectedMode)
            }
        }
    }
}
