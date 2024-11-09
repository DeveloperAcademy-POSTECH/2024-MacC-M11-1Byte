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

    init(id: UUID = UUID(), title: String = "", isAchieved: Bool = false) {
        self.id = id
        self.title = title
        self.isAchieved = isAchieved
    }
}

@Model
class SubGoal {
    @Attribute(.unique) var id: UUID
    var title: String = ""
    var isAchieved: Bool = false
    @Relationship var detailGoals: [DetailGoal] = []
    @Relationship(inverse: \MainGoal.subGoals) var mainGoal: MainGoal?

    init(id: UUID = UUID(), title: String = "", isAchieved: Bool = false) {
        self.id = id
        self.title = title
        self.isAchieved = isAchieved
    }
}

@Model
class DetailGoal {
    @Attribute(.unique) var id: UUID
    var title: String = ""
    var isAchieved: Bool = false
    @Relationship(inverse: \SubGoal.detailGoals) var subGoal: SubGoal?

    init(id: UUID = UUID(), title: String = "", isAchieved: Bool = false) {
        self.id = id
        self.title = title
        self.isAchieved = isAchieved
    }
}
