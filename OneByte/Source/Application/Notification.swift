//
//  Notification.swift
//  OneByte
//
//  Created by 트루디 on 11/20/24.
//

import UserNotifications
import UIKit

enum NotificationAuthorizationState {
    case notDetermined
    case denied
    case authorized
}

private enum NotificationPreferenceKeys {
    static let routineReminderEnabled = "routineReminderEnabled"
    static let incompleteRoutineReminderEnabled = "incompleteRoutineReminderEnabled"
    static let incompleteRoutineReminderHour = "incompleteRoutineReminderHour"
    static let incompleteRoutineReminderMinute = "incompleteRoutineReminderMinute"
}

private let incompleteRoutineMessageTemplates: [String] = [
    "🍀 오늘의 %@이 아직 남아 있어요.",
    "💚 %@, 오늘도 이어가 볼까요?",
    "✨ 잠깐만요! 오늘의 %@을 잊지 않았나요?",
    "🌱 작은 실천 하나, %@부터 시작해 보세요.",
    "✔️ 아직 오늘의 %@을 완료하지 않았어요."
]

func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
            print("Notification permission error: \(error.localizedDescription)")
            completion(false)
        } else {
            print(granted ? "Permission granted" : "Permission denied")
            completion(granted)
        }
    }
}

func requestNotificationPermissionIfNeeded() {
    fetchNotificationAuthorizationState { state in
        guard state == .notDetermined else { return }
        requestNotificationPermission { _ in }
    }
}

func fetchNotificationAuthorizationState(completion: @escaping (NotificationAuthorizationState) -> Void) {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            completion(.authorized)
        case .denied:
            completion(.denied)
        case .notDetermined:
            completion(.notDetermined)
        @unknown default:
            completion(.notDetermined)
        }
    }
}

func openSystemNotificationSettings() {
    guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString),
          UIApplication.shared.canOpenURL(appSettingsURL) else {
        return
    }
    UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
}

func isRoutineReminderEnabled() -> Bool {
    let defaults = UserDefaults.standard
    guard defaults.object(forKey: NotificationPreferenceKeys.routineReminderEnabled) != nil else {
        return true
    }
    return defaults.bool(forKey: NotificationPreferenceKeys.routineReminderEnabled)
}

func setRoutineReminderEnabled(_ isEnabled: Bool) {
    UserDefaults.standard.set(isEnabled, forKey: NotificationPreferenceKeys.routineReminderEnabled)
}

func isIncompleteRoutineReminderEnabled() -> Bool {
    let defaults = UserDefaults.standard
    guard defaults.object(forKey: NotificationPreferenceKeys.incompleteRoutineReminderEnabled) != nil else {
        return true
    }
    return defaults.bool(forKey: NotificationPreferenceKeys.incompleteRoutineReminderEnabled)
}

func setIncompleteRoutineReminderEnabled(_ isEnabled: Bool) {
    UserDefaults.standard.set(isEnabled, forKey: NotificationPreferenceKeys.incompleteRoutineReminderEnabled)
}

func loadIncompleteRoutineReminderTime() -> Date {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current

    let defaults = UserDefaults.standard
    let hasStoredHour = defaults.object(forKey: NotificationPreferenceKeys.incompleteRoutineReminderHour) != nil
    let hasStoredMinute = defaults.object(forKey: NotificationPreferenceKeys.incompleteRoutineReminderMinute) != nil
    let hour = hasStoredHour ? defaults.integer(forKey: NotificationPreferenceKeys.incompleteRoutineReminderHour) : 23
    let minute = hasStoredMinute ? defaults.integer(forKey: NotificationPreferenceKeys.incompleteRoutineReminderMinute) : 0

    return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date()) ?? Date()
}

func setIncompleteRoutineReminderTime(_ date: Date) {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    let components = calendar.dateComponents([.hour, .minute], from: date)
    UserDefaults.standard.set(components.hour ?? 23, forKey: NotificationPreferenceKeys.incompleteRoutineReminderHour)
    UserDefaults.standard.set(components.minute ?? 0, forKey: NotificationPreferenceKeys.incompleteRoutineReminderMinute)
}

func scheduleWeeklyNotification(detailGoal: DetailGoal, title: String, day: String, time: Date) {
    guard isRoutineReminderEnabled() else { return }

    let center = UNUserNotificationCenter.current()
    let identifier = "\(detailGoal.id)_\(day)"
    let content = UNMutableNotificationContent()
    content.title = "🍀 오늘의 네잎클로버를 칠해봐요"
    content.body = title
    content.sound = .default

    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.hour, .minute], from: time)
    var triggerComponents = dateComponents
    triggerComponents.weekday = dayToWeekday(day)
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    center.add(request) { error in
        if let error = error {
            print("알림 생성 실패: \(error.localizedDescription)")
        }
    }
}

func scheduleWeeklyCountNotification(detailGoal: DetailGoal, title: String, time: Date) {
    guard isRoutineReminderEnabled() else { return }

    let center = UNUserNotificationCenter.current()
    let identifier = "\(detailGoal.id)_count"

    let content = UNMutableNotificationContent()
    content.title = "🍀 이번 주 루틴을 기억해요"
    content.body = title
    content.sound = .default

    let calendar = Calendar.current
    let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
    var triggerComponents = DateComponents()
    triggerComponents.hour = timeComponents.hour
    triggerComponents.minute = timeComponents.minute
    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)

    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    center.add(request) { error in
        if let error = error {
            print("주간 횟수 알림 생성 실패: \(error.localizedDescription)")
        }
    }
}

func rescheduleRoutineReminderNotifications(for detailGoals: [DetailGoal]) {
    let allGoals = detailGoals.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    removeRoutineReminderNotifications(for: allGoals)
    guard isRoutineReminderEnabled() else { return }

    for detailGoal in allGoals where detailGoal.isRemind {
        guard let remindTime = detailGoal.remindTime else { continue }

        switch detailGoal.repeatType {
        case .weekday:
            routineSelectedDays(for: detailGoal).forEach { day in
                scheduleWeeklyNotification(detailGoal: detailGoal, title: detailGoal.title, day: day, time: remindTime)
            }
        case .monthlyDate:
            let achievedCount = [
                detailGoal.achieveMon,
                detailGoal.achieveTue,
                detailGoal.achieveWed,
                detailGoal.achieveThu,
                detailGoal.achieveFri,
                detailGoal.achieveSat,
                detailGoal.achieveSun
            ].filter { $0 }.count
            let targetCount = detailGoal.scheduledDayOfMonth ?? max(detailGoal.achieveGoal, 1)
            if RoutineProgressLogic.shouldScheduleWeeklyCountReminder(
                achievedCount: achievedCount,
                targetCount: targetCount
            ) {
                scheduleWeeklyCountNotification(detailGoal: detailGoal, title: detailGoal.title, time: remindTime)
            }
        case .flexible:
            continue
        }
    }
}

func removeRoutineReminderNotifications(for detailGoals: [DetailGoal]) {
    let identifiers = detailGoals.flatMap { routineReminderIdentifiers(for: $0) }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
}

func rescheduleIncompleteRoutineNotifications(for detailGoals: [DetailGoal]) {
    let allGoals = detailGoals.filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    removeIncompleteRoutineNotifications(for: allGoals)
    guard isIncompleteRoutineReminderEnabled(),
          let triggerDate = nextIncompleteRoutineTriggerDateInKST() else { return }

    for detailGoal in allGoals {
        scheduleIncompleteRoutineNotification(detailGoal: detailGoal, triggerDate: triggerDate)
    }
}

func removeIncompleteRoutineNotifications(for detailGoals: [DetailGoal]) {
    let identifiers = detailGoals.map { incompleteRoutineNotificationIdentifier(for: $0) }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
}

func incompleteRoutineNotificationIdentifier(for detailGoal: DetailGoal) -> String {
    "\(detailGoal.id)_incomplete"
}

func routineReminderIdentifiers(for detailGoal: DetailGoal) -> [String] {
    ["월", "화", "수", "목", "금", "토", "일"].map { "\(detailGoal.id)_\($0)" } + ["\(detailGoal.id)_count", "\(detailGoal.id)_monthly"]
}

private func routineSelectedDays(for detailGoal: DetailGoal) -> [String] {
    var days: [String] = []
    if detailGoal.alertMon { days.append("월") }
    if detailGoal.alertTue { days.append("화") }
    if detailGoal.alertWed { days.append("수") }
    if detailGoal.alertThu { days.append("목") }
    if detailGoal.alertFri { days.append("금") }
    if detailGoal.alertSat { days.append("토") }
    if detailGoal.alertSun { days.append("일") }
    return days
}

private func scheduleIncompleteRoutineNotification(detailGoal: DetailGoal, triggerDate: Date) {
    let center = UNUserNotificationCenter.current()
    let identifier = incompleteRoutineNotificationIdentifier(for: detailGoal)

    let content = UNMutableNotificationContent()
    content.title = "하고만다"
    content.body = incompleteRoutineRandomizedBody(for: detailGoal.title)
    content.sound = .default

    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    center.add(request) { error in
        if let error = error {
            print("미완료 루틴 알림 생성 실패: \(error.localizedDescription)")
        }
    }
}

private func incompleteRoutineRandomizedBody(for title: String) -> String {
    let template = incompleteRoutineMessageTemplates.randomElement() ?? incompleteRoutineMessageTemplates[0]
    return String(format: template, title)
}

private func nextIncompleteRoutineTriggerDateInKST() -> Date? {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
    let now = Date()
    let preferredTime = loadIncompleteRoutineReminderTime()
    let components = calendar.dateComponents([.hour, .minute], from: preferredTime)
    guard let hour = components.hour, let minute = components.minute else { return nil }

    guard let triggerDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now),
          triggerDate > now else {
        return nil
    }

    return triggerDate
}

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
