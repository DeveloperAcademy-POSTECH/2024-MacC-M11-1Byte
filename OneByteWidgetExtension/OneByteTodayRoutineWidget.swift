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
        case .systemLarge:
            LargeRoutineWidgetView(snapshot: entry.snapshot, colorScheme: colorScheme)
        default:
            SmallRoutineWidgetView(snapshot: entry.snapshot, colorScheme: colorScheme)
        }
    }
}

struct OneByteTodayRoutineWidget: Widget {
    nonisolated static let kind = "OneByteTodayRoutineWidget"

    let kind: String = OneByteTodayRoutineWidget.kind

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: OneByteRoutineProvider()) { entry in
            OneByteTodayRoutineWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
        .configurationDisplayName("오늘 루틴")
        .description("홈 화면에서 오늘 루틴을 확인하고 바로 체크해요.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
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

    var allRoutines: [RoutineWidgetItem] {
        categories.flatMap(\.routines)
    }

    static var placeholder: RoutineWidgetSnapshot {
        RoutineWidgetSnapshot(
            dateText: "6월 30일 화요일",
            motivationText: "작은 체크 하나로 오늘의 흐름을 만들어요",
            totalCount: 16,
            completedCount: 7,
            nextRoutine: "책 10쪽 읽기",
            selectedCategoryIndex: 0,
            focusedRoutineID: nil,
            categories: [
                RoutineWidgetCategory(
                    id: "daily",
                    title: "일상",
                    subtitle: "7/16 completed",
                    routines: (1...16).map { index in
                        RoutineWidgetItem(
                            id: "daily-\(index)",
                            title: "루틴 \(index)",
                            subtitle: "하고만다",
                            mainGoalTitle: "일상",
                            categoryTitle: "일상",
                            sectionTitle: "Anytime",
                            timeText: "Anytime",
                            isCompleted: index % 3 == 0,
                            isInteractive: index % 4 != 0,
                            currentStreak: index % 4,
                            weeklyStates: [true, false, true, false, true, false, false]
                        )
                    }
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
    var isInteractive: Bool
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
              var snapshot = try? JSONDecoder().decode(RoutineWidgetSnapshot.self, from: data) else {
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
        updateSnapshot { snapshot in
            let todayIndex = Date().mondayBasedIndex()
            for categoryIndex in snapshot.categories.indices {
                guard let routineIndex = snapshot.categories[categoryIndex].routines.firstIndex(where: { $0.id == id }) else {
                    continue
                }

                guard snapshot.categories[categoryIndex].routines[routineIndex].isInteractive else {
                    continue
                }

                appendPendingToggle(id: id)

                snapshot.categories[categoryIndex].routines[routineIndex].isCompleted.toggle()
                let isCompleted = snapshot.categories[categoryIndex].routines[routineIndex].isCompleted
                if snapshot.categories[categoryIndex].routines[routineIndex].weeklyStates.indices.contains(todayIndex) {
                    snapshot.categories[categoryIndex].routines[routineIndex].weeklyStates[todayIndex] = isCompleted
                }
            }

            normalize(snapshot: &snapshot)
        }
    }

    static func shiftCategory(by direction: Int) {
        updateSnapshot { snapshot in
            guard !snapshot.categories.isEmpty else { return }
            let count = snapshot.categories.count
            snapshot.selectedCategoryIndex = wrappedIndex(snapshot.safeCategoryIndex + direction, count: count)
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
            colors: darkMode ? [paperDark, Color.black] : [appBackground, appBackground],
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

private struct LargeRoutineWidgetView: View {
    let snapshot: RoutineWidgetSnapshot
    let colorScheme: ColorScheme

    var body: some View {
        let categories = Array(snapshot.categories.prefix(4))

        ZStack {
            RoutineWidgetPalette.background(for: colorScheme == .dark)

            ZStack {
                VStack(spacing: 18) {
                    HStack(spacing: 18) {
                        LargeRoutineQuadrant(category: categories[safe: 0], quadrantIndex: 0)
                        LargeRoutineQuadrant(category: categories[safe: 1], quadrantIndex: 1)
                    }

                    HStack(spacing: 18) {
                        LargeRoutineQuadrant(category: categories[safe: 2], quadrantIndex: 2)
                        LargeRoutineQuadrant(category: categories[safe: 3], quadrantIndex: 3)
                    }
                }
                LargeCenterBadge()
            }
            .padding(4)
        }
    }
}

private struct LargeRoutineQuadrant: View {
    let category: RoutineWidgetCategory?
    let quadrantIndex: Int
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 2)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(0..<4, id: \.self) { index in
                if index == titleCellIndex {
                    LargeCategoryTile(title: category?.title ?? "")
                } else {
                    let detailIndex = index < titleCellIndex ? index : index - 1
                    if let routine = category?.routines[safe: detailIndex] {
                        LargeRoutineTile(routine: routine, cornerIndex: index)
                    } else {
                        LargePlaceholderTile(cornerIndex: index)
                    }
                }
            }
        }
    }

    private var titleCellIndex: Int {
        max(0, 3 - quadrantIndex)
    }
}

private struct LargeCategoryTile: View {
    let title: String

    var body: some View {
        Text(title)
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
            .font(.system(size: 13, weight: .bold))
            .foregroundStyle(.white)
            .lineLimit(2)
            .minimumScaleFactor(0.72)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(WidgetMandalartPalette.completedTile)
            )
            .aspectRatio(1, contentMode: .fit)
    }
}

private struct LargeRoutineTile: View {
    let routine: RoutineWidgetItem
    let cornerIndex: Int

    var body: some View {
        Group {
            if routine.isInteractive {
                Button(intent: ToggleRoutineIntent(routineID: routine.id)) {
                    tileContent
                }
                .buttonStyle(.plain)
            } else {
                tileContent
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var tileColor: Color {
        guard routine.isInteractive else { return WidgetMandalartPalette.disabledTile }
        return routine.isCompleted ? WidgetMandalartPalette.completedTile : WidgetMandalartPalette.baseTile
    }

    private var tileShape: UnevenRoundedRectangle {
        WidgetMandalartPalette.shape(for: cornerIndex)
    }

    private var textColor: Color {
        routine.isInteractive ? .black : WidgetMandalartPalette.disabledText
    }

    private var tileContent: some View {
        ZStack(alignment: .topTrailing) {
            Text(routine.title)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(textColor)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 10)
                .padding(.vertical, 12)

            if routine.isCompleted {
                Image("GoldClover")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .opacity(routine.isInteractive ? 1 : 0.5)
                    .padding(8)
            } else {
                Color.clear
                    .frame(width: 14, height: 14)
                    .padding(8)
            }
        }
        .background(tileShape.fill(tileColor))
    }
}

private struct LargePlaceholderTile: View {
    let cornerIndex: Int

    var body: some View {
        WidgetMandalartPalette.shape(for: cornerIndex)
            .fill(WidgetMandalartPalette.baseTile)
            .aspectRatio(1, contentMode: .fit)
    }
}

private struct LargeCenterBadge: View {
    var body: some View {
        Image("GoldClover")
            .resizable()
            .scaledToFit()
            .frame(width: 72, height: 72)
    }
}

private enum WidgetMandalartPalette {
    static let baseTile = Color(red: 214 / 255, green: 243 / 255, blue: 212 / 255)
    static let completedTile = Color(red: 149 / 255, green: 216 / 255, blue: 149 / 255)
    static let disabledTile = Color(red: 0.89, green: 0.89, blue: 0.89)
    static let disabledText = Color(red: 0.50, green: 0.50, blue: 0.50)

    static func shape(for cornerIndex: Int) -> UnevenRoundedRectangle {
        switch cornerIndex {
        case 0:
            UnevenRoundedRectangle(
                topLeadingRadius: 30,
                bottomLeadingRadius: 11,
                bottomTrailingRadius: 11,
                topTrailingRadius: 11,
                style: .continuous
            )
        case 1:
            UnevenRoundedRectangle(
                topLeadingRadius: 11,
                bottomLeadingRadius: 11,
                bottomTrailingRadius: 11,
                topTrailingRadius: 30,
                style: .continuous
            )
        case 2:
            UnevenRoundedRectangle(
                topLeadingRadius: 11,
                bottomLeadingRadius: 30,
                bottomTrailingRadius: 11,
                topTrailingRadius: 11,
                style: .continuous
            )
        default:
            UnevenRoundedRectangle(
                topLeadingRadius: 11,
                bottomLeadingRadius: 11,
                bottomTrailingRadius: 30,
                topTrailingRadius: 11,
                style: .continuous
            )
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
            Group {
                if routine.isInteractive {
                    Button(intent: ToggleRoutineIntent(routineID: routine.id)) {
                        CheckOrb(isCompleted: routine.isCompleted, isInteractive: true, colorScheme: colorScheme)
                    }
                    .buttonStyle(.plain)
                } else {
                    CheckOrb(isCompleted: routine.isCompleted, isInteractive: false, colorScheme: colorScheme)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(routine.title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(routine.isInteractive ? RoutineWidgetPalette.primaryText(for: colorScheme) : WidgetMandalartPalette.disabledText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .allowsTightening(true)
                Text(routine.timeText)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(routine.isInteractive ? RoutineWidgetPalette.secondaryText(for: colorScheme) : WidgetMandalartPalette.disabledText.opacity(0.9))
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
            Group {
                if routine.isInteractive {
                    Button(intent: ToggleRoutineIntent(routineID: routine.id)) {
                        CheckOrb(isCompleted: routine.isCompleted, isInteractive: true, colorScheme: colorScheme)
                    }
                    .buttonStyle(.plain)
                } else {
                    CheckOrb(isCompleted: routine.isCompleted, isInteractive: false, colorScheme: colorScheme)
                }
            }

            Text(routine.mainGoalTitle ?? routine.subtitle)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(routine.isInteractive ? RoutineWidgetPalette.primaryText(for: colorScheme) : WidgetMandalartPalette.disabledText)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .allowsTightening(true)
                .frame(width: 64, alignment: .leading)

            VStack(alignment: .leading, spacing: 3) {
                Text(routine.title)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(routine.isInteractive ? RoutineWidgetPalette.primaryText(for: colorScheme) : WidgetMandalartPalette.disabledText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                    .allowsTightening(true)
                Text(routine.timeText)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(routine.isInteractive ? RoutineWidgetPalette.secondaryText(for: colorScheme) : WidgetMandalartPalette.disabledText.opacity(0.9))
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
        .opacity(routine.isInteractive ? 1 : 0.82)
    }
}

private struct CheckOrb: View {
    let isCompleted: Bool
    let isInteractive: Bool
    let colorScheme: ColorScheme

    var body: some View {
        ZStack {
            Circle()
                .fill(fillColor)
            Circle()
                .stroke(strokeColor, lineWidth: 1)
            Image(systemName: isCompleted ? "checkmark" : "circle")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(iconColor)
                .contentTransition(.symbolEffect(.replace))
        }
        .frame(width: 24, height: 24)
        .shadow(color: isInteractive && isCompleted ? RoutineWidgetPalette.accentStrong.opacity(0.18) : .clear, radius: 6, y: 3)
    }

    private var fillColor: Color {
        if !isInteractive { return WidgetMandalartPalette.disabledTile }
        return isCompleted ? RoutineWidgetPalette.accent : RoutineWidgetPalette.cardFill(for: colorScheme)
    }

    private var strokeColor: Color {
        if !isInteractive { return WidgetMandalartPalette.disabledText.opacity(0.4) }
        return isCompleted ? RoutineWidgetPalette.accentStrong.opacity(0.55) : RoutineWidgetPalette.border(for: colorScheme)
    }

    private var iconColor: Color {
        if !isInteractive { return WidgetMandalartPalette.disabledText }
        return isCompleted ? .white : RoutineWidgetPalette.secondaryText(for: colorScheme)
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

private extension Date {
    func mondayBasedIndex() -> Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        let weekday = calendar.component(.weekday, from: self)
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

#Preview("Large", as: .systemLarge) {
    OneByteTodayRoutineWidget()
} timeline: {
    OneByteRoutineEntry(date: .now, snapshot: .placeholder)
}
