//
//  DeleteService.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import Foundation
import SwiftData
import UserNotifications

class DeleteService: DeleteGoalUseCase {
    // 업데이트할 데이터
    var mainGoals: [MainGoal]
    var subGoals: [SubGoal]
    var detailGoals: [DetailGoal]
    
    init(mainGoals: [MainGoal], subGoals: [SubGoal], detailGoals: [DetailGoal]) {
        self.mainGoals = mainGoals
        self.subGoals = subGoals
        self.detailGoals = detailGoals
    }
    
    func deleteMainGoal(mainGoal: MainGoal) {
        mainGoal.title = ""
        mainGoal.cloverState = 0
    }
    
    func deleteSubGoal(subGoal: SubGoal) {
        subGoal.title = ""
        subGoal.category = ""
    }
    
    func deleteSubDetailGoals(subGoal: SubGoal) {
        subGoal.title = ""
        subGoal.category = ""
        
        for detailGoal in subGoal.detailGoals {
            let identifier = "\(detailGoal.id)"
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            
            // 디버깅: 현재 등록된 알림 확인
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                for request in requests {
                    print("현재 등록된 알림: \(request.identifier)")
                }
            }
        }
        for detailGoal in subGoal.detailGoals {
            detailGoal.title = ""
            detailGoal.memo = ""
            detailGoal.achieveCount = 0
            detailGoal.achieveGoal = 0
            detailGoal.alertMon = false
            detailGoal.alertTue = false
            detailGoal.alertWed  = false
            detailGoal.alertThu = false
            detailGoal.alertFri = false
            detailGoal.alertSat = false
            detailGoal.alertSun = false
            detailGoal.isMorning = true
            detailGoal.isAfternoon = false
            detailGoal.isEvening = false
            detailGoal.isNight = false
            detailGoal.isFree = false
        }
    }
    
    func deleteDetailGoal(detailGoal: DetailGoal) {
        let identifier = "\(detailGoal.id)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // 디버깅: 현재 등록된 알림 확인
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("현재 등록된 알림: \(request.identifier)")
            }
        }
        
        detailGoal.title = ""
        detailGoal.memo = ""
        detailGoal.achieveCount = 0
        detailGoal.achieveGoal = 0
        detailGoal.alertMon = false
        detailGoal.alertTue = false
        detailGoal.alertWed  = false
        detailGoal.alertThu = false
        detailGoal.alertFri = false
        detailGoal.alertSat = false
        detailGoal.alertSun = false
        detailGoal.isRemind = false
        detailGoal.remindTime = nil
        detailGoal.achieveMon = false
        detailGoal.achieveTue = false
        detailGoal.achieveWed = false
        detailGoal.achieveThu = false
        detailGoal.achieveFri = false
        detailGoal.achieveSat = false
        detailGoal.achieveSun = false
        detailGoal.isMorning = true
        detailGoal.isAfternoon = false
        detailGoal.isEvening = false
        detailGoal.isNight = false
        detailGoal.isFree = false
    }
    
    // 이 부분은 알림 끄기만 했을 때 사용
    func deleteNotification(detailGoal: DetailGoal) {
        let identifier = "\(detailGoal.id)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        
        // 디버깅: 현재 등록된 알림 확인
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("현재 등록된 알림: \(request.identifier)")
            }
        }
    }
    func resetAllData(modelContext: ModelContext, mainGoal: MainGoal) {
        mainGoal.title = ""  // MainGoal의 타이틀 초기화
        
        // 모든 SubGoal 초기화
        for subGoal in mainGoal.subGoals {
            subGoal.title = ""
            
            // 각 SubGoal에 연결된 DetailGoal 초기화
            for detailGoal in subGoal.detailGoals {
                detailGoal.title = ""
                detailGoal.memo = ""
                detailGoal.achieveCount = 0
                detailGoal.achieveGoal = 0
                detailGoal.alertMon = false
                detailGoal.alertTue = false
                detailGoal.alertWed  = false
                detailGoal.alertThu = false
                detailGoal.alertFri = false
                detailGoal.alertSat = false
                detailGoal.alertSun = false
                detailGoal.isMorning = true
                detailGoal.isAfternoon = false
                detailGoal.isEvening = false
                detailGoal.isNight = false
                detailGoal.isFree = false
            }
        }
    }
    
}
