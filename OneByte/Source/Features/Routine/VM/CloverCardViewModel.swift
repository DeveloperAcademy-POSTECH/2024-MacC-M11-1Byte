//
//  CloverCardViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/29/24.
//

import SwiftUI

@Observable
class CloverCardViewModel {
    
    
    // 이전주차 cloverState값에 따라서 클로버 타입 반환
    func getCloverCardType(for cloverState: Int?) -> CloverCardType {
            switch cloverState {
            case 0: return .basicClover
            case 1: return .greenClover
            case 2: return .goldClover
            default: return .basicClover
            }
        }
    
    // 저번주의 (월/월차)
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
}
