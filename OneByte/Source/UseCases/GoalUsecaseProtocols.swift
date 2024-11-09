//
//  UseCase.swift
//  OneByte
//
//  Created by 이상도 on 10/29/24.
//

import Foundation
import SwiftData

protocol CreateGoalUseCase {
    func createGoals(modelContext: ModelContext)
}

protocol UpdateGoalUseCase {
    func updateMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String, newGoalYear: Int)
    func updateSubGoal(subGoal: SubGoal, modelContext: ModelContext, newTitle: String, newMemo: String)
    func updateDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, newTitle: String, newMemo: String, isAchieved: Bool)
}

protocol ReadGoalUseCase {
    func readMainGoal(id: UUID) -> MainGoal
    func readSubGoals(for mainGoalID: UUID) -> [SubGoal]
    func readDetailGoals(for subGoalID: UUID) -> [DetailGoal]
}
