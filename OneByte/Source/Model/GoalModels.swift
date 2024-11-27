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
    var detailGoals: [DetailGoal]
    var category: String // 카테고리 추가
    
    init(id: Int, title: String, detailGoals: [DetailGoal], category: String) {
        self.id = id
        self.title = title
        self.detailGoals = detailGoals
        self.category = category
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
    // 아침, 점심, 저녁, 자기전, 자율 시간 설정
    var isMorning: Bool
    var isAfternoon: Bool
    var isEvening: Bool
    var isNight: Bool
    var isFree: Bool

    init(id: Int, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date? = nil, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, isMorning: Bool, isAfternoon: Bool, isEvening: Bool, isNight: Bool, isFree: Bool) {
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
        self.isMorning = isMorning
        self.isAfternoon = isAfternoon
        self.isEvening = isEvening
        self.isNight = isNight
        self.isFree = isFree
    }
}
