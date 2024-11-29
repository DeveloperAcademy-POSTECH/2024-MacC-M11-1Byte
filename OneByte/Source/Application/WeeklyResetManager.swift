//
//  WeeklyResetManager.swift
//  OneByte
//
//  Created by 이상도 on 11/23/24.
//

import SwiftUI
import SwiftData

struct WeeklyResetManager {
    
    private static let lastResetDateKey = "lastResetDate"
    
//    func needsReset() -> Bool {
//        let calendar = Calendar.current
//        let today = Date()
//        let weekday = calendar.component(.weekday, from: today) // 현재 요일 (1 = 일요일, 2 = 월요일, ...)
//        
//        // 마지막 초기화 날짜 가져오기
//        let lastResetDate = UserDefaults.standard.object(forKey: WeeklyResetManager.lastResetDateKey) as? Date
//        
//        // 월요일이고, 마지막 초기화 날짜가 월요일이 아닌 경우
//        if weekday >= 2 && weekday <= 7 { // 월요일
//            if let lastDate = lastResetDate {
//                return !calendar.isDate(lastDate, inSameDayAs: today)
//            }
//            return true // 초기화 날짜가 없으면 초기화 필요
//        }
//        
//        return false // 월요일이 아닌 경우 초기화 필요 없음
//    }
    func needsReset() -> Bool {
            let calendar = Calendar(identifier: .iso8601) // ISO8601 캘린더 사용 (월요일 시작)
            let today = Date()
            
            // 마지막 초기화 날짜 가져오기
            let lastResetDate = UserDefaults.standard.object(forKey: WeeklyResetManager.lastResetDateKey) as? Date
            
            // 마지막 초기화 날짜와 현재 날짜가 같은 주에 속하는지 확인
            if let lastDate = lastResetDate {
                // `weekOfYear`와 `yearForWeekOfYear`를 기준으로 같은 주인지 확인
                let isSameWeek = calendar.isDate(today, equalTo: lastDate, toGranularity: .weekOfYear)
                return !isSameWeek // 같은 주면 초기화 불필요
            }
            
            return true // 초기화 날짜가 없으면 초기화 필요
        }
    
    func resetGoals(goals: [MainGoal], modelContext: ModelContext) {
        guard needsReset() else {
            print("⚠️ No reset needed. Skipping...")
            return
        }
        
//        var lastWeekCloverState: Int? = nil
        
        for mainGoal in goals {
            print("🔄 Resetting MainGoal ID: \(mainGoal.id), Title: \(mainGoal.title)")
//            lastWeekCloverState = mainGoal.cloverState  초기화 전 저번주의 cloverState를 담음
            mainGoal.cloverState = 0 // MainGoal의 CloverState를 0으로 업데이트
            for subGoal in mainGoal.subGoals {
                for detailGoal in subGoal.detailGoals {
                    print("🔄 Resetting DetailGoal ID: \(detailGoal.id), Title: \(detailGoal.title)")
                    
                    detailGoal.achieveCount = 0
                    detailGoal.achieveMon = false
                    detailGoal.achieveTue = false
                    detailGoal.achieveWed = false
                    detailGoal.achieveThu = false
                    detailGoal.achieveFri = false
                    detailGoal.achieveSat = false
                    detailGoal.achieveSun = false
                }
            }
        }
        // 초기화된 날짜 새로 저장
        UserDefaults.standard.set(Date(), forKey: WeeklyResetManager.lastResetDateKey)
        
        do {
            try modelContext.save()
            print("✅ Reset successful and changes saved.")
        } catch {
            print("❌ Failed to save modelContext: \(error)")
        }
        
//        return lastWeekCloverState
    }
}
