//
//  PrivacyPolicyRow.swift
//  OneByte
//
//  Created by 이상도 on 11/15/24.
//

import SwiftUI

struct PrivacyPolicyRow: View {
    
    var body: some View {
        HStack {
            Text("개인정보 처리 방침")
                .font(.setPretendard(weight: .semiBold, size: 16))
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PrivacyPolicyRow()
}
