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
    @Environment(\.modelContext) var modelContext
    
//    @Published var mainGoals: [MainGoal] = []
    @Published var subGoals: [SubGoal] = []
    
    private let createService: ClientCreateService
    
    init(createService: ClientCreateService = ClientCreateService()) {
        self.createService = createService
    }
    
    // 메인골 생성
    func createMainGoal(title: String) -> MainGoal {
        let newGoal = createService.createMainGoal(title: title, isAchieved: false)
        return newGoal
    }
    
    func createSubGoal(mainGoal: MainGoal, title: String) -> SubGoal? {
        let newSubGoal = createService.createSubGoal(mainGoal: mainGoal, title: title, isAchieved: false)
        return newSubGoal
    }
}
