import Foundation

enum RepeatType {
    case weekday
    case weeklyCount
}

enum SlotState: Equatable {
    case achieved(Int)
    case todayPending
    case futurePending
    case missed
    case idle
}

struct RoutineState {
    var repeatType: RepeatType
    var targetCount: Int
    var alerts: [Bool]
    var achieved: [Bool]
}

struct RoutineLogic {
    static func achievedCount(_ state: RoutineState) -> Int {
        state.achieved.filter { $0 }.count
    }

    static func isDisplayedToday(_ state: RoutineState, dayIndex: Int) -> Bool {
        switch state.repeatType {
        case .weekday:
            return state.alerts[dayIndex]
        case .weeklyCount:
            return state.achieved[dayIndex] || achievedCount(state) < state.targetCount
        }
    }

    static func shouldDisplayCarryover(_ state: RoutineState, yesterdayIndex: Int) -> Bool {
        switch state.repeatType {
        case .weekday:
            return state.alerts[yesterdayIndex] && !state.achieved[yesterdayIndex]
        case .weeklyCount:
            return false
        }
    }

    static func canToggle(targetDayOffset: Int, currentHour: Int) -> Bool {
        if targetDayOffset == 0 { return true }
        if targetDayOffset == -1 { return currentHour < 13 }
        return false
    }

    static func cumulativeCounts(_ state: RoutineState) -> [Int] {
        var running = 0
        return state.achieved.map { value in
            if value { running += 1 }
            return running
        }
    }

    static func slotState(_ state: RoutineState, index: Int, todayIndex: Int) -> SlotState {
        let cumulative = cumulativeCounts(state)
        if state.achieved[index] {
            return .achieved(cumulative[index])
        }

        switch state.repeatType {
        case .weekday:
            guard state.alerts[index] else { return .idle }
            if index == todayIndex { return .todayPending }
            return index > todayIndex ? .futurePending : .missed
        case .weeklyCount:
            if index == todayIndex && achievedCount(state) < state.targetCount {
                return .todayPending
            }
            return .idle
        }
    }
}

func expect(_ condition: @autoclosure () -> Bool, _ message: String) {
    if !condition() {
        fputs("FAIL: \(message)\n", stderr)
        exit(1)
    }
}

let todayIndex = 4 // Thursday/금 equivalent in zero-based Mon...Sun matrix for deterministic checks below.

let weeklyCountPending = RoutineState(
    repeatType: .weeklyCount,
    targetCount: 2,
    alerts: Array(repeating: false, count: 7),
    achieved: [true, false, false, false, false, false, false]
)

expect(RoutineLogic.achievedCount(weeklyCountPending) == 1, "주 n회 달성 횟수는 실제 체크 개수와 같아야 함")
expect(RoutineLogic.isDisplayedToday(weeklyCountPending, dayIndex: todayIndex), "주 n회 루틴은 목표 미달이면 오늘 루틴에 보여야 함")
expect(!RoutineLogic.shouldDisplayCarryover(weeklyCountPending, yesterdayIndex: todayIndex - 1), "주 n회 루틴은 어제 미완료로 중복 노출되면 안 됨")
expect(RoutineLogic.slotState(weeklyCountPending, index: todayIndex, todayIndex: todayIndex) == .todayPending, "주 n회 루틴은 오늘 칸에 대기 상태가 보여야 함")
expect(RoutineLogic.slotState(weeklyCountPending, index: todayIndex + 1, todayIndex: todayIndex) == .idle, "주 n회 루틴은 미래 칸이 회색 배경으로 채워지지 않아야 함")

var weeklyCountCompletedToday = weeklyCountPending
weeklyCountCompletedToday.achieved[todayIndex] = true

expect(RoutineLogic.achievedCount(weeklyCountCompletedToday) == 2, "오늘 체크 후 주 n회 달성 횟수는 2가 되어야 함")
expect(RoutineLogic.isDisplayedToday(weeklyCountCompletedToday, dayIndex: todayIndex), "오늘 완료한 주 n회 루틴은 즉시 사라지면 안 됨")
expect(RoutineLogic.slotState(weeklyCountCompletedToday, index: todayIndex, todayIndex: todayIndex) == .achieved(2), "오늘 완료한 주 n회 루틴은 완료 상태로 남아야 함")

let weekdayCarryover = RoutineState(
    repeatType: .weekday,
    targetCount: 3,
    alerts: [false, false, false, true, false, false, false],
    achieved: [false, false, false, false, false, false, false]
)

expect(RoutineLogic.shouldDisplayCarryover(weekdayCarryover, yesterdayIndex: 3), "요일 반복 루틴의 어제 미완료는 보여야 함")
expect(RoutineLogic.canToggle(targetDayOffset: -1, currentHour: 12), "오후 1시 전 어제 루틴은 수정 가능해야 함")
expect(!RoutineLogic.canToggle(targetDayOffset: -1, currentHour: 13), "오후 1시 이후 어제 루틴은 잠겨야 함")
expect(RoutineLogic.canToggle(targetDayOffset: 0, currentHour: 20), "오늘 루틴은 언제나 수정 가능해야 함")

let weekdayProgress = RoutineState(
    repeatType: .weekday,
    targetCount: 7,
    alerts: [true, true, true, true, true, true, true],
    achieved: [true, true, true, true, false, true, false]
)

expect(RoutineLogic.slotState(weekdayProgress, index: todayIndex, todayIndex: todayIndex) == .todayPending, "오늘의 요일 반복 루틴은 대기 상태가 보여야 함")
expect(RoutineLogic.slotState(weekdayProgress, index: 6, todayIndex: todayIndex) == .futurePending, "미래 요일 반복 루틴은 회색 배경으로 유지되어야 함")
expect(RoutineLogic.slotState(weekdayProgress, index: 0, todayIndex: todayIndex) == .achieved(1), "과거 성공 칸은 누적 클로버 상태여야 함")

expect(
    RoutineProgressLogic.achievementCount(
        storedCount: 2,
        weeklyStates: [true, false, false, false, false, false, false]
    ) == 1,
    "편집 시 저장된 횟수가 오염되어도 실제 체크 개수로 교정되어야 함"
)
expect(
    RoutineProgressLogic.cloverState(achievedCounts: [1], achievementGoals: [2]) == 1,
    "주 n회 루틴을 부분 달성하면 회색 클로버가 유지되어야 함"
)
expect(
    RoutineProgressLogic.cloverState(achievedCounts: [2], achievementGoals: [2]) == 2,
    "모든 루틴을 달성하면 완료 클로버여야 함"
)
expect(
    RoutineProgressLogic.cloverState(achievedCounts: [0], achievementGoals: [2]) == 0,
    "달성이 없으면 클로버는 빈 상태여야 함"
)
expect(
    RoutineProgressLogic.shouldScheduleWeeklyCountReminder(achievedCount: 1, targetCount: 2),
    "주 n회 목표 미달성 시 리마인더를 예약해야 함"
)
expect(
    !RoutineProgressLogic.shouldScheduleWeeklyCountReminder(achievedCount: 2, targetCount: 2),
    "주 n회 목표 달성 후에는 리마인더를 계속 예약하지 않아야 함"
)

var kstCalendar = Calendar(identifier: .iso8601)
kstCalendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
let formatter = ISO8601DateFormatter()
let thursdayNoon = formatter.date(from: "2026-08-06T03:00:00Z")!
let wednesdayNoon = formatter.date(from: "2026-08-05T03:00:00Z")!
let mondayNoon = formatter.date(from: "2026-08-03T03:00:00Z")!
let sundayNoon = formatter.date(from: "2026-08-02T03:00:00Z")!

expect(
    RoutineProgressLogic.isSameTrackingWeek(wednesdayNoon, thursdayNoon, calendar: kstCalendar),
    "같은 주의 어제 루틴은 현재 주 실적에 안전하게 기록할 수 있어야 함"
)
expect(
    !RoutineProgressLogic.isSameTrackingWeek(sundayNoon, mondayNoon, calendar: kstCalendar),
    "월요일에 일요일 실적을 새 주에 잘못 기록하면 안 됨"
)
expect(
    RoutineProgressLogic.carryoverLockMessage(currentHour: 12) == nil,
    "오후 1시 전에는 어제 루틴 잠금 안내가 보이면 안 됨"
)
expect(
    RoutineProgressLogic.carryoverLockMessage(currentHour: 13) == "오후 1시 이후에는 수정할 수 없어요",
    "오후 1시부터 어제 루틴 잠금 안내가 보여야 함"
)

print("PASS: routine regression self-test")
