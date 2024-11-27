//
//  OnboardingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

@Observable
class OnboardingViewModel {
    
    //    @Environment(\.modelContext) private var modelContext
    
    //    @Query var mainGoals: [MainGoal]
    //    @Query var subGoals: [SubGoal]
    //    @Query var detailGoals: [DetailGoal]
    var navigationManager = NavigationManager()
    var nowOnboard: OnboardingExplain = .first
    private let createService: CreateGoalUseCase
    private let updateService: UpdateGoalUseCase
    
    init(createService: CreateGoalUseCase, updateService: UpdateGoalUseCase ) {
        self.createService = createService
        self.updateService = updateService
    }
    
    // Goals 전체 데이터 생성
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }
    
    // MainGoal 업데이트
    func updateMainGoal(mainGoals: [MainGoal], userMainGoal: String, cloverState: Int ) {
        guard let mainGoal = mainGoals.first else {
            print("Error: mainGoal이 nil입니다.")
            return
        }
        
        updateService.updateMainGoal(
            mainGoal: mainGoal,
            id: mainGoal.id,
            newTitle: userMainGoal,
            cloverState: cloverState
        )
    }
    
    // SubGoal 업데이트
    func updateSubGoal(subGoal: SubGoal, newTitle: String, category: String) {
        updateService.updateSubGoal(
            subGoal: subGoal,
            newTitle: newTitle,
            category: category
        )
    }
    
    // DetailGoal 업데이트
    func updateDetailGoal(detailGoal: DetailGoal, newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, isMorning: Bool, isAfternoon: Bool, isEvening: Bool, isNight: Bool, isFree: Bool) {
        updateService.updateDetailGoal(detailGoal: detailGoal, title: newTitle, memo: newMemo, achieveCount: achieveCount, achieveGoal: achieveGoal, alertMon: alertMon, alertTue: alertTue, alertWed: alertWed, alertThu: alertThu, alertFri: alertFri, alertSat: alertSat, alertSun: alertSun, isRemind: isRemind, remindTime: remindTime, achieveMon: achieveMon, achieveTue: achieveTue, achieveWed: achieveWed, achieveThu: achieveThu, achieveFri: achieveFri, achieveSat: achieveFri, achieveSun: achieveSun, isMorning: isMorning, isAfternoon: isAfternoon, isEvening: isEvening, isNight: isNight, isFree: isFree)
        
    }
    
    // 2024년 11월 ~ 2026년 클로버 데이터 객체 생성
    func createAllCloverData(modelContext: ModelContext) {
        var idCounter = 1
        
        let data = [
            // 2024년 ( 연도 / 월 / 월차 / 주차 / 클로버 스테이트 0 )
            (2024, 11, 1, 45, 0), (2024, 11, 2, 46, 0), (2024, 11, 3, 47, 0), (2024, 11, 4, 48, 0),
            (2024, 12, 1, 49, 0), (2024, 12, 2, 50, 0), (2024, 12, 3, 51, 0), (2024, 12, 4, 52, 0),
            // 2025년
            (2025, 1, 1, 1, 0), (2025, 1, 2, 2, 0), (2025, 1, 3, 3, 0), (2025, 1, 4, 4, 0), (2025, 1, 5, 5, 0),
            (2025, 2, 1, 6, 0), (2025, 2, 2, 7, 0), (2025, 2, 3, 8, 0), (2025, 2, 4, 9, 0),
            (2025, 3, 1, 10, 0), (2025, 3, 2, 11, 0), (2025, 3, 3, 12, 0), (2025, 3, 4, 13, 0),
            (2025, 4, 1, 14, 0), (2025, 4, 2, 15, 0), (2025, 4, 3, 16, 0), (2025, 4, 4, 17, 0),
            (2025, 5, 1, 18, 0), (2025, 5, 2, 19, 0), (2025, 5, 3, 20, 0), (2025, 5, 4, 21, 0), (2025, 5, 5, 22, 0),
            (2025, 6, 1, 23, 0), (2025, 6, 2, 24, 0), (2025, 6, 3, 25, 0), (2025, 6, 4, 26, 0),
            (2025, 7, 1, 27, 0), (2025, 7, 2, 28, 0), (2025, 7, 3, 29, 0), (2025, 7, 4, 30, 0), (2025, 7, 5, 31, 0),
            (2025, 8, 1, 32, 0), (2025, 8, 2, 33, 0), (2025, 8, 3, 34, 0), (2025, 8, 4, 35, 0),
            (2025, 9, 1, 36, 0), (2025, 9, 2, 37, 0), (2025, 9, 3, 38, 0), (2025, 9, 4, 39, 0),
            (2025, 10, 1, 40, 0), (2025, 10, 2, 41, 0), (2025, 10, 3, 42, 0), (2025, 10, 4, 43, 0), (2025, 10, 5, 44, 0),
            (2025, 11, 1, 45, 0), (2025, 11, 2, 46, 0), (2025, 11, 3, 47, 0), (2025, 11, 4, 48, 0),
            (2025, 12, 1, 49, 0), (2025, 12, 2, 50, 0), (2025, 12, 3, 51, 0), (2025, 12, 4, 52, 0),
            // 2026년
            (2026, 1, 1, 1, 0), (2026, 1, 2, 2, 0), (2026, 1, 4, 3, 0), (2026, 1, 3, 4, 0), (2026, 1, 5, 5, 0),
            (2026, 2, 1, 6, 0), (2026, 2, 2, 7, 0), (2026, 2, 4, 8, 0), (2026, 2, 3, 9, 0),
            (2026, 3, 1, 10, 0), (2026, 3, 2, 11, 0), (2026, 3, 4, 12, 0), (2026, 3, 3, 13, 0),
            (2026, 4, 1, 14, 0), (2026, 4, 2, 15, 0), (2026, 4, 4, 16, 0), (2026, 4, 3, 17, 0), (2026, 4, 5, 18, 0),
            (2026, 5, 1, 19, 0), (2026, 5, 2, 20, 0), (2026, 5, 4, 21, 0), (2026, 5, 3, 22, 0),
            (2026, 6, 1, 23, 0), (2026, 6, 2, 24, 0), (2026, 6, 4, 25, 0), (2026, 6, 3, 26, 0),
            (2026, 7, 1, 27, 0), (2026, 7, 2, 28, 0), (2026, 7, 4, 29, 0), (2026, 7, 3, 30, 0), (2026, 7, 5, 31, 0),
            (2026, 8, 1, 32, 0), (2026, 8, 2, 33, 0), (2026, 8, 4, 34, 0), (2026, 8, 3, 35, 0),
            (2026, 9, 1, 36, 0), (2026, 9, 2, 37, 0), (2026, 9, 4, 38, 0), (2026, 9, 3, 39, 0),
            (2026, 10, 1, 40, 0), (2026, 10, 2, 41, 0), (2026, 10, 4, 42, 0), (2026, 10, 3, 43, 0), (2026, 10, 5, 44, 0),
            (2026, 11, 1, 45, 0), (2026, 11, 2, 46, 0), (2026, 11, 4, 47, 0), (2026, 11, 3, 48, 0),
            (2026, 12, 1, 49, 0), (2026, 12, 2, 50, 0), (2026, 12, 4, 51, 0), (2026, 12, 3, 52, 0), (2026, 12, 5, 53, 0)
        ]
        
        for (year, month, weekOfMonth, weekOfYear, nowCloverState) in data {
            let clover = Clover(
                id: idCounter,
                cloverYear: year,
                cloverMonth: month,
                cloverWeekOfMonth: weekOfMonth,
                cloverWeekOfYear: weekOfYear,
                cloverState: nowCloverState
            )
            modelContext.insert(clover) // SwiftData에 저장
            idCounter += 1
        }
        
        do {
            try modelContext.save() // 데이터 save
            print("✅ Clover 데이터가 성공적으로 생성되었습니다. \(Date()) \(#function) \(#line)")
        } catch {
            print("❌ SwiftData 저장 중 오류 발생: \(error)")
        }
    }
    
    // OnboardingExplainPage에서 버튼으로 탭 이동
    func moveToNextPage() {
        // 마지막 온보딩 페이지인지 확인
        if nowOnboard == OnboardingExplain.allCases.last {
            // 네비게이션으로 이동
            navigationManager.push(to: .onboardReady)
        } else {
            // 다음 페이지로 이동
            if let currentIndex = OnboardingExplain.allCases.firstIndex(of: nowOnboard),
               currentIndex + 1 < OnboardingExplain.allCases.count {
                nowOnboard = OnboardingExplain.allCases[currentIndex + 1]
            }
        }
    }
    
    // 한국 기준, 설치일 저장 함수
    func setInstallDate() {
        let userInstallDateKey = "userInstallDate"
        let koreanTimeString = Date().userInstallSeoulTime
        UserDefaults.standard.set(koreanTimeString, forKey: userInstallDateKey)
        
        if let savedDate = UserDefaults.standard.string(forKey: userInstallDateKey) {
            print("✅ 앱 설치일 저장됨 (한국시간): \(savedDate)  \(Date()) \(#function) \(#line)")
        } else {
            print("❌ 앱 설치일 저장 실패")
        }
    }
}
