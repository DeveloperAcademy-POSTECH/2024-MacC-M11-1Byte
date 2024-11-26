//
//  MainGoal.swift
//  OneByte
//
//  Created by 이상도 on 10/29/24.
//
import SwiftData
import SwiftUI

@Model
class MainGoal {
    var id: Int
    var title: String
    var cloverState: Int
    var subGoals: [SubGoal]
    
    init(id: Int, title: String, cloverState: Int, subGoals: [SubGoal]) {
        self.id = id
        self.title = title
        self.cloverState = cloverState
        self.subGoals = subGoals
    }
}

@Model
class SubGoal {
    var id: Int
    var title: String
    var leafState: Int
    var detailGoals: [DetailGoal]
    
    init(id: Int, title: String, leafState: Int, detailGoals: [DetailGoal]) {
        self.id = id
        self.title = title
        self.leafState = leafState
        self.detailGoals = detailGoals
    }
}

@Model
class DetailGoal {
    var id: Int
    var title: String
    var memo: String
    var achieveCount: Int
    var achieveGoal: Int
    var alertMon: Bool
    var alertTue: Bool
    var alertWed: Bool
    var alertThu: Bool
    var alertFri: Bool
    var alertSat: Bool
    var alertSun: Bool
    var isRemind: Bool
    var remindTime: Date?
    var achieveMon: Bool
    var achieveTue: Bool
    var achieveWed: Bool
    var achieveThu: Bool
    var achieveFri: Bool
    var achieveSat: Bool
    var achieveSun: Bool
    var timePeriod: String

    init(id: Int, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date? = nil, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, timePeriod: String = "설정 안 함") {
        self.id = id
        self.title = title
        self.memo = memo
        self.achieveCount = achieveCount
        self.achieveGoal = achieveGoal
        self.alertMon = alertMon
        self.alertTue = alertTue
        self.alertWed = alertWed
        self.alertThu = alertThu
        self.alertFri = alertFri
        self.alertSat = alertSat
        self.alertSun = alertSun
        self.isRemind = isRemind
        self.remindTime = remindTime
        self.achieveMon = achieveMon
        self.achieveTue = achieveTue
        self.achieveWed = achieveWed
        self.achieveThu = achieveThu
        self.achieveFri = achieveFri
        self.achieveSat = achieveSat
        self.achieveSun = achieveSun
        self.timePeriod = timePeriod
    }
}
