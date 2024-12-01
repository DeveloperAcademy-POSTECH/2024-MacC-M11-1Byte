//
//  WorkViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI
import SwiftData

@Observable
class RoutineMainViewModel {
    
    //    private static let lastResetDateKey = "lastResetDate" // 마지막 초기화날짜
    
    var mainDateManager = DateManager()
    var selectedPicker: routineTapInfo = .today
    var routineType: routineTapInfo
    var todayDate = Date() // 헤더뷰
    
    var currentMessage = "느리더라도 멈추지 않는다면\n결국 원하는 곳에 도달하게 돼요."
    private let randomMessages = [
        "완벽하지 않아도 괜찮아요.\n중요한 것은 꾸준히 하는것이에요.",
        "한 걸음씩 가다 보면\n어느새 큰 변화를 느낄거에요!",
        "같이 조금 더 힘내봐요!\n조금만 힘내면 금세 습관이 될거에요.",
        "누가 그랬는데 탁월함은\n행동이 아니라 습관에서 온대요.",
        "오늘 조금 못해도 괜찮아요,\n내일은 더 잘할 수 있을거에요.",
        "느려도 괜찮아요.\n꾸준함이 목표로 데려다줄거에요.",
        "중단했더라도 괜찮아요.\n중요한 건 포기하지 않는 마음이에요."
    ]
    
    init(routineType: routineTapInfo) {
        self.routineType = routineType
    }
    
    func routinePicker(to picker: routineTapInfo) {
        self.selectedPicker = picker
    }
    
    // 현재(오늘)이 몇월의 몇주차에 해당하는지 ex) 2024.12.01은 11월의 4주차
    func getTodayWeekofMonth() -> String {
        let today = Date()
        let calendar = Calendar(identifier: .iso8601)
        
        // 주차 및 월차 계산
        if let weekRange = Date.weekDateRange(for: today) {
            let thursday = calendar.date(byAdding: .day, value: 3, to: weekRange.start)!
            let isoMonth = calendar.component(.month, from: thursday) // 목요일 기준 월
            let weekOfMonth = calendar.component(.weekOfMonth, from: thursday) // 목요일 기준 월차
            return "\(isoMonth)월 \(weekOfMonth)주차"
        }
        return ""
    }
    
    // 만북이 랜덤 메세지
    func updateRandomMessage() {
        if let randomMessage = randomMessages.randomElement() {
            currentMessage = randomMessage
        }
    }
    //    func needsReset() -> Bool {
    //        let calendar = Calendar.current
    //        let today = Date()
    //        let weekday = calendar.component(.weekday, from: today) // 현재 요일 (1 = 일요일, 2 = 월요일, ...)
    //
    //        // 마지막 초기화 날짜 가져오기
    //        let lastResetDate = UserDefaults.standard.object(forKey: RoutineMainViewModel.lastResetDateKey) as? Date
    //
    //        // 월요일이고, 마지막 초기화 날짜가 월요일이 아닌 경우
    //        if weekday == 2 { // 월요일
    //            if let lastDate = lastResetDate {
    //                return !calendar.isDate(lastDate, inSameDayAs: today)
    //            }
    //            return true // 초기화 날짜가 없으면 초기화 필요
    //        }
    //
    //        return false // 월요일이 아닌 경우 초기화 필요 없음
    //    }
    //
    //    // 초기화 로직
    //    func resetGoals(goals: [MainGoal], modelContext: ModelContext) {
    //        guard needsReset() else {
    //            print("⚠️ No reset needed. Skipping...")
    //            return
    //        }
    //
    //        for mainGoal in goals {
    //            for subGoal in mainGoal.subGoals {
    //                for detailGoal in subGoal.detailGoals {
    //                    print("🔄 Resetting DetailGoal ID: \(detailGoal.id), Title: \(detailGoal.title)")
    //
    //                    detailGoal.achieveCount = 0
    //                    detailGoal.achieveMon = false
    //                    detailGoal.achieveTue = false
    //                    detailGoal.achieveWed = false
    //                    detailGoal.achieveThu = false
    //                    detailGoal.achieveFri = false
    //                    detailGoal.achieveSat = false
    //                    detailGoal.achieveSun = false
    //                }
    //            }
    //        }
    //        // 초기화된 날짜 새로 저장
    //        UserDefaults.standard.set(Date(), forKey: RoutineMainViewModel.lastResetDateKey)
    //
    //        do {
    //            try modelContext.save()
    //            print("✅ Reset successful and changes saved.")
    //        } catch {
    //            print("❌ Failed to save modelContext: \(error)")
    //        }
    //    }
}
