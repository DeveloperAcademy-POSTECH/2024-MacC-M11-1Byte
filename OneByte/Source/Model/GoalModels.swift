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
    var subGoals: [SubGoal]
    
    init(id: Int, title: String, goalYear: Int, subGoals: [SubGoal]) {
        self.id = id
        self.title = title
        self.goalYear = goalYear
        self.subGoals = subGoals
    }
}

@Model
class SubGoal {
    var id: Int
    var title: String
    var memo: String
    var mainGoalId: Int  // MainGoal의 ID로 연결
    var detailGoals: [DetailGoal]
    
    init(id: Int, title: String, memo: String, mainGoalId: Int, detailGoals: [DetailGoal]) {
        self.id = id
        self.title = title
        self.memo = memo
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
    var subGoalId: Int  // SubGoal의 ID로 연결

    init(id: Int, title: String, memo: String, isAchieved: Bool, subGoalId: Int) {
        self.id = id
        self.title = title
        self.memo = memo
        self.isAchieved = isAchieved
        self.subGoalId = subGoalId
    }
}
