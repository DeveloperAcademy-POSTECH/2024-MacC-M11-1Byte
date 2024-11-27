//
//  ClientUpdateService.swift
//  OneByte
//
//  Created by 이상도 on 10/30/24.
//

import Foundation
import SwiftData

class UpdateService: UpdateGoalUseCase {
    // 업데이트할 데이터
    var mainGoals: [MainGoal]
    var subGoals: [SubGoal]
    var detailGoals: [DetailGoal]
    
    init(mainGoals: [MainGoal], subGoals: [SubGoal], detailGoals: [DetailGoal]) {
        self.mainGoals = mainGoals
        self.subGoals = subGoals
        self.detailGoals = detailGoals
    }
    func updateMainGoal(mainGoal: MainGoal, id: Int, newTitle: String, cloverState: Int) {
        mainGoal.title = newTitle
        mainGoal.cloverState = cloverState
    }

    func updateSubGoal(subGoal: SubGoal, newTitle: String, leafState: Int, category: String, isCustomCategory: Bool) {
        subGoal.title = newTitle
        subGoal.leafState = leafState
        subGoal.category = category
        subGoal.isCustomCategory = isCustomCategory
    }
    
    func updateDetailGoal(detailGoal: DetailGoal,title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, timePeriod: String) {
        
        detailGoal.title = title
        detailGoal.memo = memo
        detailGoal.achieveCount = achieveCount
        detailGoal.achieveGoal = achieveGoal
        detailGoal.alertMon = alertMon
        detailGoal.alertTue = alertTue
        detailGoal.alertWed  = alertWed
        detailGoal.alertThu = alertThu
        detailGoal.alertFri = alertFri
        detailGoal.alertSat = alertSat
        detailGoal.alertSun = alertSun
        detailGoal.isRemind = isRemind
        detailGoal.remindTime = remindTime
        detailGoal.achieveMon = achieveMon
        detailGoal.achieveTue = achieveTue
        detailGoal.achieveWed = achieveWed
        detailGoal.achieveThu = achieveThu
        detailGoal.achieveFri = achieveFri
        detailGoal.achieveSat = achieveSat
        detailGoal.achieveSun = achieveSun
        detailGoal.timePeriod = timePeriod
    }
}
