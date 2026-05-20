//
//  PatientsContextMenu.swift
//  Findew
//
//  Created by Apple Coding machine on 11/5/25.
//

import SwiftUI

enum PatientsContextMenu: String, CaseIterable {
    case edit = "편집"
    case detail = "상세보기"
    case delete = "삭제"

    var title: String { rawValue }

    var iconName: String {
        switch self {
        case .edit:
            return "pencil"
        case .detail:
            return "person"
        case .delete:
            return "trash"
        }
    }

    var role: ButtonRole? {
        switch self {
        case .edit, .detail:
            return nil
        case .delete:
            return .destructive
        }
    }
    
    var color: Color {
        switch self {
        case .delete:
            return .red
        default:
            return .black
        }
    }
}
