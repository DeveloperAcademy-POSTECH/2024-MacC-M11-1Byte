//
//  OnboardingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

class OnboardingViewModel: ObservableObject {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query var mainGoals: [MainGoal]
    @Query var subGoals: [SubGoal]
    @Query var detailGoals: [DetailGoal]
    
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
    func updateSubGoal(subGoal: SubGoal, newTitle: String, leafState: Int) {
        updateService.updateSubGoal(
            subGoal: subGoal,
            newTitle: newTitle,
            leafState: leafState
        )
    }
    
    // SubGoal 업데이트
    func updateDetailGoal(detailGoal: DetailGoal, newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool) {
        updateService.updateDetailGoal(detailGoal: detailGoal, title: newTitle, memo: newMemo, achieveCount: achieveCount, achieveGoal: achieveGoal, alertMon: alertMon, alertTue: alertTue, alertWed: alertWed, alertThu: alertThu, alertFri: alertFri, alertSat: alertSat, alertSun: alertSun, isRemind: isRemind, remindTime: remindTime, achieveMon: achieveMon, achieveTue: achieveTue, achieveWed: achieveWed, achieveThu: achieveThu, achieveFri: achieveFri, achieveSat: achieveFri, achieveSun: achieveSun)
        
    }
    
    // 2024년 11월 ~ 2026년 클로버 데이터 객체 생성
    func createAllCloverData(modelContext: ModelContext) {
        var idCounter = 1
        
        let data = [
            // 2024년
            (2024, 11, 45, 1), (2024, 11, 46, 2), (2024, 11, 47, 3), (2024, 11, 48, 4),
            (2024, 12, 49, 1), (2024, 12, 50, 2), (2024, 12, 51, 3), (2024, 12, 52, 4),
            // 2025년
            (2025, 1, 1, 1), (2025, 1, 2, 2), (2025, 1, 3, 3), (2025, 1, 4, 4), (2025, 1, 5, 5),
            (2025, 2, 6, 1), (2025, 2, 7, 2), (2025, 2, 8, 3), (2025, 2, 9, 4),
            (2025, 3, 10, 1), (2025, 3, 11, 2), (2025, 3, 12, 3), (2025, 3, 13, 4),
            (2025, 4, 14, 1), (2025, 4, 15, 2), (2025, 4, 16, 3), (2025, 4, 17, 4),
            (2025, 5, 18, 1), (2025, 5, 19, 2), (2025, 5, 20, 3), (2025, 5, 21, 4), (2025, 5, 22, 5),
            (2025, 6, 23, 1), (2025, 6, 24, 2), (2025, 6, 25, 3), (2025, 6, 26, 4),
            (2025, 7, 27, 1), (2025, 7, 28, 2), (2025, 7, 29, 3), (2025, 7, 30, 4), (2025, 7, 31, 5),
            (2025, 8, 32, 1), (2025, 8, 33, 2), (2025, 8, 34, 3), (2025, 8, 35, 4),
            (2025, 9, 36, 1), (2025, 9, 37, 2), (2025, 9, 38, 3), (2025, 9, 39, 4),
            (2025, 10, 40, 1), (2025, 10, 41, 2), (2025, 10, 42, 3), (2025, 10, 43, 4), (2025, 10, 44, 5),
            (2025, 11, 45, 1), (2025, 11, 46, 2), (2025, 11, 47, 3), (2025, 11, 48, 4),
            (2025, 12, 49, 1), (2025, 12, 50, 2), (2025, 12, 51, 3), (2025, 12, 52, 4),
            // 2026년
            (2026, 1, 1, 1), (2026, 1, 2, 2), (2026, 1, 3, 3), (2026, 1, 4, 4), (2026, 1, 5, 5),
            (2026, 2, 6, 1), (2026, 2, 7, 2), (2026, 2, 8, 3), (2026, 2, 9, 4),
            (2026, 3, 10, 1), (2026, 3, 11, 2), (2026, 3, 12, 3), (2026, 3, 13, 4),
            (2026, 4, 14, 1), (2026, 4, 15, 2), (2026, 4, 16, 3), (2026, 4, 17, 4), (2026, 4, 18, 5),
            (2026, 5, 19, 1), (2026, 5, 20, 2), (2026, 5, 21, 3), (2026, 5, 22, 4),
            (2026, 6, 23, 1), (2026, 6, 24, 2), (2026, 6, 25, 3), (2026, 6, 26, 4),
            (2026, 7, 27, 1), (2026, 7, 28, 2), (2026, 7, 29, 3), (2026, 7, 30, 4), (2026, 7, 31, 5),
            (2026, 8, 32, 1), (2026, 8, 33, 2), (2026, 8, 34, 3), (2026, 8, 35, 4),
            (2026, 9, 36, 1), (2026, 9, 37, 2), (2026, 9, 38, 3), (2026, 9, 39, 4),
            (2026, 10, 40, 1), (2026, 10, 41, 2), (2026, 10, 42, 3), (2026, 10, 43, 4), (2026, 10, 44, 5),
            (2026, 11, 45, 1), (2026, 11, 46, 2), (2026, 11, 47, 3), (2026, 11, 48, 4),
            (2026, 12, 49, 1), (2026, 12, 50, 2), (2026, 12, 51, 3), (2026, 12, 52, 4), (2026, 12, 53, 5)
        ]
        
        for (year, month, weekOfYear, weekOfMonth) in data {
            let clover = Clover(
                id: idCounter,
                cloverYear: year,
                cloverMonth: month,
                cloverWeekOfMonth: weekOfMonth,
                cloverWeekOfYear: weekOfYear,
                cloverState: 0
            )
            modelContext.insert(clover) // SwiftData에 저장
            idCounter += 1
        }
        
        do {
            try modelContext.save() // 데이터 save
            print("✅ Clover 데이터가 성공적으로 생성되었습니다.")
        } catch {
            print("❌ SwiftData 저장 중 오류 발생: \(error)")
        }
    }
    
}
