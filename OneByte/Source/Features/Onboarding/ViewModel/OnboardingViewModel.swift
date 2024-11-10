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
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving mainGoal: \(error.localizedDescription)")
        }
    }
    
//    func updateSubGoal(subGoal: SubGoal, modelContext: ModelContext, newTitle: String, newMemo: String) {
//        updateService.updateSubGoal(
//            subGoal: subGoal,
//            modelContext: modelContext,
//            newTitle: newTitle,
//            newMemo: newMemo
//        )
//
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error saving subGoal: \(error.localizedDescription)")
//        }
//    }
    
    func updateSubGoalTitle(subGoalID: Int, newTitle: String) {
            guard let subGoal = mainGoals.first?.subGoals.first(where: { $0.id == subGoalID }) else {
                print("Error: subGoal with ID \(subGoalID) not found.")
                return
            }
            
            updateService.updateSubGoal(
                subGoal: subGoal,
                modelContext: modelContext,
                newTitle: newTitle,
                newMemo: subGoal.memo
            )
            
            do {
                try modelContext.save()
            } catch {
                print("Error saving subGoal: \(error.localizedDescription)")
            }
        }
    
    // SwiftData에 저장된 전체 데이터 출력
    func printAllData() {
        print("Main Goals:")
        for mainGoal in mainGoals {
            print("MainGoal ID: \(mainGoal.id), Title: \(mainGoal.title), Year: \(mainGoal.goalYear)")
            
            let relatedSubGoals = subGoals.filter { $0.mainGoalId == mainGoal.id }
            print("  Sub Goals for MainGoal \(mainGoal.id):")
            for subGoal in relatedSubGoals {
                print("    SubGoal ID: \(subGoal.id), Title: \(subGoal.title), Memo: \(subGoal.memo)")
                
                let relatedDetailGoals = detailGoals.filter { $0.subGoalId == subGoal.id }
                print("      Detail Goals for SubGoal \(subGoal.id):")
                for detailGoal in relatedDetailGoals {
                    print("        DetailGoal ID: \(detailGoal.id), Title: \(detailGoal.title), Memo: \(detailGoal.memo), Achieved: \(detailGoal.isAchieved)")
                }
            }
        }
    }
}
