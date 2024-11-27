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
    @Query var clovers: [Clover]
    @State var viewModel = TodayRoutineViewModel()
    
    var body: some View {
        let todayGoals = viewModel.filterTodayGoals(from: mainGoals)
        let allDetailGoals = viewModel.isAllDetailGoalTitlesEmpty(from: mainGoals)
        
        ScrollView {
            VStack(spacing: 12) {
                // 오늘의 루틴이 비어있는데
                if todayGoals.isEmpty {
                    if allDetailGoals { // 전체 루틴모두 비어있을때
                        VStack(spacing: 0) {
                            Image("Turtle_Empty")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 101, height: 133)
                            Text("아직 루틴이 없어요!")
                                .font(.Pretendard.SemiBold.size16)
                                .kerning(0.02)
                                .padding(.top, 16)
                            
                            Text("나의 목표에서 루틴을 추가해보세요.")
                                .font(.Pretendard.Medium.size14)
                                .foregroundStyle(.my878787)
                                .padding(.top, 1)
                        }
                        .padding(.top, 114)
                    } else {
                        VStack(spacing: 1) {
                            Text("오늘 수행할 루틴이 없어요")
                                .font(.Pretendard.SemiBold.size16)
                                .kerning(0.02)
                            Text("만다라트에서 루틴을 추가해보세요.")
                                .font(.Pretendard.Medium.size14)
                                .foregroundStyle(.my878787)
                        }
                        .padding(.top, 263) // 291-28
                    }
                } else { // 오늘의 루틴이 있을때
                    // 오전 루틴 섹션
                    if !viewModel.filterMorningGoals(from: todayGoals).isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "sun.max.fill", routineTimeType: "아침 루틴")
                        
                        if let mainGoal = mainGoals.first { // MainGoal 가져오기
                            ForEach(viewModel.filterMorningGoals(from: todayGoals), id: \.id) { detailGoal in
                                if let subGoal = mainGoal.subGoals.first(where: { $0.detailGoals.contains(detailGoal) }) {
                                    TodayRoutineCell(
                                        mainGoal: mainGoal,
                                        detailGoal: detailGoal,
                                        subGoalTitle: subGoal.title,
                                        viewModel: viewModel,
                                        modelContext: modelContext,
                                        clovers: clovers
                                    )
                                }
                            }
                        }
                    }
                    // 오후 루틴 섹션
                    if !viewModel.filterAfternoonGoals(from: todayGoals).isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "moon.fill", routineTimeType: "오후 루틴")
                            .padding(.top)
                        
                        if let mainGoal = mainGoals.first { // MainGoal 가져오기
                            ForEach(viewModel.filterAfternoonGoals(from: todayGoals), id: \.id) { detailGoal in
                                if let subGoal = mainGoal.subGoals.first(where: { $0.detailGoals.contains(detailGoal) }) {
                                    TodayRoutineCell(
                                        mainGoal: mainGoal,
                                        detailGoal: detailGoal,
                                        subGoalTitle: subGoal.title,
                                        viewModel: viewModel,
                                        modelContext: modelContext,
                                        clovers: clovers
                                    )
                                }
                            }
                        }
                    }
                    // 자유 루틴 섹션
                    if !viewModel.filterFreeGoals(from: todayGoals).isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "star.fill", routineTimeType: "자유 루틴")
                            .padding(.top)
                        
                        if let mainGoal = mainGoals.first { // MainGoal 가져오기
                            ForEach(viewModel.filterFreeGoals(from: todayGoals), id: \.id) { detailGoal in
                                if let subGoal = mainGoal.subGoals.first(where: { $0.detailGoals.contains(detailGoal) }) {
                                    TodayRoutineCell(
                                        mainGoal: mainGoal,
                                        detailGoal: detailGoal,
                                        subGoalTitle: subGoal.title,
                                        viewModel: viewModel,
                                        modelContext: modelContext,
                                        clovers: clovers
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 28)
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color.myFFFAF4)
    }
}

struct TodayRoutineCell: View {
    
    let mainGoal: MainGoal
    let detailGoal: DetailGoal
    let subGoalTitle: String
    let viewModel: TodayRoutineViewModel
    let modelContext: ModelContext
    let clovers: [Clover]
    
    var body: some View {
        HStack(spacing: 16) {
            // 알림 시간 있으면 표시
            if let remindTime = detailGoal.remindTime {
                Text(remindTime.timeString)
                    .font(.Pretendard.SemiBold.size14)
                    .foregroundStyle(detailGoal.isAchievedToday ? Color.my727272.opacity(0.6) : Color.my727272)
                    .padding(.bottom)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(detailGoal.title)
                    .font(.Pretendard.SemiBold.size16)
                    .foregroundStyle(detailGoal.isAchievedToday ? Color.my2B2B2B.opacity(0.7) : Color.my2B2B2B)
                    .strikethrough(detailGoal.isAchievedToday)
                
                Text(subGoalTitle) // 🚧🚧🚧 Subgoal을 입력해야만 DetailGoal이 입력가능한 위계가 생기면, detailGoal에 해당하는 Subgoal title 띄워지게
                    .font(.Pretendard.Medium.size14)
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
                viewModel.calculateCurrentWeekAndMonthWeek(mainGoal: mainGoal, clovers: clovers, context: modelContext)
            } label: {
                Image(detailGoal.isAchievedToday ? "Day7_Clover1" : "RoutineCheck")
                    .resizable()
            }
            .frame(width: 32, height: 32)
        }
        .frame(height: 64)
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
