//
//  MadalArtCRUDTestViewModel.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

import SwiftUI
import SwiftData

//@Observable
class MadalArtCRUDTestViewModel: ObservableObject {
    @Published var mainGoals: [MainGoal]
    private let createService: ClientCreateService
    
    init(mainGoals: [MainGoal] = [], createService: ClientCreateService = ClientCreateService()) {
        self.mainGoals = mainGoals
        self.createService = createService
    }
    
//    func addMainGoal(id: UUID, title: String, isAchieved: Bool, subGoals: [ SubGoal]) {
//        let newMainGoal = createService.createMainGoal(title: title, isAchieved: false, subGoals: [])
//        mainGoals.append(newMainGoal)
//    }
    func createMainGoal(title: String) -> MainGoal {
        let newGoal = createService.createMainGoal(title: title, isAchieved: false, subGoals: [])
        mainGoals.append(newGoal)
        return newGoal
    }
}
