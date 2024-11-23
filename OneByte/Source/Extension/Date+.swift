//
//  Date+.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import Foundation

extension Date {
    var YearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년"
        return formatter.string(from: self)
    }
    
    var currentDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)" // "11월 25일 (월)" 형식
        return formatter.string(from: Date())
    }
    
    // "오전 09:00" "오후 14:00" 형식으로 문자열을 반환
    var alertTimeString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US") // 한국어 형식
        formatter.dateFormat = "a hh:mm" // 오전/오후 포함 (두 자리)
        return formatter.string(from: self)
    }
    
    // AllRoutineView에서 실제 현재 요일을 반환 (월, 화, 수, ...)
    var currentDay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E" // 요일만 가져오기
        return formatter.string(from: Date())
    }
    
    // TodayRoutineView에서 HH:mm 형식으로 시간만 반환
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    // TodayRoutineView에서 오전/오후루틴 시간순으로 정렬하기위해 시간을 반환
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    // 월요일 시작(0) ~ 일요일(6)로 요일 인덱스를 반환
    func mondayBasedIndex() -> Int {
        let weekday = Calendar.current.component(.weekday, from: self)
        return (weekday + 5) % 7
    }
    
    // MARK: 현재 날짜 기준의 주차에 Clover데이터에 현재 MainGoal CloverState를 Update하기 위한 주차 계산
    static func calculateISOWeekAndMonthWeek(for date: Date) -> (year: Int, weekOfYear: Int, weekOfMonth: Int) {
        let calendar = Calendar(identifier: .iso8601)
        let year = calendar.component(.yearForWeekOfYear, from: date) // 주차의 연도
        let weekOfYear = calendar.component(.weekOfYear, from: date) // ISO 기준 주차
        
        // 주 시작일 계산 (ISO 기준 주 시작일은 월요일)
        if let weekRange = Date.weekDateRange(for: date) {
            // 목요일 기준으로 월차 계산
            let thursday = calendar.date(byAdding: .day, value: 3, to: weekRange.start)!
            let weekOfMonth = calendar.component(.weekOfMonth, from: thursday) // 월 기준 주차
            return (year, weekOfYear, weekOfMonth)
        }
        
        // 기본 값 반환 (계산 실패 시)
        return (year, weekOfYear, 0)
    }
    
    static func weekDateRange(for date: Date) -> (start: Date, end: Date)? {
        let calendar = Calendar(identifier: .iso8601)
        if let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: date)?.start {
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            return (startOfWeek, endOfWeek)
        }
        return nil
    }
    
}
