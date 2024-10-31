//
//  UseCase.swift
//  OneByte
//
//  Created by 이상도 on 10/29/24.
//

import Foundation

protocol CreateGoalUseCase {
    func createMainGoal(title: String, isAchieved: Bool) -> MainGoal
    func createSubGoal(mainGoalID: UUID, title: String, isAchieved: Bool) -> SubGoal?
    func createDetailGoal(subGoalID: UUID, title: String, isAchieved: Bool) -> DetailGoal
}

protocol UpdateGoalUseCase {
    func updateMainGoal(id: UUID, newTitle: String, isAchieved: Bool) -> MainGoal
    func updateSubGoal(id: UUID, newTitle: String, isAchieved: Bool) -> SubGoal
    func updateDetailGoal(id: UUID, newTitle: String, isAchieved: Bool) -> DetailGoal
}

protocol ReadGoalUseCase {
    func readMainGoal(id: UUID) -> MainGoal
    func readSubGoals(for mainGoalID: UUID) -> [SubGoal]
    func readDetailGoals(for subGoalID: UUID) -> [DetailGoal]
}
