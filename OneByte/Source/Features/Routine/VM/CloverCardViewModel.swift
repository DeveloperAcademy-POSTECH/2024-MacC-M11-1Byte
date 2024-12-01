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
    
    var lastWeekCloverState: Int? // 지난주의 cloverState 값
    var isCheckAchievement = false // 완수율 확인하기
    var rotationAngle: Double = 0 // 회전 각도
    var isTapped: Bool = false  // 애니메이션 자동회전/탭회전 구분
    var progressValues: [Int: Double] = [:] // SubGoal별 Progress 값 저장
    
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
    
    // SubGoal의 Progress 값 계산
    func calculateProgressValues(for subGoals: [SubGoal]) {
        let totals = calculateSubGoalTotals(for: subGoals)
        for (subGoalId, (totalAchieveCount, totalAchieveGoal)) in totals {
            let progressValue = totalAchieveGoal > 0 ? Double(totalAchieveCount) / Double(totalAchieveGoal) : 0.0
            progressValues[subGoalId] = progressValue
        }
    }
    
    // SubGoal의 총합 계산 ( achieveGoal이 1이상인것들에 한해서 )
    private func calculateSubGoalTotals(for subGoals: [SubGoal]) -> [Int: (totalAchieveCount: Int, totalAchieveGoal: Int)] {
        var subGoalTotals: [Int: (totalAchieveCount: Int, totalAchieveGoal: Int)] = [:]
        for subGoal in subGoals {
            let filteredDetailGoals = subGoal.detailGoals.filter { $0.achieveGoal > 0 }
            let totalAchieveCount = filteredDetailGoals.reduce(0) { $0 + $1.achieveCount }
            let totalAchieveGoal = filteredDetailGoals.reduce(0) { $0 + $1.achieveGoal }
            subGoalTotals[subGoal.id] = (totalAchieveCount, totalAchieveGoal)
        }
        return subGoalTotals
    }
    
    // 클로버 자동 회전
    func startRotationAnimation() {
        guard !isTapped else { return } // 탭 회전 중이면 무시
        withAnimation(
            Animation.linear(duration: 2.5) // 애니메이션 지속 시간
                .repeatForever(autoreverses: false) // 무한 반복
        ) {
            rotationAngle += 360 // Y축 기준으로 한 바퀴 회전
        }
    }
    
    // 클로버 탭 회전
    func tapRotationAnimation() {
        guard !isTapped else { return } // 이미 빠른 회전 중이면 무시
        isTapped = true
        
        // 탭 회전 시작
        withAnimation(
            Animation.linear(duration: 1.0)
        ) {
            rotationAngle += 90
        }
        
        withAnimation(
            Animation.linear(duration: 1.4)
        ) {
            rotationAngle += 90
        }
        
        withAnimation(
            Animation.linear(duration: 1.8)
        ) {
            rotationAngle += 90
        }
        
        withAnimation(
            Animation.linear(duration: 2.2)
        ) {
            rotationAngle += 90
        }
        
        // 자동 회전으로 복귀
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isTapped = false
            self.startRotationAnimation()
        }
    }
}
