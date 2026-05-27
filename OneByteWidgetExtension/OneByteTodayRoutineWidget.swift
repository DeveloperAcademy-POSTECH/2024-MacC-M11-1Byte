import AppIntents
import SwiftUI
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Routine Widget" }
    static var description: IntentDescription { "오늘 루틴을 홈 화면에서 바로 체크해요." }
}

struct ToggleRoutineIntent: AppIntent {
    static var title: LocalizedStringResource { "Toggle Routine" }
    static var description = IntentDescription("위젯에서 루틴 완료 상태를 토글합니다.")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Routine ID")
    var routineID: String

    init() {}

    init(routineID: String) {
        self.routineID = routineID
    }

    func perform() async throws -> some IntentResult {
        RoutineWidgetStore.toggleRoutine(id: routineID)
        WidgetCenter.shared.reloadTimelines(ofKind: OneByteTodayRoutineWidget.kind)
        return .result()
    }
}

struct ShiftCategoryIntent: AppIntent {
    static var title: LocalizedStringResource { "Shift Category" }
    static var description = IntentDescription("위젯의 루틴 카테고리를 전환합니다.")
    static var openAppWhenRun: Bool = false

    @Parameter(title: "Direction")
    var direction: Int

    init() {}

    init(direction: Int) {
        self.direction = direction
    }

    func perform() async throws -> some IntentResult {
        RoutineWidgetStore.shiftCategory(by: direction)
        WidgetCenter.shared.reloadTimelines(ofKind: OneByteTodayRoutineWidget.kind)
        return .result()
    }
}

struct OneByteRoutineEntry: TimelineEntry {
    let date: Date
    let snapshot: RoutineWidgetSnapshot
}

struct OneByteRoutineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> OneByteRoutineEntry {
        OneByteRoutineEntry(date: .now, snapshot: .placeholder)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> OneByteRoutineEntry {
        OneByteRoutineEntry(date: .now, snapshot: RoutineWidgetStore.loadSnapshot())
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<OneByteRoutineEntry> {
        let entry = OneByteRoutineEntry(date: .now, snapshot: RoutineWidgetStore.loadSnapshot())
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now.addingTimeInterval(900)
        return Timeline(entries: [entry], policy: .after(nextRefresh))
    }
}

struct OneByteTodayRoutineWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    @Environment(\.colorScheme) private var colorScheme

    var entry: OneByteRoutineEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallRoutineWidgetView(snapshot: entry.snapshot, colorScheme: colorScheme)
        case .systemMedium:
            MediumRoutineWidgetView(snapshot: entry.snapshot, colorScheme: colorScheme)
        default:
            SmallRoutineWidgetView(snapshot: entry.snapshot, colorScheme: colorScheme)
        }
    }
}

struct OneByteTodayRoutineWidget: Widget {
    static let kind = "OneByteTodayRoutineWidget"

    let kind: String = OneByteTodayRoutineWidget.kind

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: OneByteRoutineProvider()) { entry in
            OneByteTodayRoutineWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("오늘 루틴")
        .description("간단한 리스트와 체크로 오늘 루틴을 관리해요.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

struct RoutineWidgetSnapshot: Codable {
    var dateText: String
    var motivationText: String
    var totalCount: Int
    var completedCount: Int
    var nextRoutine: String
    var selectedCategoryIndex: Int
    var focusedRoutineID: String?
    var categories: [RoutineWidgetCategory]

    var completionValue: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    var completionText: String {
        "\(completedCount)/\(totalCount)"
    }

    var percentText: String {
        "\(Int((completionValue * 100).rounded()))%"
    }

    var shortDateText: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M.d"
        return formatter.string(from: Date())
    }

    var currentCategory: RoutineWidgetCategory? {
        categories[safe: safeCategoryIndex]
    }

    var safeCategoryIndex: Int {
        guard !categories.isEmpty else { return 0 }
        return min(max(selectedCategoryIndex, 0), categories.count - 1)
    }

    static var placeholder: RoutineWidgetSnapshot {
        RoutineWidgetSnapshot(
            dateText: "5월 27일 수요일",
            motivationText: "가볍게 두세 개만 체크해도 충분해요",
            totalCount: 4,
            completedCount: 2,
            nextRoutine: "비타민 챙기기",
            selectedCategoryIndex: 0,
            focusedRoutineID: nil,
            categories: [
                RoutineWidgetCategory(
                    id: "health",
                    title: "건강",
                    subtitle: "2/4 completed",
                    routines: [
                        RoutineWidgetItem(id: "health-1", title: "물 1잔 마시기", subtitle: "Morning Reset", categoryTitle: "건강", sectionTitle: "Morning", timeText: "07:30", isCompleted: true, currentStreak: 3, weeklyStates: [true, true, false, true, false, false, false]),
                        RoutineWidgetItem(id: "health-2", title: "가벼운 스트레칭", subtitle: "Wake Flow", categoryTitle: "건강", sectionTitle: "Morning", timeText: "08:10", isCompleted: false, currentStreak: 1, weeklyStates: [true, false, false, false, false, false, false]),
                        RoutineWidgetItem(id: "health-3", title: "영양제 챙기기", subtitle: "Daily Care", categoryTitle: "건강", sectionTitle: "Anytime", timeText: "Anytime", isCompleted: true, currentStreak: 2, weeklyStates: [true, true, false, false, false, false, false]),
                        RoutineWidgetItem(id: "health-4", title: "산책 10분", subtitle: "Light Walk", categoryTitle: "건강", sectionTitle: "Evening", timeText: "19:00", isCompleted: false, currentStreak: 0, weeklyStates: [false, false, false, false, false, false, false])
                    ]
                ),
                RoutineWidgetCategory(
                    id: "study",
                    title: "공부",
                    subtitle: "1/3 completed",
                    routines: [
                        RoutineWidgetItem(id: "study-1", title: "영단어 20개", subtitle: "Deep Focus", categoryTitle: "공부", sectionTitle: "Afternoon", timeText: "14:00", isCompleted: false, currentStreak: 0, weeklyStates: [false, false, false, false, false, false, false]),
                        RoutineWidgetItem(id: "study-2", title: "논문 읽기", subtitle: "Research", categoryTitle: "공부", sectionTitle: "Evening", timeText: "19:00", isCompleted: true, currentStreak: 1, weeklyStates: [false, true, false, false, false, false, false]),
                        RoutineWidgetItem(id: "study-3", title: "회고 한 줄", subtitle: "Night Wrap", categoryTitle: "공부", sectionTitle: "Night", timeText: "22:30", isCompleted: false, currentStreak: 0, weeklyStates: [false, false, false, false, false, false, false])
                    ]
                )
            ]
        )
    }
}

struct RoutineWidgetCategory: Codable {
    var id: String
    var title: String
    var subtitle: String
    var routines: [RoutineWidgetItem]

    var completedCount: Int {
        routines.filter { $0.isCompleted }.count
    }
}

struct RoutineWidgetItem: Codable {
    var id: String
    var title: String
    var subtitle: String
    var mainGoalTitle: String? = nil
    var categoryTitle: String
    var sectionTitle: String
    var timeText: String
    var isCompleted: Bool
    var currentStreak: Int
    var weeklyStates: [Bool]
}

enum RoutineWidgetStore {
    private static let appGroupID = "group.com.san.OneByte"
    private static let snapshotKey = "widget_today_snapshot"
    private static let pendingToggleKey = "widget_pending_toggle_routine_ids"

    static func loadSnapshot() -> RoutineWidgetSnapshot {
        guard let defaults = UserDefaults(suiteName: appGroupID),
              let data = defaults.data(forKey: snapshotKey),
              var snapshot = try? JSONDecoder().decode(RoutineWidgetSnapshot.self, from: data)
        else {
            return .placeholder
        }

        if snapshot.categories.isEmpty {
            return .placeholder
        }

        snapshot.selectedCategoryIndex = snapshot.safeCategoryIndex
        return snapshot
    }

    static func saveSnapshot(_ snapshot: RoutineWidgetSnapshot) {
        guard let defaults = UserDefaults(suiteName: appGroupID),
              let data = try? JSONEncoder().encode(snapshot) else {
            return
        }
        defaults.set(data, forKey: snapshotKey)
        defaults.set(snapshot.totalCount, forKey: "widget_today_total_count")
        defaults.set(snapshot.completedCount, forKey: "widget_today_completed_count")
        defaults.set(snapshot.dateText, forKey: "widget_today_date_text")
        defaults.set(snapshot.nextRoutine, forKey: "widget_today_next_routine")
    }

    static func toggleRoutine(id: String) {
        appendPendingToggle(id: id)

        updateSnapshot { snapshot in
            let todayIndex = Date().mondayBasedIndex()
            for categoryIndex in snapshot.categories.indices {
                guard let routineIndex = snapshot.categories[categoryIndex].routines.firstIndex(where: { $0.id == id }) else {
                    continue
                }

                snapshot.categories[categoryIndex].routines[routineIndex].isCompleted.toggle()
                let isCompleted = snapshot.categories[categoryIndex].routines[routineIndex].isCompleted
                if snapshot.categories[categoryIndex].routines[routineIndex].weeklyStates.indices.contains(todayIndex) {
                    snapshot.categories[categoryIndex].routines[routineIndex].weeklyStates[todayIndex] = isCompleted
                }
            }

            normalize(snapshot: &snapshot)
        }
    }

    private static func appendPendingToggle(id: String) {
        guard let defaults = UserDefaults(suiteName: appGroupID) else {
            return
        }

        var pendingIDs = defaults.stringArray(forKey: pendingToggleKey) ?? []
        pendingIDs.append(id)
        defaults.set(pendingIDs, forKey: pendingToggleKey)
    }

    static func shiftCategory(by direction: Int) {
        updateSnapshot { snapshot in
            guard !snapshot.categories.isEmpty else { return }
            let count = snapshot.categories.count
            snapshot.selectedCategoryIndex = wrappedIndex(snapshot.safeCategoryIndex + direction, count: count)
            normalize(snapshot: &snapshot)
        }
    }

    private static func updateSnapshot(_ mutate: (inout RoutineWidgetSnapshot) -> Void) {
        var snapshot = loadSnapshot()
        mutate(&snapshot)
        saveSnapshot(snapshot)
    }

    private static func normalize(snapshot: inout RoutineWidgetSnapshot) {
        snapshot.completedCount = snapshot.categories.flatMap(\.routines).filter { $0.isCompleted }.count
        snapshot.totalCount = snapshot.categories.flatMap(\.routines).count
        snapshot.selectedCategoryIndex = snapshot.safeCategoryIndex

        for index in snapshot.categories.indices {
            let category = snapshot.categories[index]
            snapshot.categories[index].subtitle = "\(category.completedCount)/\(category.routines.count) completed"
        }

        snapshot.nextRoutine = snapshot.categories
            .flatMap(\.routines)
            .first(where: { !$0.isCompleted })?
            .title ?? "오늘 루틴을 충분히 해냈어요"
        snapshot.motivationText = motivationText(completed: snapshot.completedCount, total: snapshot.totalCount)
    }

    private static func wrappedIndex(_ index: Int, count: Int) -> Int {
        guard count > 0 else { return 0 }
        return (index % count + count) % count
    }

    private static func motivationText(completed: Int, total: Int) -> String {
        guard total > 0 else {
            return "오늘의 리듬을 가볍게 준비해보세요"
        }
        if completed == total {
            return "오늘도 충분히 잘하고 있어요"
        }
        if completed == 0 {
            return "가장 작은 체크 하나로 시작해요"
        }
        return "지금 흐름이 좋아요, 한 칸만 더"
    }
}

private enum RoutineWidgetPalette {
    static let accent = Color(red: 0.56, green: 0.80, blue: 0.60)
    static let accentStrong = Color(red: 0.39, green: 0.67, blue: 0.43)
    static let ink = Color(red: 0.10, green: 0.10, blue: 0.11)
    static let appBackground = Color(red: 1.0, green: 250.0 / 255.0, blue: 244.0 / 255.0)
    static let paper = Color.white
    static let paperDark = Color(red: 0.10, green: 0.11, blue: 0.12)
    static let borderLight = Color.black.opacity(0.06)
    static let borderDark = Color.white.opacity(0.08)
    static let textSecondaryLight = Color.black.opacity(0.72)
    static let textSecondaryDark = Color.white.opacity(0.58)

    static func background(for darkMode: Bool) -> some View {
        LinearGradient(
            colors: darkMode
                ? [paperDark, Color.black]
                : [appBackground, appBackground],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static func cardFill(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? paperDark : paper
    }

    static func border(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? borderDark : borderLight
    }

    static func primaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? .white : ink
    }

    static func secondaryText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? textSecondaryDark : textSecondaryLight
    }
}

private struct SmallRoutineWidgetView: View {
    let snapshot: RoutineWidgetSnapshot
    let colorScheme: ColorScheme

    var body: some View {
        let routines = Array(snapshot.currentCategory?.routines.prefix(2) ?? [])

        ZStack {
            RoutineWidgetPalette.background(for: colorScheme == .dark)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 6) {
                    Text(snapshot.shortDateText)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(RoutineWidgetPalette.secondaryText(for: colorScheme))
                        .lineLimit(1)

                    Spacer(minLength: 4)

                    CompactProgressView(snapshot: snapshot, colorScheme: colorScheme)
                }

                VStack(spacing: 6) {
                    ForEach(routines) { routine in
                        SmallRoutineLine(routine: routine, colorScheme: colorScheme)
                    }
                }

                Spacer(minLength: 0)

                HStack(spacing: 8) {
                    Spacer(minLength: 0)
                    WidgetIconButton(symbol: "chevron.left", intent: ShiftCategoryIntent(direction: -1), colorScheme: colorScheme)
                    WidgetIconButton(symbol: "chevron.right", intent: ShiftCategoryIntent(direction: 1), colorScheme: colorScheme)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(10)
        }
    }
}

private struct MediumRoutineWidgetView: View {
    let snapshot: RoutineWidgetSnapshot
    let colorScheme: ColorScheme

    var body: some View {
        ZStack {
            RoutineWidgetPalette.background(for: colorScheme == .dark)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center, spacing: 8) {
                    Text(snapshot.shortDateText)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundStyle(RoutineWidgetPalette.secondaryText(for: colorScheme))
                        .lineLimit(1)

                    Spacer(minLength: 8)

                    CompactProgressView(snapshot: snapshot, colorScheme: colorScheme)

                    WidgetIconButton(symbol: "chevron.left", intent: ShiftCategoryIntent(direction: -1), colorScheme: colorScheme)
                    WidgetIconButton(symbol: "chevron.right", intent: ShiftCategoryIntent(direction: 1), colorScheme: colorScheme)
                }

                VStack(spacing: 6) {
                    ForEach(Array(snapshot.currentCategory?.routines.prefix(2) ?? [])) { routine in
                        MediumRoutineRow(routine: routine, colorScheme: colorScheme)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
    }
}

private struct CompactProgressView: View {
    let snapshot: RoutineWidgetSnapshot
    let colorScheme: ColorScheme

    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(snapshot.percentText)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(RoutineWidgetPalette.primaryText(for: colorScheme))

            Capsule()
                .fill(RoutineWidgetPalette.accent.opacity(0.2))
                .frame(width: 46, height: 5)
                .overlay(alignment: .leading) {
                    Capsule()
                        .fill(RoutineWidgetPalette.accentStrong)
                        .frame(width: max(8, 46 * snapshot.completionValue), height: 5)
                }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(RoutineWidgetPalette.cardFill(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(RoutineWidgetPalette.border(for: colorScheme), lineWidth: 1)
        )
    }
}

private struct SmallRoutineLine: View {
    let routine: RoutineWidgetItem
    let colorScheme: ColorScheme

    var body: some View {
        HStack(spacing: 8) {
            Button(intent: ToggleRoutineIntent(routineID: routine.id)) {
                CheckOrb(isCompleted: routine.isCompleted, colorScheme: colorScheme)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(routine.title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(RoutineWidgetPalette.primaryText(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .allowsTightening(true)
                Text(routine.timeText)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(RoutineWidgetPalette.secondaryText(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer()
        }
    }
}

private struct MediumRoutineRow: View {
    let routine: RoutineWidgetItem
    let colorScheme: ColorScheme

    var body: some View {
        HStack(spacing: 8) {
            Button(intent: ToggleRoutineIntent(routineID: routine.id)) {
                CheckOrb(isCompleted: routine.isCompleted, colorScheme: colorScheme)
            }
            .buttonStyle(.plain)

            Text(routine.mainGoalTitle ?? routine.subtitle)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(RoutineWidgetPalette.primaryText(for: colorScheme))
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .allowsTightening(true)
                .frame(width: 64, alignment: .leading)

            VStack(alignment: .leading, spacing: 3) {
                Text(routine.title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(RoutineWidgetPalette.primaryText(for: colorScheme))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .allowsTightening(true)
                Text(routine.timeText)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(RoutineWidgetPalette.secondaryText(for: colorScheme))
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 42, maxHeight: 42, alignment: .leading)
        .padding(.horizontal, 10)
        .background(RoutineWidgetPalette.cardFill(for: colorScheme))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(RoutineWidgetPalette.border(for: colorScheme), lineWidth: 1)
        )
    }
}

private struct CheckOrb: View {
    let isCompleted: Bool
    let colorScheme: ColorScheme

    var body: some View {
        ZStack {
            Circle()
                .fill(isCompleted ? RoutineWidgetPalette.accent : RoutineWidgetPalette.cardFill(for: colorScheme))
            Circle()
                .stroke(isCompleted ? RoutineWidgetPalette.accentStrong.opacity(0.55) : RoutineWidgetPalette.border(for: colorScheme), lineWidth: 1)
            Image(systemName: isCompleted ? "checkmark" : "circle")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(isCompleted ? Color.white : RoutineWidgetPalette.secondaryText(for: colorScheme))
                .contentTransition(.symbolEffect(.replace))
        }
        .frame(width: 24, height: 24)
        .shadow(color: isCompleted ? RoutineWidgetPalette.accentStrong.opacity(0.18) : .clear, radius: 6, y: 3)
    }
}

private struct WidgetIconButton<IntentType: AppIntent>: View {
    let symbol: String
    let intent: IntentType
    let colorScheme: ColorScheme

    var body: some View {
        Button(intent: intent) {
            Image(systemName: symbol)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(RoutineWidgetPalette.primaryText(for: colorScheme))
                .frame(width: 24, height: 24)
                .background(RoutineWidgetPalette.cardFill(for: colorScheme))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(RoutineWidgetPalette.border(for: colorScheme), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct WidgetTextButton<IntentType: AppIntent>: View {
    let title: String
    let symbol: String
    let intent: IntentType
    let colorScheme: ColorScheme
    var reverse: Bool = false

    var body: some View {
        Button(intent: intent) {
            HStack(spacing: 6) {
                if reverse {
                    Text(title)
                    Image(systemName: symbol)
                } else {
                    Image(systemName: symbol)
                    Text(title)
                }
            }
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .foregroundStyle(RoutineWidgetPalette.primaryText(for: colorScheme))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(RoutineWidgetPalette.cardFill(for: colorScheme))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(RoutineWidgetPalette.border(for: colorScheme), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private extension Date {
    func mondayBasedIndex() -> Int {
        let weekday = Calendar.current.component(.weekday, from: self)
        return (weekday + 5) % 7
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension RoutineWidgetItem: Identifiable {}

#Preview("Small", as: .systemSmall) {
    OneByteTodayRoutineWidget()
} timeline: {
    OneByteRoutineEntry(date: .now, snapshot: .placeholder)
}

#Preview("Medium", as: .systemMedium) {
    OneByteTodayRoutineWidget()
} timeline: {
    OneByteRoutineEntry(date: .now, snapshot: .placeholder)
}
