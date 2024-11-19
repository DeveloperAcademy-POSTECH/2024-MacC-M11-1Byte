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
            Image(systemName: routineimage)
                .frame(width: 22, height: 22)
                .foregroundStyle(Color.my566956)
            
            Text(routineTimeType)
                .font(.Pretendard.Bold.size18)
                .foregroundStyle(Color.my566956)
            Spacer()
        }
    }
}

#Preview {
    TodayRoutineTypeHeaderView(routineimage: "star.fill", routineTimeType: "오전 루틴")
}
