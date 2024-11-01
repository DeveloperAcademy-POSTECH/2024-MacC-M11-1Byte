//
//  MadalArtCRUDTestViewModel.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

import SwiftUI
import SwiftData

//@Observable
class CUTestViewModel: ObservableObject {
    private let createService: CreateGoalUseCase
//    private let updateService: UpdateGoalUseCase
    
    init(createService: CreateGoalUseCase) {
        self.createService = createService
        
    }
    
    // 메인골 생성
    func createMainGoal(modelContext: ModelContext, title: String, isAchieved: Bool) {
        let newGoal = createService.createMainGoal(title: title, isAchieved: false)
        modelContext.insert(newGoal)
//        return newGoal
    }
    
    // 서브골 생성
    func createSubGoal(modelContext: ModelContext, mainGoal: MainGoal, title: String, isAchieved: Bool) {
        guard let newSubGoal = createService.createSubGoal(mainGoal: mainGoal, title: title, isAchieved: false) else { return }
        modelContext.insert(newSubGoal)
    }
    
    // 디테일골 생성
    func createDetailGoal(modelContext: ModelContext, subGoal: SubGoal, title: String, isAchieved: Bool) {
        guard let newDetailGoal = createService.createDetailGoal(subGoal: subGoal, title: title, isAchieved: false) else { return }
        modelContext.insert(newDetailGoal)
    }
    
//    // 메인골 업데이트
//        func updateMainGoal(id: UUID, newTitle: String, isAchieved: Bool) -> MainGoal? {
//            return updateService.updateMainGoal(id: id, newTitle: newTitle, isAchieved: isAchieved)
//        }
//        
//        // 서브골 업데이트
//        func updateSubGoal(id: UUID, newTitle: String, isAchieved: Bool) -> SubGoal? {
//            return updateService.updateSubGoal(id: id, newTitle: newTitle, isAchieved: isAchieved)
//        }
//        
//        // 디테일골 업데이트
//        func updateDetailGoal(id: UUID, newTitle: String, isAchieved: Bool) -> DetailGoal? {
//            return updateService.updateDetailGoal(id: id, newTitle: newTitle, isAchieved: isAchieved)
//        }
}
