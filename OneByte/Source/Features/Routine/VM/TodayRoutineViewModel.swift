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
    
    // 오늘의 루틴에서 오늘루틴을 보여주기 위해, 현재 요일 확인 함수
    func currentDay() -> String {
        currentDay(for: Date())
    }

    func currentDay(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E" // "월", "화", "수", ...
        return formatter.string(from: date)
    }
    
    // DetailGoal이 오늘의 루틴인지 확인하는 함수
    func isTodayRoutine(_ detailGoal: DetailGoal, for day: String) -> Bool {
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
    }
    // MARK: 사용자가 모든 DetailGoal을 삭제해서, 모든 루틴의 title의 ""일때 필터링
    func isAllDetailGoalTitlesEmpty(from mainGoals: [MainGoal]) -> Bool {
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .allSatisfy { $0.title.isEmpty }
    }
    
    // MARK: 오늘의 루틴인것만 필터링
    func filterTodayGoals(from mainGoals: [MainGoal]) -> [DetailGoal] {
        let today = currentDay()
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { isTodayRoutine($0, for: today) }
    }

    func filterGoals(from mainGoals: [MainGoal], for date: Date) -> [DetailGoal] {
        let day = currentDay(for: date)
        return mainGoals
            .flatMap { $0.subGoals }
            .flatMap { $0.detailGoals }
            .filter { isTodayRoutine($0, for: day) }
    }

    func filterCarryoverGoals(from mainGoals: [MainGoal]) -> [DetailGoal] {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            return []
        }

        return filterGoals(from: mainGoals, for: yesterday)
            .filter { !$0.title.isEmpty }
    }
    
    // MARK: 아침/점심/저녁/자기전/자율 루틴 필터링 및 시간순 정렬
    func filterMorning(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isMorning }
    }
    
    func filterAfternoon(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isAfternoon }
    }
    
    func filterEvening(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isEvening }
    }
    
    func filterNight(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isNight }
    }
    
    func filterFree(from todayGoals: [DetailGoal]) -> [DetailGoal] {
        return todayGoals
            .sorted {
                if $0.isRemind && $1.isRemind {
                    return ($0.remindTime ?? Date.distantPast) < ($1.remindTime ?? Date.distantPast)
                } else if $0.isRemind {
                    return true
                } else if $1.isRemind {
                    return false
                } else {
                    return false
                }
            }
            .filter { $0.isFree }
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
    
    // MARK: 오늘의 루틴 목록 중에서 완료/미완료 여부에 따라 achieveMon 데이터 변경
    func toggleAchievement(for detailGoal: DetailGoal, in mainGoal: MainGoal, on date: Date = Date(), context: ModelContext) {
        let targetIndex = date.mondayBasedIndex()  // 월요일 기준 인덱스
        let isAchievedBeforeToggle = isAchieved(detailGoal, on: date)
        
        // 오늘의 요일에 해당하는 achieve 값을 토글
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
        
        // 토글 후 새로운 상태를 가져옴
        let isAchievedAfterToggle = isAchieved(detailGoal, on: date)
        
        // 이전 상태와 새로운 상태를 비교하여 achieveCount 업데이트
        if isAchievedAfterToggle && !isAchievedBeforeToggle {
            detailGoal.achieveCount += 1 // 완료로 변경된 경우
        } else if !isAchievedAfterToggle && isAchievedBeforeToggle {
            detailGoal.achieveCount -= 1// 미완료로 변경된 경우
        }
        updateCloverState(for: mainGoal) // MainGoal의 cloverState 업데이트 함수 호출
    }
    
    // MARK: MainGoal의 cloverState 업데이트
    func updateCloverState(for mainGoal: MainGoal) {
        let allDetailGoals = mainGoal.subGoals.flatMap { $0.detailGoals } // 모든 SubGoal의 DetailGoal 가져오기
        let allAchieveCount = allDetailGoals.map { $0.achieveCount } // 모든 DetailGoal의 AchieveCount
        let allAchieveGoal = allDetailGoals.map { $0.achieveGoal } // 모든 DetailGoal의 AchieveGoal
        
        // 1) 모든 achieveCount가 0이면 cloverState = 0
        if allAchieveCount.allSatisfy({ $0 == 0 }) {
            mainGoal.cloverState = 0
            print("🔥🔥🔥루틴 미성취: \(mainGoal.cloverState)")
            return
        }
        
        // achieveGoal이 1이상인것중에, achieveCount == achieveGoal이 1개라도 있다면
        if allDetailGoals.contains(where: { $0.achieveGoal > 0 && $0.achieveCount == $0.achieveGoal }) {
            if zip(allAchieveCount, allAchieveGoal).allSatisfy({ $0 == $1 }) { // 모든 루틴이 같다면, 황금 클로버
                mainGoal.cloverState = 2
                print("🔥🔥 3번 조건(루틴 all 성공): \(mainGoal.cloverState)")
            } else { // 1개성취면 초록클로버
                mainGoal.cloverState = 1
                print("🔥🔥 2번 조건(루틴 1개 성공): \(mainGoal.cloverState)")
            }
            return
        }
    }
    
    // MainGoal CloverState 변경시킬때,Clover객체에서 현재 날짜에 맞는 주차찾아 CloverState 업데이트 시키기 위해 날짜 찾음
    func calculateCurrentWeekAndMonthWeek(mainGoal: MainGoal, clovers: [Clover], context: ModelContext) {
        let today = Date()
        let calendar = Calendar(identifier: .iso8601)
        
        // 주차 및 월차 계산
        let result = Date.calculateISOWeekAndMonthWeek(for: today)
        let currentYear: Int = result.year
        let currentWeekOfYear: Int = result.weekOfYear
        let currentWeekOfMonth: Int = result.weekOfMonth
        let currentMonth: Int = result.month // 수정된 로직 적용
        print("현재 날짜 정보 : \(currentYear),\(currentWeekOfYear),\(currentWeekOfMonth),\(currentMonth)")
        // 주 시작일과 종료일 계산
        if let range = Date.weekDateRange(for: today) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            
            print("주 시작일: \(formatter.string(from: range.start))")
            print("주 종료일: \(formatter.string(from: range.end))")
        }
        
        // 현재 주차와 월차에 해당하는 Clover 객체를 찾음
        if let matchingClover = clovers.first(where: {
            $0.cloverYear == currentYear &&
            $0.cloverMonth == currentMonth &&
            $0.cloverWeekOfMonth == currentWeekOfMonth &&
            $0.cloverWeekOfYear == currentWeekOfYear
        }) {
            print("🍀 Found matching Clover ID: \(matchingClover.id)")
            
            // CloverState 업데이트
            matchingClover.cloverState = mainGoal.cloverState
            // 저장
            do {
                try context.save()
                print("✅ 클로버 상태 업데이트 성공(Clover ID): \(matchingClover.id)")
            } catch {
                print("❌ 클로버 업데이트 실패: \(error)")
            }
        } else {
            print("⚠️ 날짜 매칭 실패 for 연도: \(currentYear), 월: \(currentMonth), 월차: \(currentWeekOfMonth), 주차: \(currentWeekOfYear)")
        }
    }

    // MARK: Widget Sync
    func syncWidgetSnapshot(mainGoals: [MainGoal]) {
        let todayGoals = filterTodayGoals(from: mainGoals).filter { !$0.title.isEmpty }
        let completedCount = todayGoals.filter { isAchievedToday($0) }.count
        let todayItems = displayItems(for: todayGoals, in: mainGoals)
        let nextRoutine = todayItems
            .filter { !isAchievedToday($0.detailGoal) }
            .sorted { lhs, rhs in
                let left = lhs.detailGoal.remindTime ?? Date.distantFuture
                let right = rhs.detailGoal.remindTime ?? Date.distantFuture
                return left < right
            }
            .first?.detailGoal.title ?? "오늘의 루틴을 확인해보세요"

        guard let defaults = UserDefaults(suiteName: widgetAppGroupID) else {
            print("❌ App Group UserDefaults 접근 실패: \(widgetAppGroupID)")
            return
        }
        defaults.set(todayGoals.count, forKey: widgetTotalKey)
        defaults.set(completedCount, forKey: widgetCompletedKey)
        defaults.set(todayDateText(), forKey: widgetDateKey)
        defaults.set(nextRoutine, forKey: widgetNextRoutineKey)
        saveWidgetSnapshot(todayItems: todayItems, completedCount: completedCount, totalCount: todayGoals.count, nextRoutine: nextRoutine, defaults: defaults)

        #if canImport(WidgetKit)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
    }

    private func saveWidgetSnapshot(
        todayItems: [RoutineDisplayItem],
        completedCount: Int,
        totalCount: Int,
        nextRoutine: String,
        defaults: UserDefaults
    ) {
        let previousSnapshot = loadExistingSnapshot(from: defaults)
        let categories = makeWidgetCategories(from: todayItems)
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
        let orderedCategories = items.reduce(into: [String]()) { partialResult, item in
            if !partialResult.contains(item.categoryTitle) {
                partialResult.append(item.categoryTitle)
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
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: remindTime)
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

    func applyPendingWidgetToggles(mainGoals: [MainGoal], clovers: [Clover], context: ModelContext) {
        guard let defaults = UserDefaults(suiteName: widgetAppGroupID) else {
            print("❌ App Group UserDefaults 접근 실패: \(widgetAppGroupID)")
            return
        }

        let pendingIDs = defaults.stringArray(forKey: widgetPendingToggleKey) ?? []
        guard !pendingIDs.isEmpty else { return }
        guard !mainGoals.isEmpty else { return }

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
            print("❌ 위젯 루틴 체크 반영 저장 실패: \(error)")
        }

        syncWidgetSnapshot(mainGoals: mainGoals)
    }

    private func isAchievedToday(_ detailGoal: DetailGoal) -> Bool {
        isAchieved(detailGoal, on: Date())
    }

    func isAchieved(_ detailGoal: DetailGoal, on date: Date) -> Bool {
        let targetIndex = date.mondayBasedIndex()
        switch targetIndex {
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

    private func todayDateText() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: Date())
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
