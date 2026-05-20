//
//  ContactAlertPromprt.swift
//  Findew
//
//  Created by Apple Coding machine on 11/5/25.
//

import Foundation
import SwiftUI

@Observable
class ContactAlertPromprt: Identifiable {
    var id: UUID = .init()
    let type: ContactType
    let title: String
    let message: String?
    var emailPlaceholder: String = "이메일 주소"
    var contentPlaceholder: String = "내용을 입력해주세요"
    var submitAction: ((String, String?) -> Void)?

    // TextField 바인딩을 위한 속성
    var email: String = ""
    var content: String = ""

    init(
        type: ContactType,
        title: String,
        message: String?,
        emailPlaceholder: String = "이메일 주소",
        contentPlaceholder: String = "내용을 입력해주세요",
        submitAction: ((String, String?) -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.message = message
        self.emailPlaceholder = emailPlaceholder
        self.contentPlaceholder = contentPlaceholder
        self.submitAction = submitAction
    }
}
