//
//  WeekRoutineView.swift
//  OneByte
//
//  Created by 이상도 on 12/20/24.
//

import SwiftUI

struct WeekRoutineView : View {
    
    @State private var isInfoVisible: Bool = false // 팝업 표시 상태
    
    var tapType : tapInfo
    var subGoal: SubGoal
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Image(tapType.colorClover)
                            .resizable()
                            .frame(width: 29, height: 29)
                            .clipShape(Circle())
                        
                        Text(subGoal.title == "" ? "서브목표가 비어있어요." : subGoal.title)
                            .font(.Pretendard.Bold.size18)
                            .foregroundStyle(.my2B2B2B)
                        Spacer()
                        Image(systemName: "questionmark.circle")
                            .bold()
                            .foregroundStyle(.myB4A99D)
                            .frame(width:20, height: 20)
                            .onTapGesture {
                                isInfoVisible = true
                            }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 10) { // cell 사이 간격
                        // 빈 제목이 아닌 DetailGoal만 표시
                        ForEach(subGoal.detailGoals.filter { !$0.title.isEmpty }, id: \.id) { detailGoal in
                            WeekAchieveCell(detailGoal: detailGoal)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .frame(maxWidth: .infinity)
            
            // 팝업뷰
            if isInfoVisible {
                Image("CloverPopup")
                    .resizable()
                    .frame(width: 162, height: 198)
                    .transition(.opacity.combined(with: .scale)) // 부드러운 애니메이션
                    .position(x: UIScreen.main.bounds.width - 81, y: 125)
                    .onTapGesture {
                        isInfoVisible = false
                    }
            }
        }
        .onTapGesture {
            isInfoVisible = false
        }
    }
}
