//
//  UseCase.swift
//  OneByte
//
//  Created by 이상도 on 10/29/24.
//

import Foundation
import SwiftData

protocol CreateGoalUseCase {
    func createMainGoal(id: Int, title: String, isAchieved: Bool, goalYear: Int, createdTime: Date, modifiedTime: Date, subGoals: [SubGoal]) -> MainGoal
    func createSubGoal(id: Int, title: String, memo: String, isAchieved: Bool, createdTime: Date, modifiedTime: Date, mainGoalId: Int, detailGoals: [DetailGoal]) -> SubGoal
    func createDetailGoal(id: Int, title: String, memo: String, isAchieved: Bool, createdTime: Date, modifiedTime: Date, subGoalId: Int) -> DetailGoal
    func saveGoalsFromJSON(json: [String: Any], modelContext: ModelContext)
}

protocol UpdateGoalUseCase {
    func updateMainGoal(id: UUID, newTitle: String, isAchieved: Bool) -> MainGoal?
    func updateSubGoal(id: UUID, newTitle: String, isAchieved: Bool) -> SubGoal?
    func updateDetailGoal(id: UUID, newTitle: String, isAchieved: Bool) -> DetailGoal?
}

protocol ReadGoalUseCase {
    func readMainGoal(id: UUID) -> MainGoal
    func readSubGoals(for mainGoalID: UUID) -> [SubGoal]
    func readDetailGoals(for subGoalID: UUID) -> [DetailGoal]
}
