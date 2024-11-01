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
    
    var mainGoals: [MainGoal] = []
    var subGoals: [SubGoal] = []
    var detailGoals: [DetailGoal] = []
    
    func createMainGoal(title: String, isAchieved: Bool) -> MainGoal {
        print("Creating MainGoal with title: \(title)")
        let newMainGoal = MainGoal(id: UUID(), title: title, isAchieved: false)
        print(newMainGoal.id)
        print(newMainGoal.subGoals)
        print(newMainGoal.isAchieved)
        print("Successfully created MainGoal: \(newMainGoal.title)")
        return newMainGoal
    }
    
    func createSubGoal(mainGoal: MainGoal, title: String, isAchieved: Bool) -> SubGoal? {
        let newSubGoal = SubGoal(id: UUID(), title: title, isAchieved: isAchieved)
        newSubGoal.mainGoal = mainGoal
        print(newSubGoal.id)
        print(mainGoal.id)
        return newSubGoal
    }
    
    func createDetailGoal(subGoal: SubGoal, title: String, isAchieved: Bool) -> DetailGoal? {
        let newDetailGoal = DetailGoal(id: UUID(), title: title, isAchieved: isAchieved)
        newDetailGoal.subGoal = subGoal
        print("newDetailGoal.id: \(newDetailGoal.id)")
        print("subGoal.id: \(subGoal.id)")
        print("newDetailGoal.isAchieved: \(newDetailGoal.isAchieved)")
        print("newDetailGoal.title: \(newDetailGoal.title)")
        
        return newDetailGoal
    }
}
