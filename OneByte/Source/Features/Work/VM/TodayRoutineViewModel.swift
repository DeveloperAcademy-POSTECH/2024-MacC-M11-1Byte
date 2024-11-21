//
//  TodayRoutineViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/20/24.
//

import SwiftUI

@Observable
class TodayRoutineViewModel {
    
    // 오늘의 루틴에서 오늘루틴을 보여주기 위해, 현재 요일 확인 함수
    func currentDay() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E" // "월", "화", "수", ...
        return formatter.string(from: Date())
    }
    
    // DetailGoal이 오늘의 루틴인지 확인하는 함수
    func isTodayRoutine(_ detailGoal: DetailGoal, for day: String) -> Bool {
        switch day {
        case "월": return detailGoal.alertMon
        case "화": return detailGoal.alertTue
        case "수": return detailGoal.alertWed
        case "목": return detailGoal.alertThu
        case "금": return detailGoal.alertFri
        case "토": return detailGoal.alertSat
        case "일": return detailGoal.alertSun
        default: return false
        }
    }
    
    // MARK: 오늘의 루틴 필터링
    func filterTodayGoals(from mainGoals: [MainGoal]) -> [DetailGoal] {
        let today = currentDay()
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { isTodayRoutine($0, for: today) }
    }
    
    // MARK: 오전 루틴 필터링
    func morningGoals(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .filter { $0.isRemind && ($0.remindTime?.hour ?? 0) < 12 } // 오전 오후 구분
            .sorted(by: { ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast) }) // 시간순 정렬
    }
    
    // MARK: 오후 루틴 필터링
    func afternoonGoals(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .filter { $0.isRemind && ($0.remindTime?.hour ?? 0) >= 12 } // 오전 오후 구분
            .sorted(by: { ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast) }) // 시간순 정렬
    }
    
    // MARK: 자유 루틴 필터링
    func freeGoals(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        todayGoals.filter { !$0.isRemind }
    }
    
    // MARK: 오늘의 루틴 목록 중에서 완료/미완료 여부에 따라 achieveMon 데이터 변경
    func toggleAchievement(for detailGoal: DetailGoal) {
        let todayIndex = Date().mondayBasedIndex()  // 월요일 기준 인덱스
        let isAchievedBeforeToggle = detailGoal.isAchievedToday
        
        // 오늘의 요일에 해당하는 achieve 값을 토글
        switch todayIndex {
        case 0: detailGoal.achieveMon.toggle()
        case 1: detailGoal.achieveTue.toggle()
        case 2: detailGoal.achieveWed.toggle()
        case 3: detailGoal.achieveThu.toggle()
        case 4: detailGoal.achieveFri.toggle()
        case 5: detailGoal.achieveSat.toggle()
        case 6: detailGoal.achieveSun.toggle()
        default: break
        }
        
        // 토글 후 새로운 상태를 가져옴
        let isAchievedAfterToggle = detailGoal.isAchievedToday
        
        // 이전 상태와 새로운 상태를 비교하여 achieveCount 업데이트
        if isAchievedAfterToggle && !isAchievedBeforeToggle {
            detailGoal.achieveCount += 1 // 완료로 변경된 경우
        } else if !isAchievedAfterToggle && isAchievedBeforeToggle {
            detailGoal.achieveCount -= 1// 미완료로 변경된 경우
        }
    }
}
