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
    
    // SubgoalCycleView
    var userNewSubGoal: String = "" // 사용자 SubGoal 입력 텍스트
    let subGoalLimit = 15 // 글자 수 제한
    
    // RoutineCycleView
    var targetSubGoal: SubGoal? // id가 1인 SubGoal 저장변수
    var userNewDetailGoal: String = "" // 사용자 SubGoal 입력 텍스트
    let detailGoalLimit = 20 // DetailGoal 글자 수 제한
    
    // DaysCycleView
    var targetDetailGoal: DetailGoal?
    var achieveGoal = 0
    var alertMon = false
    var alertTue = false
    var alertWed = false
    var alertThu = false
    var alertFri = false
    var alertSat = false
    var alertSun = false
    var selectedTime = ""
    var routineTimes = ["아침","점심","저녁","자기 전","자율"]
    
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
    
    // 요일 선택에 따른 `achieveGoal` 계산
    func updateAchieveGoal() {
        achieveGoal = [alertMon, alertTue, alertWed, alertThu, alertFri, alertSat, alertSun]
            .filter { $0 }
            .count
    }
    
    // 시간대 선택에 따른 업데이트 조건 계산
    func calculateTimeUpdateConditions() -> (isMorning: Bool, isAfternoon: Bool, isEvening: Bool, isNight: Bool, isFree: Bool) {
        let isAfternoon = selectedTime == "점심"
        let isEvening = selectedTime == "저녁"
        let isNight = selectedTime == "자기 전"
        let isFree = selectedTime == "자율"
        
        let isMorning: Bool
        if isAfternoon || isEvening || isNight || isFree {
            isMorning = false // 다른 시간대가 선택된 경우 false
        } else {
            isMorning = targetDetailGoal?.isMorning ?? false // 아무것도 선택되지 않은 경우 기존 값 유지
        }
        
        return (isMorning, isAfternoon, isEvening, isNight, isFree)
    }
    
    // 요일 + 시간대 선택 후 DetailGoal 업데이트
    func performUpdateDetailGoal() {
        guard let targetDetailGoal = targetDetailGoal else {
            print("⚠️ targetDetailGoal is nil")
            return
        }
        // 시간대 조건 계산
        let (isMorning, isAfternoon, isEvening, isNight, isFree) = calculateTimeUpdateConditions()
        
        // 업데이트 호출
        updateDetailGoal(
            detailGoal: targetDetailGoal,
            newTitle: targetDetailGoal.title,
            newMemo: targetDetailGoal.memo,
            achieveCount: targetDetailGoal.achieveCount,
            achieveGoal: achieveGoal,
            alertMon: alertMon,
            alertTue: alertTue,
            alertWed: alertWed,
            alertThu: alertThu,
            alertFri: alertFri,
            alertSat: alertSat,
            alertSun: alertSun,
            isRemind: targetDetailGoal.isRemind,
            remindTime: targetDetailGoal.remindTime,
            achieveMon: targetDetailGoal.achieveMon,
            achieveTue: targetDetailGoal.achieveTue,
            achieveWed: targetDetailGoal.achieveWed,
            achieveThu: targetDetailGoal.achieveThu,
            achieveFri: targetDetailGoal.achieveFri,
            achieveSat: targetDetailGoal.achieveSat,
            achieveSun: targetDetailGoal.achieveSun,
            isMorning: isMorning,
            isAfternoon: isAfternoon,
            isEvening: isEvening,
            isNight: isNight,
            isFree: isFree
        )
    }
    
    // 사용자 입력 DetailGoal 비우기
    func clearUserDetailGoal() {
        userNewDetailGoal = ""
    }
}
