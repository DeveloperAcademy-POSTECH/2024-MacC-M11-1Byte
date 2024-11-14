//
//  File.swift
//  OneByte
//
//  Created by 이상도 on 10/30/24.
//

// ClientCreateService.swift
import SwiftUI
import SwiftData

class ClientCreateService: CreateGoalUseCase {
    func createGoals(modelContext: ModelContext) {
        var mainGoalCounter = 1  // MainGoal ID 카운터
        var subGoalCounter = 1   // SubGoal ID 카운터
        var detailGoalCounter = 1 // DetailGoal ID 카운터
           
           // MainGoal 생성
           let newMainGoal = MainGoal(
               id: mainGoalCounter,
               title: "",
               subGoals: []
           )
           
           mainGoalCounter += 1  // MainGoal ID 증가
           
           // SubGoal 4개 생성 및 DetailGoal 4개 초기화
           for _ in 1...4 {
               let newSubGoal = SubGoal(
                   id: subGoalCounter,
                   title: "",
                   mainGoalId: newMainGoal.id,
                   detailGoals: []
               )
               subGoalCounter += 1 // SubGoal ID 증가
               
               // DetailGoal 4개 생성
               for _ in 1...3 {
                   let newDetailGoal = DetailGoal(
                       id: detailGoalCounter,
                       title: "",
                       memo: "",
                       isAchieved: false,
                       subGoalId: newSubGoal.id
                   )
                   detailGoalCounter += 1 // DetailGoal ID 증가
                   
                   // SwiftData에 DetailGoal 추가
                   modelContext.insert(newDetailGoal)
                   newSubGoal.detailGoals.append(newDetailGoal)
               }
               
               // SwiftData에 SubGoal 추가
               modelContext.insert(newSubGoal)
               newMainGoal.subGoals.append(newSubGoal)
           }
           
           // SwiftData에 MainGoal 추가
           modelContext.insert(newMainGoal)
       }
}
