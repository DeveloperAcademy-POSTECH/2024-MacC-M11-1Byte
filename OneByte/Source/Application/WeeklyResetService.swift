//
//  WeeklyResetManager.swift
//  OneByte
//
//  Created by 이상도 on 11/23/24.
//

import SwiftUI
import SwiftData

struct WeeklyResetService {
    
    private static let lastResetDateKey = "lastResetDate"
    
    func needsReset() -> Bool {
        let calendar = Calendar(identifier: .iso8601) // ISO8601 캘린더 사용 (월요일 시작)
        let today = Date()
        
        // 앱 설치일 가져오기
        let userInstallDateKey = "userInstallDate"
        guard let installDateString = UserDefaults.standard.string(forKey: userInstallDateKey),
              let installDate = DateFormatter().userInstallSeoulDate(from: installDateString) else {
            print("❌ 설치일을 찾을 수 없음. 초기화 진행 필요.")
            return true // 설치일이 없다면 초기화 필요
        }

        // 설치 주간인지 확인
        if calendar.isDate(today, equalTo: installDate, toGranularity: .weekOfYear) {
            print("✅ 앱 설치 주간입니다. 초기화가 필요하지 않음.")
            return false
        }
        
        // 마지막 초기화 날짜 가져오기
        let lastResetDate = UserDefaults.standard.object(forKey: WeeklyResetService.lastResetDateKey) as? Date

        // 마지막 초기화 날짜와 현재 날짜가 같은 주에 속하는지 확인
        if let lastDate = lastResetDate {
            let isSameWeek = calendar.isDate(today, equalTo: lastDate, toGranularity: .weekOfYear)
            return !isSameWeek // 같은 주면 초기화 불필요
        }

        print("✅ 설치 주간이 아니고, 마지막 초기화 날짜가 없음. 초기화 필요.")
        return true // 초기화 필요
    }
    
    /// 실제 초기화 작업 수행
    func performReset(goals: [MainGoal], modelContext: ModelContext) {
        for mainGoal in goals {
            print("🔄 Resetting MainGoal ID: \(mainGoal.id), Title: \(mainGoal.title)")
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
        UserDefaults.standard.set(Date(), forKey: WeeklyResetService.lastResetDateKey)
        
        do {
            try modelContext.save()
            print("✅ Reset successful and changes saved.")
        } catch {
            print("❌ Failed to save modelContext: \(error)")
        }
    }
}

extension DateFormatter {
    func userInstallSeoulDate(from string: String) -> Date? {
        self.locale = Locale(identifier: "ko_KR")
        self.timeZone = TimeZone(identifier: "Asia/Seoul")
        self.dateFormat = "yyyy-MM-dd HH:mm:ss" // 저장된 설치일 포맷
        return self.date(from: string)
    }
}
