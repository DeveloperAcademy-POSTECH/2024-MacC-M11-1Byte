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
    
    // 오늘의 루틴 필터링
    func filterTodayGoals(from mainGoals: [MainGoal]) -> [DetailGoal] {
        let today = currentDay()
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { $0.isTodayRoutine(for: today) }
    }
    
    // 오전 루틴 필터링
    func morningGoals(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .filter { $0.isRemind && ($0.remindTime?.hour ?? 0) < 12 } // 오전 오후 구분
            .sorted(by: { ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast) }) // 시간순 정렬
    }
    
    // 오후 루틴 필터링
    func afternoonGoals(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .filter { $0.isRemind && ($0.remindTime?.hour ?? 0) >= 12 } // 오전 오후 구분
            .sorted(by: { ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast) }) // 시간순 정렬
    }
    
    // 자유 루틴 필터링
    func freeGoals(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        todayGoals.filter { !$0.isRemind }
    }
}
