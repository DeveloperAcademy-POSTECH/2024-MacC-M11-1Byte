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
    func createMainGoal(title: String, isAchieved: Bool) -> MainGoal {
        let newGoal = createService.createMainGoal(title: title, isAchieved: false)
        return newGoal
    }
    
    // 서브골 생성
    func createSubGoal(mainGoal: MainGoal, title: String, isAchieved: Bool) -> SubGoal? {
        let newSubGoal = createService.createSubGoal(mainGoal: mainGoal, title: title, isAchieved: false)
        return newSubGoal
    }
    
    // 디테일골 생성
    func createDetailGoal(subGoal: SubGoal, title: String, isAchieved: Bool) -> DetailGoal? {
        let newDetailGoal = createService.createDetailGoal(subGoal: subGoal, title: title, isAchieved: false)
        return newDetailGoal
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
