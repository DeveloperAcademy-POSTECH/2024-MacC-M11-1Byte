//
//  Notification.swift
//  OneByte
//
//  Created by 트루디 on 11/20/24.
//

import UserNotifications

func checkNotificationPermissionAndRequestIfNeeded() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        if settings.authorizationStatus == .notDetermined {
            requestNotificationPermission()
        } else {
            print("이미 알림 권한이 설정되었습니다: \(settings.authorizationStatus.rawValue)")
        }
    }
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error.localizedDescription)")
        } else {
            print(granted ? "Permission granted" : "Permission denied")
        }
    }
}

func scheduleNotification(detailGoal: DetailGoal, for title: String, on day: String, at time: Date) {
    let center = UNUserNotificationCenter.current()
    
    // 알림 식별자 설정
    let identifier = "\(detailGoal.id)_\(day)"
//    // 여러 개의 제목을 배열로 설정하고, 랜덤으로 선택
//       let titles = [
//           "🐢 루틴을 시작해보세요",
//           "조금만 힘내면 금새 습관이 될 거예요",
//           "🍀 오늘의 네잎클로버를 칠해봐요",
//           "루틴 알림",
//           "오늘의 작은 실천을 해보아요"
//       ]
    // 알림 내용
    let content = UNMutableNotificationContent()
    content.title = "🍀 오늘의 네잎클로버를 칠해봐요"
    content.body = title
    content.sound = .default
    
    // 알림 트리거 생성 (예: 매주 특정 요일 및 시간)
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.hour, .minute], from: time)
    
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
