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
    func updateMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String, cloverState: Int)
    func updateSubGoal(subGoal: SubGoal, modelContext: ModelContext, newTitle: String, leafState: Int)
    func updateDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool)
}

protocol DeleteGoalUseCase {
    func deleteMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String, cloverState: Int)
    func deleteSubGoal(subGoal: SubGoal, newTitle: String, leafState: Int)
    func deleteDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool)
    //    func deleteDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, newTitle: String, newMemo: String, isAchieved: Bool)
    func resetAllData(modelContext: ModelContext, mainGoal: MainGoal)
}
