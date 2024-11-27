//
//  MadalArtCRUDTestViewModel.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

// CUTestViewModel.swift
import SwiftUI
import SwiftData

class MandalartViewModel: ObservableObject {
    @Published var mainGoal: MainGoal?
    
    private let createService: CreateGoalUseCase
    private let updateService: UpdateGoalUseCase
    private let deleteService: DeleteService
    
    init(createService: CreateGoalUseCase, updateService: UpdateGoalUseCase, deleteService: DeleteService ) {
        self.createService = createService
        self.updateService = updateService
        self.deleteService = deleteService
    }
    
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }
    
    func updateMainGoal(mainGoal: MainGoal,id: Int, newTitle: String, cloverState: Int) {
        updateService.updateMainGoal(mainGoal: mainGoal, id: id, newTitle: newTitle, cloverState: cloverState)
    }
    
    func updateSubGoal(subGoal: SubGoal, newTitle: String, category: String) {
        updateService.updateSubGoal(subGoal:subGoal,newTitle: newTitle, category: category)
    }
    
    func updateDetailGoal(detailGoal: DetailGoal, newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, isMorning: Bool, isAfternoon: Bool, isEvening: Bool, isNight: Bool, isFree: Bool) {
        updateService.updateDetailGoal(
            detailGoal: detailGoal,
            title: newTitle,
            memo: newMemo,
            achieveCount: achieveCount,
            achieveGoal: achieveGoal,
            alertMon: alertMon,
            alertTue: alertTue,
            alertWed: alertWed,
            alertThu: alertThu,
            alertFri: alertFri,
            alertSat: alertSat,
            alertSun: alertSun,
            isRemind: isRemind,
            remindTime: remindTime,
            achieveMon: achieveMon,
            achieveTue: achieveTue,
            achieveWed: achieveWed,
            achieveThu: achieveThu,
            achieveFri: achieveFri,
            achieveSat: achieveSat,
            achieveSun: achieveSun,
            isMorning: isMorning,
            isAfternoon: isAfternoon,
            isEvening: isEvening,
            isNight: isNight,
            isFree: isFree
        )
    }
    
    func deleteMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String, cloverState: Int) {
        deleteService.deleteMainGoal(mainGoal: mainGoal, modelContext: modelContext, id: id, newTitle: newTitle, cloverState: cloverState)
    }
    
    func deleteSubGoal(subGoal: SubGoal, id: Int, newTitle: String, category: String) {
        deleteService.deleteSubGoal(subGoal: subGoal, newTitle: newTitle, category: category)
    }
    
    func deleteDetailGoal(detailGoal: DetailGoal,newTitle: String, newMemo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool, isMorning: Bool, isAfternoon: Bool, isEvening: Bool, isNight: Bool, isFree: Bool) {
        deleteService.deleteDetailGoal(
            detailGoal: detailGoal,
            title: newTitle, memo: newMemo,
            achieveCount: achieveCount,
            achieveGoal: achieveGoal,
            alertMon: alertMon,
            alertTue: alertTue,
            alertWed: alertWed,
            alertThu: alertThu,
            alertFri: alertFri,
            alertSat: alertSat,
            alertSun: alertSun,
            isRemind: isRemind,
            remindTime: remindTime,
            achieveMon: achieveMon,
            achieveTue: achieveTue,
            achieveWed: achieveWed,
            achieveThu: achieveThu,
            achieveFri: achieveFri,
            achieveSat: achieveSat,
            achieveSun: achieveSun,
            isMorning: isMorning,
            isAfternoon: isAfternoon,
            isEvening: isEvening,
            isNight: isNight,
            isFree: isFree
        )
    }
    
    func resetAllData(modelContext: ModelContext, mainGoal: MainGoal) {
        deleteService.resetAllData(modelContext: modelContext, mainGoal: mainGoal)
    }
    
    func initializeSubGoal(subGoal: SubGoal?, categories: [String]) -> (String, Bool) {
        guard let subGoal = subGoal else {
            return ("", false) // 기본값 반환
        }
        
        let category = subGoal.category
        
        // 저장된 카테고리가 categories에 없으면 "기타" 활성화
        let isCustomCategoryActive = !categories.contains(category) && !category.isEmpty
        
        return (category, isCustomCategoryActive)
    }
    
    // MARK: - Time Period Management
    func setTimePeriod(detailGoal: DetailGoal, selectedPeriod: String) {
        // 초기화: 모든 시간대는 false로 설정
        detailGoal.isMorning = false
        detailGoal.isAfternoon = false
        detailGoal.isEvening = false
        detailGoal.isNight = false
        detailGoal.isFree = false
        
        // 선택된 시간대만 true로 설정
        switch selectedPeriod {
        case "Morning":
            detailGoal.isMorning = true
        case "Afternoon":
            detailGoal.isAfternoon = true
        case "Evening":
            detailGoal.isEvening = true
        case "Night":
            detailGoal.isNight = true
        case "Free":
            detailGoal.isFree = true
        default:
            break
        }
    }
}
