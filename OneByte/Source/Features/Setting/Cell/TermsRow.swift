//
//  TermsRow.swift
//  OneByte
//
//  Created by 이상도 on 11/15/24.
//

import SwiftUI

struct TermsRow: View {
    
    var body: some View {
        HStack {
            Text("이용 약관")
                .font(.setPretendard(weight: .semiBold, size: 16))
            Spacer()
        }
        .padding()
    }
}

#Preview {
    TermsRow()
}
