//
//  OnboardingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

class OnboardingViewModel: ObservableObject {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query var mainGoals: [MainGoal]
    @Query var subGoals: [SubGoal]
    @Query var detailGoals: [DetailGoal]
    
    private let createService: CreateGoalUseCase
    private let updateService: UpdateGoalUseCase
    
    init(createService: CreateGoalUseCase, updateService: UpdateGoalUseCase ) {
        self.createService = createService
        self.updateService = updateService
    }
    
    // Goals 전체 데이터 생성
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }
    
    // MainGoal 업데이트
    func updateMainGoal(mainGoals: [MainGoal], modelContext: ModelContext, userMainGoal: String, cloverState: Int ) {
        guard let mainGoal = mainGoals.first else {
            print("Error: mainGoal이 nil입니다.")
            return
        }
        
        updateService.updateMainGoal(
            mainGoal: mainGoal,
            id: mainGoal.id,
            newTitle: userMainGoal,
            cloverState: cloverState
        )
    }
    
    // SubGoal 업데이트
    func updateSubGoal(subGoal: SubGoal, modelContext: ModelContext, newTitle: String, leafState: Int) {
        updateService.updateSubGoal(
            subGoal: subGoal,
            newTitle: newTitle,
            leafState: leafState
        )
    }
    
    // SubGoal 업데이트
    func updateDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool) {
        updateService.updateDetailGoal(detailGoal: detailGoal, title: newTitle, memo: newMemo, achieveCount: achieveCount, achieveGoal: achieveGoal, alertMon: alertMon, alertTue: alertTue, alertWed: alertWed, alertThu: alertThu, alertFri: alertFri, alertSat: alertSat, alertSun: alertSun, isRemind: isRemind, remindTime: remindTime, achieveMon: achieveMon, achieveTue: achieveTue, achieveWed: achieveWed, achieveThu: achieveThu, achieveFri: achieveFri, achieveSat: achieveFri, achieveSun: achieveSun)
    }
}
