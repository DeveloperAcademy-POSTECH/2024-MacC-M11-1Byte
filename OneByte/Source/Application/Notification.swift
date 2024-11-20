//
//  Notification.swift
//  OneByte
//
//  Created by 트루디 on 11/20/24.
//

import UserNotifications

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error.localizedDescription)")
        } else {
            print(granted ? "Permission granted" : "Permission denied")
        }
    }
}

func scheduleNotification(for title: String, on days: [String], at time: Date) {
    let center = UNUserNotificationCenter.current()
    
    // 알림 식별자 설정
    let identifier = "\(title)-\(days.joined(separator: ","))"
    
    // 알림 내용
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = "설정한 루틴을 실행할 시간이에요!"
    content.sound = .default
    
    // 알림 트리거 생성 (예: 매주 특정 요일 및 시간)
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.hour, .minute], from: time)
    
    // 요일 반복 처리
    for day in days {
        var triggerComponents = dateComponents
        triggerComponents.weekday = dayToWeekday(day) // 요일을 숫자로 변환
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
        
        // 요청 생성 및 추가
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("알림 생성 실패: \(error.localizedDescription)")
            }
        }
    }
}

// 요일을 숫자로 변환
func dayToWeekday(_ day: String) -> Int {
    switch day {
    case "일": return 1
    case "월": return 2
    case "화": return 3
    case "수": return 4
    case "목": return 5
    case "금": return 6
    case "토": return 7
    default: return 0
    }
}
