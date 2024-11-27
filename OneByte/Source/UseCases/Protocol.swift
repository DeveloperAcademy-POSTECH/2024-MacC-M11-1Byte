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
    func updateMainGoal(mainGoal: MainGoal, id: Int, newTitle: String, cloverState: Int)
    func updateSubGoal(subGoal: SubGoal, newTitle: String, leafState: Int, category: String, isCustomCategory: Bool)
    func updateDetailGoal(detailGoal: DetailGoal, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, timePeriod: String)
}

protocol DeleteGoalUseCase {
    func deleteMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String, cloverState: Int)
    func deleteSubGoal(subGoal: SubGoal, newTitle: String, leafState: Int, category: String, isCustomCategory: Bool)
    func deleteDetailGoal(detailGoal: DetailGoal, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, timePeriod: String)
    func resetAllData(modelContext: ModelContext, mainGoal: MainGoal)
}
