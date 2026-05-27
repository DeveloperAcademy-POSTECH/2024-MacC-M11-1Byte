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
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let todayGoals = viewModel.filterTodayGoals(from: mainGoals)
        let yesterdayGoals = viewModel.filterCarryoverGoals(from: mainGoals)
        let allDetailGoals = viewModel.isAllDetailGoalTitlesEmpty(from: mainGoals)
        let yesterdayItems = viewModel.displayItems(for: yesterdayGoals, in: mainGoals)
        let morningItems = viewModel.displayItems(for: viewModel.filterMorning(from: todayGoals), in: mainGoals)
        let afternoonItems = viewModel.displayItems(for: viewModel.filterAfternoon(from: todayGoals), in: mainGoals)
        let eveningItems = viewModel.displayItems(for: viewModel.filterEvening(from: todayGoals), in: mainGoals)
        let nightItems = viewModel.displayItems(for: viewModel.filterNight(from: todayGoals), in: mainGoals)
        let freeItems = viewModel.displayItems(for: viewModel.filterFree(from: todayGoals), in: mainGoals)
        
        ScrollView {
            VStack(spacing: 12) {
                // 오늘의 루틴이 비어있는데
                if todayGoals.isEmpty && yesterdayGoals.isEmpty {
                    if allDetailGoals { // 전체 루틴모두 비어있을때
                        VStack(spacing: 0) {
                            Image("Turtle_Empty")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 101, maxHeight: 133)
                            Text("아직 루틴이 없어요!")
                                .font(.setPretendard(weight: .semiBold, size: 16))
                                .kerning(0.02)
                                .padding(.top, 16)
                            Text("나의 목표에서 루틴을 추가해보세요")
                                .font(.setPretendard(weight: .medium, size: 14))
                                .foregroundStyle(.my878787)
                                .padding(.top, 1)
                        }
                        .padding(.top, 114)
                    } else { // 오늘의 루틴만 없을때
                        VStack(spacing: 0) {
                            Image("Turtle_Empty2")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 122, maxHeight: 120)
                            Text("오늘 수행할 루틴이 없어요")
                                .font(.setPretendard(weight: .semiBold, size: 16))
                                .padding(.top, 19)
                                .kerning(0.02)
                            Text("오늘 하루는 재정비하고 내일을 준비해봐요")
                                .font(.setPretendard(weight: .medium, size: 14))
                                .foregroundStyle(.my878787)
                                .padding(.top, 1)
                        }
                        .padding(.top, 125)
                    }
                } else { // 오늘 또는 어제 체크 가능한 루틴이 있을때
                    if !yesterdayItems.isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Evening", routineTimeType: "어제 루틴")
                            .padding(.top, 12)

                        ForEach(yesterdayItems) { item in
                            TodayRoutineCell(
                                mainGoal: item.mainGoal,
                                allMainGoals: mainGoals,
                                detailGoal: item.detailGoal,
                                subGoalTitle: item.subGoalTitle,
                                viewModel: viewModel,
                                modelContext: modelContext,
                                clovers: clovers,
                                targetDate: yesterdayDate
                            )
                        }
                    }

                    // 아침 루틴 섹션
                    if !morningItems.isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Morning", routineTimeType: "아침 루틴")
                            .padding(.top, 12)
                        
                        ForEach(morningItems) { item in
                            TodayRoutineCell(
                                mainGoal: item.mainGoal,
                                allMainGoals: mainGoals,
                                detailGoal: item.detailGoal,
                                subGoalTitle: item.subGoalTitle,
                                viewModel: viewModel,
                                modelContext: modelContext,
                                clovers: clovers,
                                targetDate: Date()
                            )
                        }
                    }
                    // 점심 루틴 섹션
                    if !afternoonItems.isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Afternoon", routineTimeType: "점심 루틴")
                            .padding(.top, 12)
                        
                        ForEach(afternoonItems) { item in
                            TodayRoutineCell(
                                mainGoal: item.mainGoal,
                                allMainGoals: mainGoals,
                                detailGoal: item.detailGoal,
                                subGoalTitle: item.subGoalTitle,
                                viewModel: viewModel,
                                modelContext: modelContext,
                                clovers: clovers,
                                targetDate: Date()
                            )
                        }
                    }
                    
                    // 저녁 루틴 섹션
                    if !eveningItems.isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Evening", routineTimeType: "저녁 루틴")
                            .padding(.top, 12)
                        
                        ForEach(eveningItems) { item in
                            TodayRoutineCell(
                                mainGoal: item.mainGoal,
                                allMainGoals: mainGoals,
                                detailGoal: item.detailGoal,
                                subGoalTitle: item.subGoalTitle,
                                viewModel: viewModel,
                                modelContext: modelContext,
                                clovers: clovers,
                                targetDate: Date()
                            )
                        }
                    }
                    
                    // 밤 루틴 섹션
                    if !nightItems.isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Night", routineTimeType: "자기 전 루틴")
                            .padding(.top, 12)
                        
                        ForEach(nightItems) { item in
                            TodayRoutineCell(
                                mainGoal: item.mainGoal,
                                allMainGoals: mainGoals,
                                detailGoal: item.detailGoal,
                                subGoalTitle: item.subGoalTitle,
                                viewModel: viewModel,
                                modelContext: modelContext,
                                clovers: clovers,
                                targetDate: Date()
                            )
                        }
                    }
                    
                    // 자유 루틴 섹션
                    if !freeItems.isEmpty {
                        TodayRoutineTypeHeaderView(routineimage: "Routine_Free", routineTimeType: "자율 루틴")
                            .padding(.top, 12)
                        
                        ForEach(freeItems) { item in
                            TodayRoutineCell(
                                mainGoal: item.mainGoal,
                                allMainGoals: mainGoals,
                                detailGoal: item.detailGoal,
                                subGoalTitle: item.subGoalTitle,
                                viewModel: viewModel,
                                modelContext: modelContext,
                                clovers: clovers,
                                targetDate: Date()
                            )
                        }
                    }
                }
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 32)
        }
        .background(.myFFFAF4)
        .onAppear {
            // 오늘의 루틴 화면 진입 시 위젯 스냅샷을 최신 상태로 갱신
            viewModel.syncWidgetSnapshot(mainGoals: mainGoals)
        }
        .onChange(of: mainGoals.count) { _, _ in
            viewModel.syncWidgetSnapshot(mainGoals: mainGoals)
        }
    }
}
