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
}
