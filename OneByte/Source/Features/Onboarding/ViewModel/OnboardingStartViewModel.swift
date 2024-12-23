//
//  OnboardingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

@Observable
class OnboardingStartViewModel {
    
    var navigationRouter = NavigationRouter()
    var nowOnboard: OnboardingExplain = .first
    var opacity = 0.0
    
    private let createService: CreateGoalUseCase
    init(createService: CreateGoalUseCase) {
        self.createService = createService
    }
    
    // GoalModel 전체 데이터 생성
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }
    
    // 2024년 11월 ~ 2026년 클로버 데이터 객체 전체 생성
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
            navigationRouter.push(to: .onboardReady)
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
    
    // 온보딩 TabView 페이지가 넘어갈때 자연스럽게 연결하기 위한 opacity 조절
    func setOpacity(selectedOnboarding: OnboardingExplain) {
        if selectedOnboarding == nowOnboard {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.opacity = 1.0
            }
        } else {
            self.opacity = 0.0
        }
    }
    
}
