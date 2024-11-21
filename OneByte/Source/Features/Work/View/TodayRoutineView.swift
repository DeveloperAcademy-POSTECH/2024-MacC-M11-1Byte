//
//  TodayRoutineView.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI
import SwiftData

struct TodayRoutineView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var mainGoals: [MainGoal] // 모든 MainGoal 데이터를 쿼리
    @State var viewModel = TodayRoutineViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // 데이터 업데이트
                let todayGoals = viewModel.filterTodayGoals(from: mainGoals)
                
                // 오전 루틴 섹션
                if !viewModel.morningGoals(from: todayGoals).isEmpty {
                    TodayRoutineTypeHeaderView(routineimage: "sun.max.fill", routineTimeType: "오전 루틴")
                    
                    if let mainGoal = mainGoals.first { // MainGoal 가져오기
                        ForEach(viewModel.morningGoals(from: todayGoals), id: \.id) { detailGoal in
                            TodayRoutineCell(mainGoal: mainGoal, detailGoal: detailGoal, viewModel: viewModel, modelContext: modelContext) // mainGoal 전달
                        }
                    }
                }
                
                // 오후 루틴 섹션
                if !viewModel.afternoonGoals(from: todayGoals).isEmpty {
                    TodayRoutineTypeHeaderView(routineimage: "moon.fill", routineTimeType: "오후 루틴")
                        .padding(.top)
                    
                    if let mainGoal = mainGoals.first { // MainGoal 가져오기
                        ForEach(viewModel.afternoonGoals(from: todayGoals), id: \.id) { detailGoal in
                            TodayRoutineCell(mainGoal: mainGoal, detailGoal: detailGoal, viewModel: viewModel, modelContext: modelContext)
                        }
                    }
                }
                
                // 자유 루틴 섹션
                if !viewModel.freeGoals(from: todayGoals).isEmpty {
                    TodayRoutineTypeHeaderView(routineimage: "star.fill", routineTimeType: "자유 루틴")
                        .padding(.top)
                    
                    if let mainGoal = mainGoals.first { // MainGoal 가져오기
                        ForEach(viewModel.freeGoals(from: todayGoals), id: \.id) { detailGoal in
                            TodayRoutineCell(mainGoal: mainGoal, detailGoal: detailGoal, viewModel: viewModel, modelContext: modelContext)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.myFFFAF4)
    }
}

struct TodayRoutineCell: View {
    
    let mainGoal: MainGoal
    let detailGoal: DetailGoal
    let viewModel: TodayRoutineViewModel
    let modelContext: ModelContext
    
    var body: some View {
        HStack(spacing: 15) {
            // 알림 시간 있으면 표시
            if let remindTime = detailGoal.remindTime {
                Text(remindTime.timeString)
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(detailGoal.isAchievedToday ? Color.my727272.opacity(0.6) : Color.my727272)
                    .padding(.bottom)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(detailGoal.title)
                    .font(.Pretendard.SemiBold.size16)
                    .foregroundStyle(detailGoal.isAchievedToday ? Color.my2B2B2B.opacity(0.7) : Color.my2B2B2B)
                    .strikethrough(detailGoal.isAchievedToday)
                
                Text(detailGoal.memo) // 🚧🚧🚧 Subgoal을 입력해야만 DetailGoal이 입력가능한 위계가 생기면, detailGoal에 해당하는 Subgoal title 띄워지게  
                    .font(.Pretendard.SemiBold.size12)
                    .foregroundStyle(detailGoal.isAchievedToday ? Color.my428142.opacity(0.7) : Color.my428142)
                    .foregroundStyle(Color.my428142)
            }
            Spacer()
            
            Button {
                print("⚠️[DEBUG] 현재 완료 체크하는 id : \(detailGoal.id)")
                print("⚠️[DEBUG] 현재 완료 체크하는 Title : \(detailGoal.title)")
                print("⚠️[DEBUG] 오늘의 루틴 성취 완료 체크 전 : \(detailGoal.isAchievedToday)")
                viewModel.toggleAchievement(for: detailGoal, in: mainGoal, context: modelContext)
                print("⚠️[DEBUG] 오늘의 루틴 성취 완료 체크 후 : \(detailGoal.isAchievedToday)")
                print("⚠️[DEBUG] MainGoal의 CloverState : \(mainGoal.cloverState)")
            } label: {
                Image(detailGoal.isAchievedToday ? "AchieveClover1" : "RoutineCheck")
                    .resizable()
            }
            .frame(width: 32, height: 32)
        }
        .frame(height: 69)
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "F0E8DF"), lineWidth: 1)
        )
    }
}

extension DetailGoal {
    //  오늘의 루틴 완료 여부를 확인 및 UI 업데이트
    var isAchievedToday: Bool {
           let todayIndex = Date().mondayBasedIndex()
           switch todayIndex {
           case 0: return achieveMon
           case 1: return achieveTue
           case 2: return achieveWed
           case 3: return achieveThu
           case 4: return achieveFri
           case 5: return achieveSat
           case 6: return achieveSun
           default: return false
           }
       }
}
