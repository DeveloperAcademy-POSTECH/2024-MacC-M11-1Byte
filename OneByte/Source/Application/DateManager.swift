//
//  DateManager.swift
//  OneByte
//
//  Created by 트루디 on 11/14/24.
//

import Foundation

// 날짜 관련 유틸리티 함수들을 담은 클래스
class DateManager {
    
    // 오늘 날짜를 "MM월 dd일" 형식으로 반환하는 함수
    func koreanFormattedDate(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        formatter.dateFormat = "M월 d일" // 월, 일 형식
        return formatter.string(from: date)
    }
    
    // 현재 날짜가 몇 월의 몇 주차인지 반환하는 함수
    func koreanMonthAndWeek(for date: Date) -> String {
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: date)
        let week = calendar.component(.weekOfMonth, from: date)
        return "\(month)월 \(week)주차"
    }
    
    // 요일별 D- 값을 고정한 enum 정의
    enum DeadlineDay: Int {
        case sunday = 1
        case monday = 2
        case tuesday = 3
        case wednesday = 4
        case thursday = 5
        case friday = 6
        case saturday = 7
        
        // 요일에 따른 D- 값을 반환
        var dDayValue: Int {
            switch self {
            case .sunday: return 1
            case .monday: return 7
            case .tuesday: return 6
            case .wednesday: return 5
            case .thursday: return 4
            case .friday: return 3
            case .saturday: return 2
            }
        }
        
        // 요일에 따른 D- 텍스트 반환
        var dDayText: String {
            return "D-\(self.dDayValue)"
        }
    }
    
    // 요일에 따라 오늘에 해당하는 DeadlineDay 반환
    func getTodayDeadlineDay() -> DeadlineDay? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        return DeadlineDay(rawValue: weekday)
    }
    
    // 오늘 요일에 맞는 D- 텍스트를 가져오는 함수
    func getTodayDText() -> String {
        if let todayDeadlineDay = getTodayDeadlineDay() {
            return todayDeadlineDay.dDayText
        } else {
            return "Invalid day"
        }
    }
}
