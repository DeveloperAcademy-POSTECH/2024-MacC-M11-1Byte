//
//  File.swift
//  OneByte
//
//  Created by 이상도 on 10/30/24.
//

// ClientCreateService.swift
import SwiftUI
import SwiftData

class ClientCreateService: CreateGoalUseCase {
    
    func createMainGoal(id: Int, title: String, goalYear: Int, createdTime: Date, modifiedTime: Date, subGoals: [SubGoal]) -> MainGoal {
        return MainGoal(id: id, title: title, goalYear: goalYear, createdTime: createdTime, modifiedTime: modifiedTime, subGoals: subGoals)
    }
    
    func createSubGoal(id: Int, title: String, memo: String, createdTime: Date, modifiedTime: Date, mainGoalId: Int, detailGoals: [DetailGoal]) -> SubGoal {
        return SubGoal(id: id, title: title, memo: memo, createdTime: createdTime, modifiedTime: modifiedTime, mainGoalId: mainGoalId, detailGoals: detailGoals)
    }
    
    func createDetailGoal(id: Int, title: String, memo: String, isAchieved: Bool, createdTime: Date, modifiedTime: Date, subGoalId: Int) -> DetailGoal {
        return DetailGoal(id: id, title: title, memo: memo, isAchieved: isAchieved, createdTime: createdTime, modifiedTime: modifiedTime, subGoalId: subGoalId)
    }
    
    func saveGoalsFromJSON(json: [String: Any], modelContext: ModelContext) {
        guard let mainGoalsArray = json["mainGoals"] as? [[String: Any]] else { return }
        
        for mainGoalDict in mainGoalsArray {
            if let mainGoalId = mainGoalDict["id"] as? Int,
               let title = mainGoalDict["title"] as? String,
               let goalYear = mainGoalDict["goalYear"] as? Int,
               let createdTimeString = mainGoalDict["createdTime"] as? String,
               let modifiedTimeString = mainGoalDict["modifiedTime"] as? String,
               let createdTime = ISO8601DateFormatter().date(from: createdTimeString),
               let modifiedTime = ISO8601DateFormatter().date(from: modifiedTimeString),
               let subGoalsArray = mainGoalDict["subGoals"] as? [[String: Any]] {
                
                var subGoals: [SubGoal] = []
                
                // JSON 순서대로 subGoals 생성
                for subGoalDict in subGoalsArray {
                    if let subGoalId = subGoalDict["id"] as? Int,
                       let title = subGoalDict["title"] as? String,
                       let memo = subGoalDict["memo"] as? String,
                       let subCreatedTimeString = subGoalDict["createdTime"] as? String,
                       let subModifiedTimeString = subGoalDict["modifiedTime"] as? String,
                       let subCreatedTime = ISO8601DateFormatter().date(from: subCreatedTimeString),
                       let subModifiedTime = ISO8601DateFormatter().date(from: subModifiedTimeString),
                       let detailGoalsArray = subGoalDict["detailGoals"] as? [[String: Any]] {
                        
                        var detailGoals: [DetailGoal] = []
                        
                        // JSON 순서대로 detailGoals 생성
                        for detailGoalDict in detailGoalsArray {
                            if let detailGoalId = detailGoalDict["id"] as? Int,
                               let title = detailGoalDict["title"] as? String,
                               let memo = detailGoalDict["memo"] as? String,
                               let isAchieved = detailGoalDict["isAchieved"] as? Bool,
                               let detailCreatedTimeString = detailGoalDict["createdTime"] as? String,
                               let detailModifiedTimeString = detailGoalDict["modifiedTime"] as? String,
                               let detailCreatedTime = ISO8601DateFormatter().date(from: detailCreatedTimeString),
                               let detailModifiedTime = ISO8601DateFormatter().date(from: detailModifiedTimeString) {
                                
                                let detailGoal = createDetailGoal(id: detailGoalId, title: title, memo: memo, isAchieved: isAchieved, createdTime: detailCreatedTime, modifiedTime: detailModifiedTime, subGoalId: subGoalId)
                                detailGoals.append(detailGoal)
                            }
                        }
                        
                        let subGoal = createSubGoal(id: subGoalId, title: title, memo: memo, createdTime: subCreatedTime, modifiedTime: subModifiedTime, mainGoalId: mainGoalId, detailGoals: detailGoals)
                        subGoals.append(subGoal)
                    }
                }
                
                let mainGoal = createMainGoal(id: mainGoalId, title: title, goalYear: goalYear, createdTime: createdTime, modifiedTime: modifiedTime, subGoals: subGoals)
                modelContext.insert(mainGoal)
            }
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving goals from JSON: \(error)")
        }
    }
}
