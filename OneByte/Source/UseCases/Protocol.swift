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
    func createNotification(detailGoal: DetailGoal, newTitle: String, selectedDays: [String])
}

protocol UpdateGoalUseCase {
    func updateMainGoal(mainGoal: MainGoal, id: Int, newTitle: String, cloverState: Int)
    func updateSubGoal(subGoal: SubGoal, newTitle: String, category: String)
    func updateDetailGoal(detailGoal: DetailGoal, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, isMorning: Bool, isAfternoon: Bool, isEvening: Bool, isNight: Bool, isFree: Bool)
}

protocol DeleteGoalUseCase {
    func deleteMainGoal(mainGoal: MainGoal)
    func deleteSubGoal(subGoal: SubGoal)
    func deleteDetailGoal(detailGoal: DetailGoal)
    func resetAllData(modelContext: ModelContext, mainGoal: MainGoal)
    func deleteSubDetailGoals(subGoal: SubGoal)
    func deleteNotification(detailGoal: DetailGoal)
}
