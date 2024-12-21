//
//  DayButton.swift
//  OneByte
//
//  Created by 트루디 on 11/27/24.
//

import SwiftUI
// 요일 버튼 컴포넌트
struct DayButton: View {
    let title: String
    @Binding var isSelected: Bool
    @Binding var isModified: Bool
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            isModified = true
        }) {
            Text(title)
                .font(.setPretendard(weight: .medium, size: 17))
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.my538F53 : Color.myCFCFCF)
                .clipShape(Circle())
        }
    }
}
