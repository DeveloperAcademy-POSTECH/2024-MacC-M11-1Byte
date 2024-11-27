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
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(title)
                .font(.Pretendard.Medium.size17)
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.my538F53 : Color.myCFCFCF)
                .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle()) // 기본 효과 제거
    }
}

struct SelectTimeButton: View {
    let title: String
    @Binding var isSelected: Bool
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }, label: {
            Text(title)
                .font(.Pretendard.Medium.size12)
                .foregroundStyle(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 14)
                .background(isSelected ? Color.my538F53 : Color.myCFCFCF)
                .cornerRadius(34)
        })
    }
}
