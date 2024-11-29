//
//  CloverCardViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/29/24.
//

import SwiftUI
import SwiftData

@Observable
class CloverCardViewModel {
    
    
    // 이전주차 cloverState값에 따라서 클로버 타입 반환
    func getCloverCardType(for cloverState: Int?) -> CloverCardType {
            switch cloverState {
            case 0: return .noClover
            case 1: return .greenClover
            case 2: return .goldClover
            default: return .noClover
            }
        }
    
    // 저번주의 (월/월차) -> 카드에 주차 텍스트
    func getLastWeekWeekofMonth() -> String {
        let today = Date()
        let calendar = Calendar(identifier: .iso8601)
        
        // 현재 날짜에서 7일을 뺀 날짜 계산
        guard let lastWeekDate = calendar.date(byAdding: .day, value: -7, to: today) else {
            return ""
        }
        
        // 주차 및 월차 계산
        if let weekRange = Date.weekDateRange(for: lastWeekDate) {
            let thursday = calendar.date(byAdding: .day, value: 3, to: weekRange.start)!
            let isoMonth = calendar.component(.month, from: thursday) // 목요일 기준 월
            let weekOfMonth = calendar.component(.weekOfMonth, from: thursday) // 목요일 기준 월차
            return "\(isoMonth)월 \(weekOfMonth)주차"
        }
        return ""
    }
    
    // 저번주차의 Clover 객체를 찾아서, cloverState 값 반환
    func getLastWeekCloverState(clovers: [Clover]) -> Int {
        let today = Date()
        let calendar = Calendar(identifier: .iso8601)
        
        // 주차 및 월차 계산
        if let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: today) {
            let result = Date.calculateISOWeekAndMonthWeek(for: oneWeekAgo)
            let previousYear: Int = result.year
            let previousWeekOfYear: Int = result.weekOfYear
            let previousWeekOfMonth: Int = result.weekOfMonth
            let previousMonth: Int = calendar.component(.month, from: oneWeekAgo)
            
            // 1주 이전의 주차와 월차에 해당하는 Clover 객체를 찾음
            if let matchingClover = clovers.first(where: {
                $0.cloverYear == previousYear &&
                $0.cloverMonth == previousMonth &&
                $0.cloverWeekOfMonth == previousWeekOfMonth &&
                $0.cloverWeekOfYear == previousWeekOfYear
            }) {
                print("🍀 Found previous week's Clover ID: \(matchingClover.id)")
                
                return matchingClover.cloverState
            }
        }
        return 0
    }
}
