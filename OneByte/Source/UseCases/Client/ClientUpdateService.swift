////
////  ClientUpdateService.swift
////  OneByte
////
////  Created by 이상도 on 10/30/24.
////
//
//import Foundation
//
//class ClientUpdateService: UpdateGoalUseCase {
//    // 업데이트할 데이터
//    var mainGoals: [MainGoal]
//    var subGoals: [SubGoal]
//    var detailGoals: [DetailGoal]
//    
//    init(mainGoals: [MainGoal], subGoals: [SubGoal], detailGoals: [DetailGoal]) {
//        self.mainGoals = mainGoals
//        self.subGoals = subGoals
//        self.detailGoals = detailGoals
//    }
//    
//    // MainGoal 업데이트
//    func updateMainGoal(id: UUID, newTitle: String, isAchieved: Bool) -> MainGoal? {
//        guard let index = mainGoals.firstIndex(where: { $0.id == id }) else { return nil }
//        mainGoals[index].title = newTitle
//        mainGoals[index].isAchieved = isAchieved
//        return mainGoals[index]
//    }
//    
//    // SubGoal 업데이트
//    func updateSubGoal(id: UUID, newTitle: String, isAchieved: Bool) -> SubGoal? {
//        guard let index = subGoals.firstIndex(where: { $0.id == id }) else { return nil }
//        subGoals[index].title = newTitle
//        subGoals[index].isAchieved = isAchieved
//        return subGoals[index]
//    }
//    
//    // DetailGoal 업데이트
//    func updateDetailGoal(id: UUID, newTitle: String, isAchieved: Bool) -> DetailGoal? {
//        guard let index = detailGoals.firstIndex(where: { $0.id == id }) else { return nil }
//        detailGoals[index].title = newTitle
//        detailGoals[index].isAchieved = isAchieved
//        return detailGoals[index]
//    }
//}
