//
//  ClientUpdateService.swift
//  OneByte
//
//  Created by 이상도 on 10/30/24.
//

import Foundation
import SwiftData

class ClientUpdateService: UpdateGoalUseCase {
    // 업데이트할 데이터
    var mainGoals: [MainGoal]
    var subGoals: [SubGoal]
    var detailGoals: [DetailGoal]
    
    init(mainGoals: [MainGoal], subGoals: [SubGoal], detailGoals: [DetailGoal]) {
        self.mainGoals = mainGoals
        self.subGoals = subGoals
        self.detailGoals = detailGoals
    }
    
    func updateMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String, newGoalYear: Int) {
        mainGoal.title = newTitle
        mainGoal.goalYear = newGoalYear
    }
    
    func updateSubGoal(subGoal: SubGoal, modelContext: ModelContext, newTitle: String, newMemo: String) {
        subGoal.title = newTitle
        subGoal.memo = newMemo
    }
    
    func updateDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext,newTitle: String, newMemo: String, isAchieved: Bool) {
        detailGoal.title = newTitle
        detailGoal.memo = newMemo
        detailGoal.isAchieved = isAchieved
    }
}
