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
    
    func updateMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String) {
        updateService.updateMainGoal(mainGoal: mainGoal, modelContext: modelContext, id: id, newTitle: newTitle)
        
    }
    
    func updateSubGoal(subGoal: SubGoal, modelContext: ModelContext, newTitle: String) {
        updateService.updateSubGoal(subGoal:subGoal, modelContext: modelContext, newTitle: newTitle)
    }
    
    func updateDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, newTitle: String, newMemo: String, isAchieved: Bool) {
        updateService.updateDetailGoal(detailGoal: detailGoal, modelContext: modelContext, newTitle: newTitle, newMemo: newMemo, isAchieved: isAchieved)
    }
    
    func deleteMainGoal(mainGoal: MainGoal, modelContext: ModelContext, id: Int, newTitle: String) {
        deleteService.deleteMainGoal(mainGoal: mainGoal, modelContext: modelContext, id: id, newTitle: newTitle)
    }
    
    func deleteSubGoal(subGoal: SubGoal, modelContext: ModelContext, id: Int, newTitle: String) {
        deleteService.deleteSubGoal(subGoal: subGoal, modelContext: modelContext, newTitle: newTitle)
    }
    
    func deleteDetailGoal(detailGoal: DetailGoal, modelContext: ModelContext, id: Int, newTitle: String, newMemo: String, isAcheived: Bool) {
        deleteService.deleteDetailGoal(detailGoal: detailGoal, modelContext: modelContext, newTitle: newTitle, newMemo: newMemo, isAchieved: isAcheived)
    }
}
