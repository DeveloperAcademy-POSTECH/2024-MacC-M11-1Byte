//
//  MainGoal.swift
//  OneByte
//
//  Created by 이상도 on 10/29/24.
//

import SwiftUI
import SwiftData

@Model
class MainGoal {
    @Attribute(.unique) var id: UUID
    var title: String = ""
    var isAchieved: Bool = false
    @Relationship var subGoals: [SubGoal] = []
    
    init(id: UUID, title: String, isAchieved: Bool, subGoals: [SubGoal]) {
        self.id = id
        self.title = title
        self.isAchieved = isAchieved
        self.subGoals = subGoals
    }
}

@Model
class SubGoal {
    @Attribute(.unique) var id: UUID
    var title: String = ""
    var isAchieved: Bool = false
    @Relationship var detailGoals: [DetailGoal] = []
    
    init(id: UUID, title: String, isAchieved: Bool, detailGoals: [DetailGoal]) {
        self.id = id
        self.title = title
        self.isAchieved = isAchieved
        self.detailGoals = detailGoals
    }
}

@Model
class DetailGoal {
    @Attribute(.unique) var id: UUID
    var title: String = ""
    var isAchieved: Bool = false
    
    init(id: UUID, title: String, isAchieved: Bool) {
        self.id = id
        self.title = title
        self.isAchieved = isAchieved
    }
}
