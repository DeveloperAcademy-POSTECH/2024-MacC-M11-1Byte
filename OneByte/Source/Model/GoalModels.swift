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
    var goalYear: Int
    var createdTime: Date
    var modifiedTime: Date
    var subGoals: [SubGoal]
    
    init(id: Int, title: String, goalYear: Int, createdTime: Date, modifiedTime: Date, subGoals: [SubGoal]) {
        self.id = id
        self.title = title
        self.goalYear = goalYear
        self.createdTime = createdTime
        self.modifiedTime = modifiedTime
        self.subGoals = subGoals
    }
}

@Model
class SubGoal {
    var id: Int
    var title: String
    var memo: String
    var createdTime: Date
    var modifiedTime: Date
    var mainGoalId: Int  // MainGoal의 ID로 연결
    var detailGoals: [DetailGoal]
    
    init(id: Int, title: String, memo: String, createdTime: Date, modifiedTime: Date, mainGoalId: Int, detailGoals: [DetailGoal]) {
        self.id = id
        self.title = title
        self.memo = memo
        self.createdTime = createdTime
        self.modifiedTime = modifiedTime
        self.mainGoalId = mainGoalId
        self.detailGoals = detailGoals
    }
}

@Model
class DetailGoal {
    var id: Int
    var title: String
    var memo: String
    var isAchieved: Bool
    var createdTime: Date
    var modifiedTime: Date
    var subGoalId: Int  // SubGoal의 ID로 연결

    init(id: Int, title: String, memo: String, isAchieved: Bool, createdTime: Date, modifiedTime: Date, subGoalId: Int) {
        self.id = id
        self.title = title
        self.memo = memo
        self.isAchieved = isAchieved
        self.createdTime = createdTime
        self.modifiedTime = modifiedTime
        self.subGoalId = subGoalId
    }
}
