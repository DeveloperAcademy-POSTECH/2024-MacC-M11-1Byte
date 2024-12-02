//
//  DaysCycleButton.swift
//  OneByte
//
//  Created by 이상도 on 12/1/24.
//

import SwiftUI

// 루틴 실행날짜 고르는 Button Cell
struct DaysCycleCellButton: View {
    
    let day: String
    @Binding var isSelected: Bool
    var onChange: () -> Void
    
    var body: some View {
        Button {
            isSelected.toggle()
            onChange()
        } label: {
            Text(day)
                .font(.Pretendard.Medium.size17)
                .foregroundStyle(isSelected ? .white : .white)
                .frame(width: 36, height: 36)
                .background(isSelected ? .my95D895 : .myCFCFCF)
                .clipShape(Circle())
        }
    }
}
