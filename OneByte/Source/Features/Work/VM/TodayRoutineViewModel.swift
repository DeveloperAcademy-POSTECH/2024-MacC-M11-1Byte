//
//  TodayRoutineViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/20/24.
//

import SwiftUI
import SwiftData

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
    func toggleAchievement(for detailGoal: DetailGoal, in mainGoal: MainGoal, context: ModelContext) {
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
        updateCloverState(for: mainGoal) // MainGoal의 cloverState 업데이트 함수 호출
        
        // 변경 사항 저장
        do {
            try context.save()
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    // MARK: MainGoal의 cloverState 업데이트
    func updateCloverState(for mainGoal: MainGoal) {
        // 모든 DetailGoal 가져오기
        let allDetailGoals = mainGoal.subGoals.flatMap { $0.detailGoals }
        
        // 모든 DetailGoal의 상태 확인
        let allAchieveCount = allDetailGoals.map { $0.achieveCount }
        let allAchieveGoal = allDetailGoals.map { $0.achieveGoal }
        
        // 1) 모든 achieveCount가 0이면 cloverState = 1
        if allAchieveCount.allSatisfy({ $0 == 0 }) {
            mainGoal.cloverState = 1
            return
        }
        
        // 2) 1개 이상 achieveCount가 0보다 크면 cloverState = 2
        if allAchieveCount.contains(where: { $0 > 0 }) {
            mainGoal.cloverState = 2
        }
        
        // 3) 모든 achieveCount가 achieveGoal과 같으면 cloverState = 3
        if zip(allAchieveCount, allAchieveGoal).allSatisfy({ $0 == $1 }) {
            mainGoal.cloverState = 3
            return
        }
    }
}

