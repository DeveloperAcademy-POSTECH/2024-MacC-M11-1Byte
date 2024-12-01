//
//  DaysCycleCell.swift
//  OneByte
//
//  Created by 이상도 on 12/1/24.
//

import SwiftUI

// 고른 루틴 실행날짜 Cell View
struct DaysCycleCell: View {
    
    let day: String
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack {
            Text(day)
                .font(.Pretendard.Medium.size14)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(.my6FB56F)
                .clipShape(Circle())
        }
    }
}
