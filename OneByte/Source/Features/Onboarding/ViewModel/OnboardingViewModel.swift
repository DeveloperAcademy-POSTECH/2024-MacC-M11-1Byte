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
    
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }
    
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
    
    func updateSubGoal(subGoal: SubGoal, modelContext: ModelContext, newTitle: String, newMemo: String) {
        updateService.updateSubGoal(
            subGoal: subGoal,
            modelContext: modelContext,
            newTitle: newTitle,
            newMemo: newMemo
        )
    }
    
}
