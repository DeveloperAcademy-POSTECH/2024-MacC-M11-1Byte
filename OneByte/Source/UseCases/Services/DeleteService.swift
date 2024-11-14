//
//  DeleteService.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import Foundation
import SwiftData

class DeleteService: DeleteGoalUseCase {
    // 업데이트할 데이터
    var mainGoals: [MainGoal]
    var subGoals: [SubGoal]
    var detailGoals: [DetailGoal]
    
    init(mainGoals: [MainGoal], subGoals: [SubGoal], detailGoals: [DetailGoal]) {
        self.mainGoals = mainGoals
        self.subGoals = subGoals
        self.detailGoals = detailGoals
    }
    
    func deleteMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String) {
        mainGoal.title = ""
    }
    
    func deleteSubGoal(subGoal: SubGoal, modelContext: ModelContext, newTitle: String) {
        subGoal.title = ""
    }
    
    func deleteDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, newTitle: String, newMemo: String, isAchieved: Bool) {
        detailGoal.title = ""
        detailGoal.memo = ""
        detailGoal.isAchieved = false
    }
}
