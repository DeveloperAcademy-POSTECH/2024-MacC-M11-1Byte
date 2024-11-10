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
    
    // 전체 데이터 생성
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }
    
    // MainGoal 업데이트
    func updateMainGoal(mainGoals: [MainGoal], userMainGoal: String, modelContext: ModelContext) {
        guard let mainGoal = mainGoals.first else {
            print("Error: mainGoal이 nil입니다.")
            return
        }
        
        updateService.updateMainGoal(
            mainGoal: mainGoal,
            modelContext: modelContext,
            id: mainGoal.id,
            newTitle: userMainGoal,
            newGoalYear: Calendar.current.component(.year, from: Date())
        )
    }
    
    // SubGoal 업데이트 ( MainGoal을 찾아서, Subgoal Update )
    func updateSubGoalTitle(subGoalID: Int, newTitle: String, modelContext: ModelContext) {
        guard let subGoal = mainGoals.first?.subGoals.first(where: { $0.id == subGoalID }) else {
            print("Error: SubGoal with ID \(subGoalID) not found.")
            return
        }
        
        updateService.updateSubGoal(
            subGoal: subGoal,
            modelContext: modelContext,
            newTitle: newTitle,
            newMemo: subGoal.memo
        )
    }
    
    // DetailGoal 업데이트 ( 특정 SubGoal과 DetailGoal을 찾아 업데이트 ) 
    func updateTargetDetailGoal(subGoalID: Int, detailGoalID: Int, newTitle: String, newMemo: String, isAchieved: Bool) {
        guard let targetSubGoal = subGoals.first(where: { $0.id == subGoalID }), // Subgoal id = 1번을 찾아서,
              let targetDetailGoal = targetSubGoal.detailGoals.first(where: { $0.id == detailGoalID }) // 있으면 id = 1 DetailGoal을 찾음
        else {
            print("Error: DetailGoal with ID \(detailGoalID) not found in SubGoal \(subGoalID).")
            return
        }
        
        updateService.updateDetailGoal( // 2가지 조건을 만족하면 업데이트 실행 !
            detailGoal: targetDetailGoal,
            modelContext: modelContext,
            newTitle: newTitle,
            newMemo: newMemo,
            isAchieved: isAchieved
        )
    }
    
}
