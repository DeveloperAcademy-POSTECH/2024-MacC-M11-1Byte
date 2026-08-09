import Foundation

enum RoutineProgressLogic {
    static func achievementCount(storedCount: Int, weeklyStates: [Bool]) -> Int {
        weeklyStates.filter { $0 }.count
    }

    static func cloverState(achievedCounts: [Int], achievementGoals: [Int]) -> Int {
        let progress = zip(achievedCounts, achievementGoals)
            .filter { $0.1 > 0 }

        guard !progress.isEmpty else { return 0 }
        guard progress.contains(where: { $0.0 > 0 }) else { return 0 }

        return progress.allSatisfy { achieved, goal in
            achieved >= goal
        } ? 2 : 1
    }

    static func shouldScheduleWeeklyCountReminder(achievedCount: Int, targetCount: Int) -> Bool {
        targetCount > 0 && achievedCount < targetCount
    }

    static func isSameTrackingWeek(_ lhs: Date, _ rhs: Date, calendar: Calendar) -> Bool {
        let left = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: lhs)
        let right = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: rhs)
        return left.yearForWeekOfYear == right.yearForWeekOfYear && left.weekOfYear == right.weekOfYear
    }

    static func carryoverLockMessage(currentHour: Int) -> String? {
        currentHour >= 13 ? "오후 1시 이후에는 수정할 수 없어요" : nil
    }
}
