//
//  NotPatients.swift
//  Findew
//
//  Created by Apple Coding machine on 11/7/25.
//

import SwiftUI

struct NotPatientsView: View {
    var body: some View {
        HStack {
            Text("등록된 환자가 없습니다.")
                .font(.title)
                .foregroundStyle(.gray03)
            
            Image(.noExistPatient)
        }
    }
}

#Preview {
    NotPatientsView()
}
