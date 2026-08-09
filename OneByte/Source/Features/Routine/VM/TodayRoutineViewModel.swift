//
//  TodayRoutineViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/20/24.
//

import SwiftUI
import SwiftData
#if canImport(WidgetKit)
import WidgetKit
#endif

struct RoutineDisplayItem: Identifiable {
    let id: String
    let mainGoal: MainGoal
    let detailGoal: DetailGoal
    let subGoalTitle: String
    let categoryTitle: String
}

private struct WidgetRoutineSnapshotPayload: Codable {
    var dateText: String
    var motivationText: String
    var totalCount: Int
    var completedCount: Int
    var nextRoutine: String
    var selectedCategoryIndex: Int
    var focusedRoutineID: String?
    var categories: [WidgetRoutineCategoryPayload]
}

private struct WidgetRoutineCategoryPayload: Codable {
    var id: String
    var title: String
    var subtitle: String
    var routines: [WidgetRoutineItemPayload]
}

private struct WidgetRoutineItemPayload: Codable {
    var id: String
    var title: String
    var subtitle: String
    var mainGoalTitle: String
    var categoryTitle: String
    var sectionTitle: String
    var timeText: String
    var isCompleted: Bool
    var isInteractive: Bool
    var currentStreak: Int
    var weeklyStates: [Bool]
}

@Observable
class TodayRoutineViewModel {
    private let widgetAppGroupID = "group.com.san.OneByte"
    private let widgetTotalKey = "widget_today_total_count"
    private let widgetCompletedKey = "widget_today_completed_count"
    private let widgetDateKey = "widget_today_date_text"
    private let widgetNextRoutineKey = "widget_today_next_routine"
    private let widgetSnapshotKey = "widget_today_snapshot"
    private let widgetPendingToggleKey = "widget_pending_toggle_routine_ids"
    private let koreaTimeZone = TimeZone(identifier: "Asia/Seoul") ?? .current

    func currentDay() -> String {
        currentDay(for: Date())
    }

    func currentDay(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = koreaTimeZone
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }

    func isTodayRoutine(_ detailGoal: DetailGoal, for day: String) -> Bool {
        isDisplayedToday(detailGoal, on: Date())
    }

    func isRoutine(_ detailGoal: DetailGoal, for date: Date, day: String) -> Bool {
        switch detailGoal.repeatType {
        case .weekday:
            switch day {
            case "월": return detailGoal.alertMon
            case "화": return detailGoal.alertTue
            case "수": return detailGoal.alertWed
            case "목": return detailGoal.alertThu
            case "금": return detailGoal.alertFri
            case "토": return detailGoal.alertSat
            case "일": return detailGoal.alertSun
            default: return false
            }
        case .monthlyDate:
            return isDisplayedToday(detailGoal, on: date)
        case .flexible:
            return false
        }
    }

    func isAllDetailGoalTitlesEmpty(from mainGoals: [MainGoal]) -> Bool {
        mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .allSatisfy { $0.title.isEmpty }
    }

    func filterTodayGoals(from mainGoals: [MainGoal]) -> [DetailGoal] {
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { isDisplayedToday($0, on: Date()) }
    }

    func filterGoals(from mainGoals: [MainGoal], for date: Date) -> [DetailGoal] {
        let day = currentDay(for: date)
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { isRoutine($0, for: date, day: day) }
    }

    func filterCarryoverGoals(from mainGoals: [MainGoal]) -> [DetailGoal] {
        guard let yesterday = carryoverReferenceDate() else {
            return []
        }

        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { !$0.title.isEmpty && shouldDisplayCarryover($0, on: yesterday) }
    }

    func carryoverReferenceDate() -> Date? {
        kstCalendar.date(byAdding: .day, value: -1, to: Date())
    }

    func isCarryoverWindowOpen() -> Bool {
        let now = Date()
        let hour = kstCalendar.component(.hour, from: now)
        return hour < 13 // 13시 이후 어제 루틴 체크 불가
    }

    func canToggleRoutine(on targetDate: Date) -> Bool {
        if isDateTodayInKST(targetDate) {
            return true
        }

        return isDateYesterdayInKST(targetDate) &&
            isCarryoverWindowOpen() &&
            RoutineProgressLogic.isSameTrackingWeek(targetDate, Date(), calendar: kstCalendar)
    }

    func carryoverLockMessage(for targetDate: Date) -> String? {
        guard isDateYesterdayInKST(targetDate) else { return nil }

        if !RoutineProgressLogic.isSameTrackingWeek(targetDate, Date(), calendar: kstCalendar) {
            return "지난주 루틴은 수정할 수 없어요"
        }

        let currentHour = kstCalendar.component(.hour, from: Date())
        return RoutineProgressLogic.carryoverLockMessage(currentHour: currentHour)
    }

    func isDateToday(_ date: Date) -> Bool {
        isDateTodayInKST(date)
    }

    func filterMorning(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        sort(todayGoals).filter { $0.isMorning }
    }

    func filterAfternoon(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        sort(todayGoals).filter { $0.isAfternoon }
    }

    func filterEvening(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        sort(todayGoals).filter { $0.isEvening }
    }

    func filterNight(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        sort(todayGoals).filter { $0.isNight }
    }

    func filterFree(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        sort(todayGoals).filter { $0.isFree }
    }

    func displayItems(for goals: [DetailGoal], in mainGoals: [MainGoal]) -> [RoutineDisplayItem] {
        goals.compactMap { goal in
            for mainGoal in mainGoals {
                for subGoal in mainGoal.subGoals {
                    if let detailGoal = subGoal.detailGoals.first(where: { $0 === goal }) {
                        return RoutineDisplayItem(
                            id: "\(mainGoal.id)-\(subGoal.id)-\(detailGoal.id)",
                            mainGoal: mainGoal,
                            detailGoal: detailGoal,
                            subGoalTitle: subGoal.title,
                            categoryTitle: subGoal.category
                        )
                    }
                }
            }
            return nil
        }
    }

    func isAchieved(_ detailGoal: DetailGoal, on date: Date) -> Bool {
        switch date.mondayBasedIndex() {
        case 0: return detailGoal.achieveMon
        case 1: return detailGoal.achieveTue
        case 2: return detailGoal.achieveWed
        case 3: return detailGoal.achieveThu
        case 4: return detailGoal.achieveFri
        case 5: return detailGoal.achieveSat
        case 6: return detailGoal.achieveSun
        default: return false
        }
    }

    func toggleAchievement(for detailGoal: DetailGoal, in mainGoal: MainGoal, on date: Date = Date(), context: ModelContext) {
        let targetIndex = date.mondayBasedIndex()

        switch targetIndex {
        case 0: detailGoal.achieveMon.toggle()
        case 1: detailGoal.achieveTue.toggle()
        case 2: detailGoal.achieveWed.toggle()
        case 3: detailGoal.achieveThu.toggle()
        case 4: detailGoal.achieveFri.toggle()
        case 5: detailGoal.achieveSat.toggle()
        case 6: detailGoal.achieveSun.toggle()
        default: break
        }

        detailGoal.achieveCount = weeklyAchievedCount(for: detailGoal)
        updateCloverState(for: mainGoal)
    }

    func updateCloverState(for mainGoal: MainGoal) {
        let allDetailGoals = mainGoal.subGoals.flatMap { $0.detailGoals }
        let allAchieveCount = allDetailGoals.map { goal in
            let count = weeklyAchievedCount(for: goal)
            goal.achieveCount = count
            return count
        }
        let allAchieveGoal = allDetailGoals.map { $0.achieveGoal }
        mainGoal.cloverState = RoutineProgressLogic.cloverState(
            achievedCounts: allAchieveCount,
            achievementGoals: allAchieveGoal
        )
    }

    func calculateCurrentWeekAndMonthWeek(mainGoal: MainGoal, clovers: [Clover], context: ModelContext) {
        let today = Date()
        let result = Date.calculateISOWeekAndMonthWeek(for: today)

        if let matchingClover = clovers.first(where: {
            $0.cloverYear == result.year &&
            $0.cloverMonth == result.month &&
            $0.cloverWeekOfMonth == result.weekOfMonth &&
            $0.cloverWeekOfYear == result.weekOfYear
        }) {
            matchingClover.cloverState = mainGoal.cloverState
            do {
                try context.save()
            } catch {
                print("❌ 클로버 업데이트 실패: \(error)")
            }
        }
    }

    func syncWidgetSnapshot(mainGoals: [MainGoal]) {
        let todayGoals = filterTodayGoals(from: mainGoals).filter { !$0.title.isEmpty }
        let completedCount = todayGoals.filter { isAchieved($0, on: Date()) }.count
        let todayItems = displayItems(for: todayGoals, in: mainGoals)
        let widgetItems = displayItems(for: widgetVisibleGoals(from: mainGoals), in: mainGoals)
        let nextRoutine = todayItems
            .filter { !isAchieved($0.detailGoal, on: Date()) }
            .sorted { ($0.detailGoal.remindTime ?? .distantFuture) < ($1.detailGoal.remindTime ?? .distantFuture) }
            .first?.detailGoal.title ?? "오늘의 루틴을 확인해보세요"

        guard let defaults = UserDefaults(suiteName: widgetAppGroupID) else {
            return
        }

        defaults.set(todayGoals.count, forKey: widgetTotalKey)
        defaults.set(completedCount, forKey: widgetCompletedKey)
        defaults.set(todayDateText(), forKey: widgetDateKey)
        defaults.set(nextRoutine, forKey: widgetNextRoutineKey)
        saveWidgetSnapshot(
            widgetItems: widgetItems,
            completedCount: completedCount,
            totalCount: todayGoals.count,
            nextRoutine: nextRoutine,
            defaults: defaults
        )

        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }

    func applyPendingWidgetToggles(mainGoals: [MainGoal], clovers: [Clover], context: ModelContext) {
        guard let defaults = UserDefaults(suiteName: widgetAppGroupID) else {
            return
        }

        let pendingIDs = defaults.stringArray(forKey: widgetPendingToggleKey) ?? []
        guard !pendingIDs.isEmpty else { return }

        let todayGoals = filterTodayGoals(from: mainGoals).filter { !$0.title.isEmpty }
        let todayItems = displayItems(for: todayGoals, in: mainGoals)

        for routineID in pendingIDs {
            guard let item = todayItems.first(where: { $0.id == routineID }) else {
                continue
            }

            toggleAchievement(for: item.detailGoal, in: item.mainGoal, on: Date(), context: context)
            calculateCurrentWeekAndMonthWeek(mainGoal: item.mainGoal, clovers: clovers, context: context)
        }

        defaults.removeObject(forKey: widgetPendingToggleKey)

        do {
            try context.save()
        } catch {
            print("❌ 위젯 체크 반영 저장 실패: \(error)")
        }

        syncWidgetSnapshot(mainGoals: mainGoals)
    }

    func refreshNotificationSchedules(mainGoals: [MainGoal]) {
        let allGoals = mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        let incompleteTodayGoals = filterTodayGoals(from: mainGoals)
            .filter { !$0.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .filter { !isAchieved($0, on: Date()) }

        rescheduleRoutineReminderNotifications(for: allGoals)
        removeIncompleteRoutineNotifications(for: allGoals)
        rescheduleIncompleteRoutineNotifications(for: incompleteTodayGoals)
    }

    private func sort(_ goals: [DetailGoal]) -> [DetailGoal] {
        goals.sorted {
            if $0.isRemind && $1.isRemind {
                return ($0.remindTime ?? .distantPast) < ($1.remindTime ?? .distantPast)
            } else if $0.isRemind {
                return true
            } else if $1.isRemind {
                return false
            } else {
                return false
            }
        }
    }

    private func widgetVisibleGoals(from mainGoals: [MainGoal]) -> [DetailGoal] {
        mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { !$0.title.isEmpty }
    }

    private func saveWidgetSnapshot(
        widgetItems: [RoutineDisplayItem],
        completedCount: Int,
        totalCount: Int,
        nextRoutine: String,
        defaults: UserDefaults
    ) {
        let previousSnapshot = loadExistingSnapshot(from: defaults)
        let categories = makeWidgetCategories(from: widgetItems)
        let safeSelectedIndex = min(previousSnapshot?.selectedCategoryIndex ?? 0, max(categories.count - 1, 0))
        let preservedFocusID = previousSnapshot?.focusedRoutineID
        let validFocusID = categories
            .flatMap(\.routines)
            .contains(where: { $0.id == preservedFocusID ?? "" })
            ? preservedFocusID
            : categories[safe: safeSelectedIndex]?.routines.first?.id

        let snapshot = WidgetRoutineSnapshotPayload(
            dateText: todayDateText(),
            motivationText: widgetMotivationText(completedCount: completedCount, totalCount: totalCount),
            totalCount: totalCount,
            completedCount: completedCount,
            nextRoutine: nextRoutine,
            selectedCategoryIndex: safeSelectedIndex,
            focusedRoutineID: validFocusID,
            categories: categories
        )

        if let data = try? JSONEncoder().encode(snapshot) {
            defaults.set(data, forKey: widgetSnapshotKey)
        }
    }

    private func loadExistingSnapshot(from defaults: UserDefaults) -> WidgetRoutineSnapshotPayload? {
        guard let data = defaults.data(forKey: widgetSnapshotKey) else { return nil }
        return try? JSONDecoder().decode(WidgetRoutineSnapshotPayload.self, from: data)
    }

    private func makeWidgetCategories(from items: [RoutineDisplayItem]) -> [WidgetRoutineCategoryPayload] {
        let orderedCategories = items.reduce(into: [String]()) { result, item in
            if !result.contains(item.categoryTitle) {
                result.append(item.categoryTitle)
            }
        }

        return orderedCategories.compactMap { categoryTitle in
            let categoryItems = items.filter { $0.categoryTitle == categoryTitle }
            guard !categoryItems.isEmpty else { return nil }

            let routines = categoryItems.map { item in
                WidgetRoutineItemPayload(
                    id: item.id,
                    title: item.detailGoal.title,
                    subtitle: item.subGoalTitle,
                    mainGoalTitle: item.subGoalTitle,
                    categoryTitle: item.categoryTitle,
                    sectionTitle: sectionTitle(for: item.detailGoal),
                    timeText: timeText(for: item.detailGoal),
                    isCompleted: isAchieved(item.detailGoal, on: Date()),
                    isInteractive: isWidgetInteractive(item.detailGoal),
                    currentStreak: currentStreak(for: item.detailGoal, on: Date()),
                    weeklyStates: weeklyStates(for: item.detailGoal)
                )
            }

            let completedInCategory = routines.filter { $0.isCompleted }.count
            return WidgetRoutineCategoryPayload(
                id: categoryTitle.lowercased(),
                title: categoryTitle.isEmpty ? "루틴" : categoryTitle,
                subtitle: "\(completedInCategory)/\(routines.count) completed",
                routines: routines
            )
        }
    }

    private func isWidgetInteractive(_ detailGoal: DetailGoal) -> Bool {
        switch detailGoal.repeatType {
        case .weekday:
            return isDisplayedToday(detailGoal, on: Date())
        case .monthlyDate:
            return isDisplayedToday(detailGoal, on: Date())
        case .flexible:
            return false
        }
    }

    private func isDisplayedToday(_ detailGoal: DetailGoal, on date: Date) -> Bool {
        switch detailGoal.repeatType {
        case .weekday:
            let day = currentDay(for: date)
            switch day {
            case "월": return detailGoal.alertMon
            case "화": return detailGoal.alertTue
            case "수": return detailGoal.alertWed
            case "목": return detailGoal.alertThu
            case "금": return detailGoal.alertFri
            case "토": return detailGoal.alertSat
            case "일": return detailGoal.alertSun
            default: return false
            }
        case .monthlyDate:
            let targetCount = detailGoal.scheduledDayOfMonth ?? 1
            return isAchieved(detailGoal, on: date) || weeklyAchievedCount(for: detailGoal) < targetCount
        case .flexible:
            return false
        }
    }

    private func shouldDisplayCarryover(_ detailGoal: DetailGoal, on date: Date) -> Bool {
        switch detailGoal.repeatType {
        case .weekday:
            return isRoutine(detailGoal, for: date, day: currentDay(for: date)) && !isAchieved(detailGoal, on: date)
        case .monthlyDate, .flexible:
            return false
        }
    }

    private func weeklyStates(for detailGoal: DetailGoal) -> [Bool] {
        [
            detailGoal.achieveMon,
            detailGoal.achieveTue,
            detailGoal.achieveWed,
            detailGoal.achieveThu,
            detailGoal.achieveFri,
            detailGoal.achieveSat,
            detailGoal.achieveSun
        ]
    }

    private func weeklyAchievedCount(for detailGoal: DetailGoal) -> Int {
        weeklyStates(for: detailGoal).filter { $0 }.count
    }

    private func currentStreak(for detailGoal: DetailGoal, on date: Date) -> Int {
        let states = weeklyStates(for: detailGoal)
        let todayIndex = date.mondayBasedIndex()
        guard states.indices.contains(todayIndex) else { return 0 }

        var streak = 0
        for index in stride(from: todayIndex, through: 0, by: -1) {
            guard states[index] else { break }
            streak += 1
        }
        return streak
    }

    private func sectionTitle(for detailGoal: DetailGoal) -> String {
        if detailGoal.isMorning { return "Morning" }
        if detailGoal.isAfternoon { return "Afternoon" }
        if detailGoal.isEvening { return "Evening" }
        if detailGoal.isNight { return "Night" }
        return "Anytime"
    }

    private func timeText(for detailGoal: DetailGoal) -> String {
        guard let remindTime = detailGoal.remindTime else {
            return sectionTitle(for: detailGoal)
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = koreaTimeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: remindTime)
    }

    private func todayDateText() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = koreaTimeZone
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: Date())
    }

    private func widgetMotivationText(completedCount: Int, totalCount: Int) -> String {
        guard totalCount > 0 else {
            return "오늘의 리듬을 가볍게 준비해보세요"
        }
        if completedCount == totalCount {
            return "오늘도 충분히 잘하고 있어요"
        }
        if completedCount == 0 {
            return "가장 작은 체크 하나로 시작해요"
        }
        return "지금 흐름이 좋아요, 한 칸만 더"
    }

    private var kstCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = koreaTimeZone
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar
    }

    private func isDateTodayInKST(_ date: Date) -> Bool {
        kstCalendar.isDate(date, inSameDayAs: Date())
    }

    private func isDateYesterdayInKST(_ date: Date) -> Bool {
        guard let yesterday = kstCalendar.date(byAdding: .day, value: -1, to: Date()) else {
            return false
        }
        return kstCalendar.isDate(date, inSameDayAs: yesterday)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
