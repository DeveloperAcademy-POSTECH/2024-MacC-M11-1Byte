//
//  MadalArtCRUDTestViewModel.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

// CUTestViewModel.swift
import SwiftUI
import SwiftData

class CUTestViewModel: ObservableObject {
    private let createService: CreateGoalUseCase
    
    init(createService: CreateGoalUseCase) {
        self.createService = createService
    }
    
    // 메인골 생성
    func createMainGoal(modelContext: ModelContext, id: Int, title: String, goalYear: Int, createdTime: Date, modifiedTime: Date, subGoals: [SubGoal]) {
        let newGoal = createService.createMainGoal(id: id, title: title, goalYear: goalYear, createdTime: createdTime, modifiedTime: modifiedTime, subGoals: subGoals)
        modelContext.insert(newGoal)
    }
    
    // 서브골 생성
    func createSubGoal(modelContext: ModelContext, id: Int, title: String, memo: String, createdTime: Date, modifiedTime: Date, mainGoalId: Int, detailGoals: [DetailGoal]) {
        let newSubGoal = createService.createSubGoal(id: id, title: title, memo: memo, createdTime: createdTime, modifiedTime: modifiedTime, mainGoalId: mainGoalId, detailGoals: detailGoals)
        modelContext.insert(newSubGoal)
    }
    
    // 디테일골 생성\
    func createDetailGoal(modelContext: ModelContext, id: Int, title: String, memo: String, isAchieved: Bool, createdTime: Date, modifiedTime: Date, subGoalId: Int) {
        let newDetailGoal = createService.createDetailGoal(id: id, title: title, memo: memo, isAchieved: isAchieved, createdTime: createdTime, modifiedTime: modifiedTime, subGoalId: subGoalId)
        modelContext.insert(newDetailGoal)
    }
    
    func saveGoalsFromJSON(jsonString: String, modelContext: ModelContext) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error converting JSON string to Data")
            return
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            if let json = jsonObject {
                createService.saveGoalsFromJSON(json: json, modelContext: modelContext)
            } else {
                print("Error: JSON parsing resulted in nil")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
}
