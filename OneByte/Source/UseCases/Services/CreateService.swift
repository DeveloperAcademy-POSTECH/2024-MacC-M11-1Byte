//
//  File.swift
//  OneByte
//
//  Created by 이상도 on 10/30/24.
//

// ClientCreateService.swift
import SwiftUI
import SwiftData

class CreateService: CreateGoalUseCase {
    func createGoals(modelContext: ModelContext) {
        var mainGoalCounter = 1  // MainGoal ID 카운터
        var subGoalCounter = 1   // SubGoal ID 카운터
        var detailGoalCounter = 1 // DetailGoal ID 카운터
           
           // MainGoal 생성 
           let newMainGoal = MainGoal(
               id: mainGoalCounter,
               title: "",
               cloverState: 0,
               subGoals: []
           )
           
           mainGoalCounter += 1  // MainGoal ID 증가
           
           // SubGoal 4개 생성 및 DetailGoal 3개 초기화
           for _ in 1...4 {
               let newSubGoal = SubGoal(
                   id: subGoalCounter,
                   title: "",
                   detailGoals: [],
                   category: ""
               )
               subGoalCounter += 1 // SubGoal ID 증가
               
               // DetailGoal 3개 생성
               for _ in 1...3 {
                   let newDetailGoal = DetailGoal(
                       id: detailGoalCounter,
                       title: "",
                       memo: "",
                       achieveCount: 0,
                       achieveGoal: 0,
                       alertMon: false,
                       alertTue: false,
                       alertWed: false,
                       alertThu: false,
                       alertFri: false,
                       alertSat: false,
                       alertSun: false,
                       isRemind: false,
                       remindTime: nil,
                       achieveMon: false,
                       achieveTue: false,
                       achieveWed: false,
                       achieveThu: false,
                       achieveFri: false,
                       achieveSat: false,
                       achieveSun: false,
                       isMorning: true,
                       isAfternoon: false,
                       isEvening: false,
                       isNight: false,
                       isFree: false
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
    // 알림 생성
    func createNotification(detailGoal: DetailGoal, newTitle: String, selectedDays: [String]) {
        guard let remindTime = detailGoal.remindTime else { return }
        
        checkNotificationPermissionAndRequestIfNeeded()
        
        // 각 요일별로 알림 생성
        for day in selectedDays {
            scheduleNotification(detailGoal: detailGoal, for: detailGoal.title, on: day, at: remindTime)
        }
    }
}
