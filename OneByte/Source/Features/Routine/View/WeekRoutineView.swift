//
//  WeekRoutineView.swift
//  OneByte
//
//  Created by 이상도 on 12/20/24.
//

import SwiftUI

struct WeekRoutineView : View {
    
    @State var viewModel = AllRoutineViewModel()
    
    var tapType : tapInfo
    var subGoal: SubGoal
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Image(tapType.colorClover)
                            .resizable()
                            .frame(width: 29, height: 29)
                            .clipShape(Circle())
                        
                        Text(subGoal.title == "" ? "서브목표가 비어있어요." : subGoal.title)
                            .font(.setPretendard(weight: .bold, size: 18))
                            .foregroundStyle(.my2B2B2B)
                        Spacer()
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(.myB4A99D)
                            .frame(width:20, height: 20)
                            .onTapGesture {
                                viewModel.isInfoVisible.toggle()
                            }
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 20)
                    
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
            
            if viewModel.isInfoVisible {
                RoutinePopUpView(isInfoVisible: $viewModel.isInfoVisible)
                    .padding(.top, 30)
            }
        }
        .onTapGesture {
            viewModel.isInfoVisible = false
        }
    }
}
