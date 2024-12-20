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
                            Text("나의 목표에서 루틴을 추가해보세요")
                                .font(.Pretendard.Medium.size14)
                                .foregroundStyle(.my878787)
                                .padding(.top, 1)
                        }
                        .padding(.top, 114)
                    } else { // 오늘의 루틴만 없을때
                        VStack(spacing: 0) {
                            Image("Turtle_Empty2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 122, height: 120)
                            Text("오늘 수행할 루틴이 없어요")
                                .font(.Pretendard.SemiBold.size16)
                                .padding(.top,19)
                                .kerning(0.02)
                            Text("오늘 하루는 재정비하고 내일을 준비해봐요")
                                .font(.Pretendard.Medium.size14)
                                .foregroundStyle(.my878787)
                                .padding(.top, 1)
                        }
                        .padding(.top, 125)
                    }
                } else { // 오늘의 루틴이 있을때
                    // 아침 루틴 섹션
                    if !viewModel.filterMorning(from: todayGoals).isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Morning", routineTimeType: "아침 루틴")
                            .padding(.top, 12)
                        
                        if let mainGoal = mainGoals.first {
                            ForEach(viewModel.filterMorning(from: todayGoals), id: \.id) { detailGoal in
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
                    // 점심 루틴 섹션
                    if !viewModel.filterAfternoon(from: todayGoals).isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Afternoon", routineTimeType: "점심 루틴")
                            .padding(.top, 12)
                        
                        if let mainGoal = mainGoals.first {
                            ForEach(viewModel.filterAfternoon(from: todayGoals), id: \.id) { detailGoal in
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
                    
                    // 저녁 루틴 섹션
                    if !viewModel.filterEvening(from: todayGoals).isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Evening", routineTimeType: "저녁 루틴")
                            .padding(.top, 12)
                        
                        if let mainGoal = mainGoals.first {
                            ForEach(viewModel.filterEvening(from: todayGoals), id: \.id) { detailGoal in
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
                    
                    // 밤 루틴 섹션
                    if !viewModel.filterNight(from: todayGoals).isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Night", routineTimeType: "자기 전 루틴")
                            .padding(.top, 12)
                        
                        if let mainGoal = mainGoals.first {
                            ForEach(viewModel.filterNight(from: todayGoals), id: \.id) { detailGoal in
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
                    if !viewModel.filterFree(from: todayGoals).isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Free", routineTimeType: "자율 루틴")
                            .padding(.top, 12)
                        
                        if let mainGoal = mainGoals.first {
                            ForEach(viewModel.filterFree(from: todayGoals), id: \.id) { detailGoal in
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
            .padding([.top, .horizontal])
            .padding(.bottom, 32)
        }
        .background(.myFFFAF4)
    }
}
