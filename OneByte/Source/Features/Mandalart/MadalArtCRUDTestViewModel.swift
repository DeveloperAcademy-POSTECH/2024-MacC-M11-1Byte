//
//  MadalArtCRUDTestViewModel.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

import SwiftUI
import SwiftData

//@Observable
class CUTestViewModel: ObservableObject, CreateGoalUseCase {
//    @Environment(\.modelContext) var modelContext
    //    @Published var mainGoals: [MainGoal] = [] no
//    @Published var subGoals: [SubGoal] = []
//    @Published var detailGoals: [DetailGoal] = []
    
    private let createService: ClientCreateService
    
    init(createService: ClientCreateService = ClientCreateService()) {
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
}
