//
//  OnboardingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

@Observable
class RoutineCycleViewModel {
    
    var userDetailGoal: String = "" // 사용자 SubGoal 입력 텍스트
    let detailGoalLimit = 20 // DetailGoal 글자 수 제한
    
    var navigationManager = NavigationManager()
    private let updateService: UpdateGoalUseCase
    
    init(updateService: UpdateGoalUseCase) {
        self.updateService = updateService
    }
    
    // SubGoal 업데이트
    func updateSubGoal(subGoal: SubGoal, newTitle: String, category: String) {
        updateService.updateSubGoal(
            subGoal: subGoal,
            newTitle: newTitle,
            category: category
        )
    }
    
    // DetailGoal 업데이트
    func updateDetailGoal(detailGoal: DetailGoal, newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, isMorning: Bool, isAfternoon: Bool, isEvening: Bool, isNight: Bool, isFree: Bool) {
        updateService.updateDetailGoal(detailGoal: detailGoal, title: newTitle, memo: newMemo, achieveCount: achieveCount, achieveGoal: achieveGoal, alertMon: alertMon, alertTue: alertTue, alertWed: alertWed, alertThu: alertThu, alertFri: alertFri, alertSat: alertSat, alertSun: alertSun, isRemind: isRemind, remindTime: remindTime, achieveMon: achieveMon, achieveTue: achieveTue, achieveWed: achieveWed, achieveThu: achieveThu, achieveFri: achieveFri, achieveSat: achieveFri, achieveSun: achieveSun, isMorning: isMorning, isAfternoon: isAfternoon, isEvening: isEvening, isNight: isNight, isFree: isFree)
        
    }
    
    // 사용자 입력 DetailGoal 비우기
    func clearUserDetailGoal() {
        userDetailGoal = ""
    }
}
