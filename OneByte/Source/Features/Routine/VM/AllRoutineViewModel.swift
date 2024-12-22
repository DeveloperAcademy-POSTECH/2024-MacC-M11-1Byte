//
//  AllRoutineViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI

@Observable
class AllRoutineViewModel {
    
    let days: [String] = ["월","화","수","목","금","토","일"]
    var isInfoVisible = false // 팝업 표시 상태
    var selectedPicker: tapInfo = .all
    
    // 해당 탭의 Subgoal에 해당하는 DetailGoal 나타내기 위한 Subgoal Id 반환 메서드
    func subGoalId(for tab: tapInfo) -> Int? {
        switch tab {
        case .all: return nil
        case .first: return 1
        case .second: return 2
        case .third: return 3
        case .fourth: return 4
        }
    }
    
    // Subgoal id별로 탭 title을 category로
    func tabTitle(for item: tapInfo, mainGoals: [MainGoal]) -> String {
        if item == .all {
            return "전체"
        }
        guard let subGoalId = subGoalId(for: item),
              let mainGoal = mainGoals.first,
              let subGoal = mainGoal.subGoals.first(where: { $0.id == subGoalId }) else {
            return "목표 없음"
        }
        return subGoal.category
    }
    
    // subGoalId에 따라 클로버 이미지를 종류별로 반환하는 메서드
    func colorClover(for subGoalId: Int) -> String {
        switch subGoalId {
        case 1: return tapInfo.first.colorClover
        case 2: return tapInfo.second.colorClover
        case 3: return tapInfo.third.colorClover
        case 4: return tapInfo.fourth.colorClover
        default: return tapInfo.all.colorClover
        }
    }
    
    // 탭선택에 따라 picker -> animation
    func allRoutineTapPicker(to picker: tapInfo) {
        withAnimation(.easeInOut) {
            self.selectedPicker = picker
        }
    }
    
    // MainGoal에서 SubGoal 필터링 및 정렬
    func filteredSubGoals(from mainGoal: MainGoal) -> [SubGoal] {
        return mainGoal.subGoals
            .sorted(by: { $0.id < $1.id })
            .filter { !$0.title.isEmpty || !$0.detailGoals.allSatisfy { $0.title.isEmpty } }
    }
    
    // SubGoal에서 DetailGoal 필터링
    func filteredDetailGoals(from subGoal: SubGoal) -> [DetailGoal] {
        return subGoal.detailGoals.filter { !$0.title.isEmpty }
    }
    
    // 선택된 Picker에 해당하는 SubGoal 반환
    func selectedSubGoal(for mainGoal: MainGoal) -> SubGoal? {
        guard let subGoalId = subGoalId(for: selectedPicker) else { return nil }
        return mainGoal.subGoals.first { $0.id == subGoalId }
    }
    
    // SubGoal의 DetailGoals가 모두 비어 있는지 확인
    func isSubGoalEmpty(_ subGoal: SubGoal) -> Bool {
        return subGoal.title.isEmpty && subGoal.detailGoals.allSatisfy { $0.title.isEmpty }
    }
    
    // 전체루틴 5개 탭 햅틱
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    // WeekAchieveCell - alert 요일 확인
    func isAlertActive(for detailGoal: DetailGoal, at index: Int) -> Bool {
        switch index {
        case 0: return detailGoal.alertMon
        case 1: return detailGoal.alertTue
        case 2: return detailGoal.alertWed
        case 3: return detailGoal.alertThu
        case 4: return detailGoal.alertFri
        case 5: return detailGoal.alertSat
        case 6: return detailGoal.alertSun
        default: return false
        }
    }
    
    // WeekAchieveCell - 미래 요일인지 확인
    func isFutureDay(index: Int) -> Bool {
        let todayIndex = Date().mondayBasedIndex()
        return index > todayIndex
    }
    
    // WeekAchieveCell - 요일별 성취 상태 확인 메서드
    func isAchieved(for detailGoal: DetailGoal, at index: Int) -> Bool {
        switch index {
        case 0: return detailGoal.achieveMon
        case 1: return detailGoal.achieveTue
        case 2: return detailGoal.achieveWed
        case 3: return detailGoal.achieveThu
        case 4: return detailGoal.achieveFri
        case 5: return detailGoal.achieveSat
        case 6: return detailGoal.achieveSun
        default: return false
        }
    }
    
    // WeekAchieveCell - 성취했는데 지난요일들 클로버 종류별로 보여주기 위해 계산
    func calculateCumulativeAchieveCounts(for detailGoal: DetailGoal) -> [Int]  {
        var counts: [Int] = []
        var cumulativeCount = 0
        
        for index in 0..<days.count {
            if isAchieved(for: detailGoal, at: index) {
                cumulativeCount += 1
            }
            counts.append(cumulativeCount)
        }
        return counts
    }
    
    // WeekAchieveCell - 그라데이션 클로버 이미지 생성
    func setGradationClover(for achieveGoal: Int, achieveCount: Int) -> Image {
        // 주당 목표 횟수는 1 ~ 7로 가정
        guard achieveGoal >= 1 && achieveGoal <= 7 else {
            return Image("DefaultClover") // 기본 이미지 반환
        }
        // 달성 횟수는 목표 횟수(achieveGoal)를 초과하지 않도록 제한
        let validAchieveCount = max(1, min(achieveCount, achieveGoal)) // 최소값 1로 보정
        
        // 클로버 이미지 이름 생성 및 반환
        let cloverImageName = "Day\(achieveGoal)_Clover\(validAchieveCount)"
        return Image(cloverImageName)
    }
}
