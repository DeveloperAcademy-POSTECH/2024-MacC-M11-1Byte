//
//  File.swift
//  OneByte
//
//  Created by 이상도 on 10/30/24.
//

import SwiftUI
import SwiftData

// 클라이언트에서 생성하기 구체화
class ClientCreateService: CreateGoalUseCase {
    private var mainGoals: [MainGoal] = []
    private var subGoals: [SubGoal] = []
    private var detailGoals: [DetailGoal] = []
    
    func createMainGoal(title: String, isAchieved: Bool, subGoals: [SubGoal]) -> MainGoal {
        let newMainGoal = MainGoal(id: UUID(), title: title, isAchieved: false, subGoals: [])
        mainGoals.append(newMainGoal)
        
        return newMainGoal
    }
    
    func createSubGoal(mainGoalID: UUID, title: String, isAchieved: Bool, detailGoals: [DetailGoal]) -> SubGoal {
        let newSubGoal = SubGoal(id: UUID(), title: title, isAchieved: false, detailGoals: [])
        subGoals.append(newSubGoal)
        
        return newSubGoal
    }
    
    func createDetailGoal(subGoalID: UUID, title: String, isAchieved: Bool) -> DetailGoal {
        let newDetailGoal = DetailGoal(id: UUID(), title: title, isAchieved: false)
        detailGoals.append(newDetailGoal)
        
        return newDetailGoal
    }
}
