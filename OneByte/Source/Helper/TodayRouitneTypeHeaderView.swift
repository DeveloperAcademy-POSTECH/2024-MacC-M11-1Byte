//
//  TodayRouitneTypeHeaderView.swift
//  OneByte
//
//  Created by 이상도 on 11/20/24.
//

import SwiftUI

// MARK: 오늘의 루틴 탭에서 오전루틴/오후루틴/자유루틴 구분 View
struct TodayRoutineTypeHeaderView: View {
    
    let routineimage: String
    let routineTimeType: String
    
    var body: some View {
        HStack {
            Image(routineimage)
                .frame(width: 24, height: 24)
                .foregroundStyle(.my566956)
            
            Text(routineTimeType)
                .font(.setPretendard(weight: .bold, size: 18))
                .foregroundStyle(.my566956)
            Spacer()
        }
    }
}

#Preview {
    TodayRoutineTypeHeaderView(routineimage: "star.fill", routineTimeType: "오전 루틴")
}
