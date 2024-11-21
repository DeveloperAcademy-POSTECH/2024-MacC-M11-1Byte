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
    
    func deleteMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String, cloverState: Int) {
        mainGoal.title = ""
        mainGoal.cloverState = 0
    }
    
    func deleteSubGoal(subGoal: SubGoal, newTitle: String, leafState: Int) {
        subGoal.title = ""
        subGoal.leafState = 0
    }
    
    func deleteDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool) {
        detailGoal.title = ""
        detailGoal.memo = ""
        detailGoal.achieveCount = 0
        detailGoal.achieveGoal = 0
        detailGoal.alertMon = false
        detailGoal.alertTue = false
        detailGoal.alertWed  = false
        detailGoal.alertThu = false
        detailGoal.alertFri = false
        detailGoal.alertSat = false
        detailGoal.alertSun = false
        detailGoal.isRemind = false
        detailGoal.remindTime = nil
        detailGoal.achieveMon = false
        detailGoal.achieveTue = false
        detailGoal.achieveWed = false
        detailGoal.achieveThu = false
        detailGoal.achieveFri = false
        detailGoal.achieveSat = false
        detailGoal.achieveSun = false
    }
    
    func resetAllData(modelContext: ModelContext, mainGoal: MainGoal) {
        mainGoal.title = ""  // MainGoal의 타이틀 초기화
        
        // 모든 SubGoal 초기화
        for subGoal in mainGoal.subGoals {
            subGoal.title = ""
            subGoal.leafState = 0
            
            // 각 SubGoal에 연결된 DetailGoal 초기화
            for detailGoal in subGoal.detailGoals {
                detailGoal.title = ""
                detailGoal.memo = ""
                detailGoal.achieveCount = 0
                detailGoal.achieveGoal = 0
                detailGoal.alertMon = false
                detailGoal.alertTue = false
                detailGoal.alertWed  = false
                detailGoal.alertThu = false
                detailGoal.alertFri = false
                detailGoal.alertSat = false
                detailGoal.alertSun = false
                
            }
        }
    }
    
}
