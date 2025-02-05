//
//  AchievedRow.swift
//  OneByte
//
//  Created by 이상도 on 11/15/24.
//

import SwiftUI

struct AchievedRow: View {
    
    @Binding var isAppearAchieved: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("달성 표시하기")
                    .font(.setPretendard(weight: .semiBold, size: 16))
                Text("활성화 시 메인뷰에서 달성 여부를 편하게 볼 수 있어요.")
                    .font(.setPretendard(weight: .medium, size: 12))
                    .foregroundStyle(Color.my566959)
            }
            Spacer()
            Toggle("", isOn: $isAppearAchieved)
                .labelsHidden()
        }
        .padding()
        
    }
}

#Preview {
    AchievedRow(isAppearAchieved: .constant(false))
}
