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
    // MARK: 사용자가 모든 DetailGoal을 삭제해서, 모든 루틴의 title의 ""일때 필터링
    func isAllDetailGoalTitlesEmpty(from mainGoals: [MainGoal]) -> Bool {
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .allSatisfy { $0.title.isEmpty }
    }
    
    // MARK: 오늘의 루틴인것만 필터링
    func filterTodayGoals(from mainGoals: [MainGoal]) -> [DetailGoal] {
        let today = currentDay()
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { isTodayRoutine($0, for: today) }
    }
    
    // MARK: 아침/점심/저녁/자기전/자율 루틴 필터링 및 시간순 정렬
    func filterMorning(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isMorning }
    }
    
    func filterAfternoon(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isAfternoon }
    }
    
    func filterEvening(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isEvening }
    }
    
    func filterNight(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isNight }
    }
    
    func filterFree(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isFree }
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
        let allDetailGoals = mainGoal.subGoals.flatMap { $0.detailGoals } // 모든 SubGoal의 DetailGoal 가져오기
        let allAchieveCount = allDetailGoals.map { $0.achieveCount } // 모든 DetailGoal의 AchieveCount
        let allAchieveGoal = allDetailGoals.map { $0.achieveGoal } // 모든 DetailGoal의 AchieveGoal
        
        // 1) 모든 achieveCount가 0이면 cloverState = 0
        if allAchieveCount.allSatisfy({ $0 == 0 }) {
            mainGoal.cloverState = 0
            print("🔥🔥🔥루틴 미성취: \(mainGoal.cloverState)")
            return
        }
        
        // achieveGoal이 1이상인것중에, achieveCount == achieveGoal이 1개라도 있다면
        if allDetailGoals.contains(where: { $0.achieveGoal > 0 && $0.achieveCount == $0.achieveGoal }) {
            if zip(allAchieveCount, allAchieveGoal).allSatisfy({ $0 == $1 }) { // 모든 루틴이 같다면, 황금 클로버
                mainGoal.cloverState = 2
                print("🔥🔥 3번 조건(루틴 all 성공): \(mainGoal.cloverState)")
            } else { // 1개성취면 초록클로버
                mainGoal.cloverState = 1
                print("🔥🔥 2번 조건(루틴 1개 성공): \(mainGoal.cloverState)")
            }
            return
        }
    }
    
    // MainGoal CloverState 변경시킬때,Clover객체에서 현재 날짜에 맞는 주차찾아 CloverState 업데이트 시키기 위해 날짜 찾음
    func calculateCurrentWeekAndMonthWeek(mainGoal: MainGoal, clovers: [Clover], context: ModelContext) {
        let today = Date()
        let calendar = Calendar(identifier: .iso8601)
        
        // 주차 및 월차 계산
        let result = Date.calculateISOWeekAndMonthWeek(for: today)
        let currentYear: Int = result.year
        let currentWeekOfYear: Int = result.weekOfYear
        let currentWeekOfMonth: Int = result.weekOfMonth
        let currentMonth: Int = calendar.component(.month, from: today)
        print("현재 날짜 정보 : \(currentYear),\(currentWeekOfYear),\(currentWeekOfMonth),\(currentMonth)")
        // 주 시작일과 종료일 계산
        if let range = Date.weekDateRange(for: today) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            
            print("주 시작일: \(formatter.string(from: range.start))")
            print("주 종료일: \(formatter.string(from: range.end))")
        }
        
        // 현재 주차와 월차에 해당하는 Clover 객체를 찾음
        if let matchingClover = clovers.first(where: {
            $0.cloverYear == currentYear &&
            $0.cloverWeekOfMonth == currentWeekOfMonth &&
            $0.cloverWeekOfYear == currentWeekOfYear
        }) {
            print("🍀 Found matching Clover ID: \(matchingClover.id)")
            
            // CloverState 업데이트
            matchingClover.cloverState = mainGoal.cloverState
            // 저장
            do {
                try context.save()
                print("✅ 클로버 상태 업데이트 성공(Clover ID): \(matchingClover.id)")
            } catch {
                print("❌ 클로버 업데이트 실패: \(error)")
            }
        } else {
            print("⚠️ 날짜 매칭 실패 for 연도: \(currentYear), 월: \(currentMonth), 월차: \(currentWeekOfMonth), 주차: \(currentWeekOfYear)")
        }
    }
}

