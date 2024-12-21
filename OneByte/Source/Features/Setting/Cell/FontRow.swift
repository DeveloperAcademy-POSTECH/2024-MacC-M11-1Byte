//
//  FontRow.swift
//  OneByte
//
//  Created by 이상도 on 11/15/24.
//

import SwiftUI


struct FontRow: View {
    
    var body: some View {
        HStack {
            Text("폰트 선택")
                .font(.setPretendard(weight: .semiBold, size: 16))
            Spacer()
        }
        .padding()
    }
}

#Preview {
    FontRow()
}
