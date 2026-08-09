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
    @Environment(\.scenePhase) private var scenePhase
    @Query var mainGoals: [MainGoal]
    @Query var clovers: [Clover]
    @State var viewModel = TodayRoutineViewModel()
    
    var body: some View {
        let yesterdayDate = viewModel.carryoverReferenceDate() ?? Date()
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
                if todayGoals.isEmpty && yesterdayGoals.isEmpty {
                    if allDetailGoals {
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
                    } else {
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
                } else {
                    if !todayGoals.isEmpty {
                        sectionTitle("오늘")
                            .padding(.top, 12)
                    }

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

                    if !yesterdayItems.isEmpty {
                        sectionTitle(
                            "어제",
                            lockMessage: viewModel.carryoverLockMessage(for: yesterdayDate)
                        )
                            .padding(.top, todayGoals.isEmpty ? 12 : 20)

                        TodayRoutineTypeHeaderView(routineimage: "Routine_Evening", routineTimeType: "어제 미완료 루틴")

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
                }
            }
            .padding([.top, .horizontal])
            .padding(.bottom, 32)
        }
        .background(.myFFFAF4)
        .onAppear {
            refreshWidgetState()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                refreshWidgetState()
            }
        }
        .onChange(of: mainGoals.count) { _, _ in
            viewModel.refreshNotificationSchedules(mainGoals: mainGoals)
            viewModel.syncWidgetSnapshot(mainGoals: mainGoals)
        }
    }

    private func refreshWidgetState() {
        viewModel.applyPendingWidgetToggles(mainGoals: mainGoals, clovers: clovers, context: modelContext)
        viewModel.refreshNotificationSchedules(mainGoals: mainGoals)
        viewModel.syncWidgetSnapshot(mainGoals: mainGoals)
    }

    private func sectionTitle(_ title: String, lockMessage: String? = nil) -> some View {
        HStack {
            Text(title)
                .font(.setPretendard(weight: .bold, size: 20))
                .foregroundStyle(.my2B2B2B)

            if let lockMessage {
                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                    Text(lockMessage)
                }
                .font(.setPretendard(weight: .medium, size: 12))
                .foregroundStyle(.my8E8E8E)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            }

            Spacer()
        }
    }
}
