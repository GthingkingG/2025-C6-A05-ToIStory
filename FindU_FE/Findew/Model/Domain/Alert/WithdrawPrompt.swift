//
//  WithdrawPromprt.swift
//  Findew
//
//  Created by Apple Coding machine on 11/21/25.
//

import Foundation
import SwiftUI

@Observable
class WithdrawPrompt: Identifiable {
    var id: UUID = .init()
    let title: String
    let message: String?
    let placeholder: String = "비밀번호를 입력해주세요"
    let submitAction: ((String) -> Void)?
    
    var password: String = ""
    
    init(
        title: String,
        message: String?,
        submitAction: ((String) -> Void)?,
        password: String
    ) {
        self.title = title
        self.message = message
        self.submitAction = submitAction
        self.password = password
    }
}
