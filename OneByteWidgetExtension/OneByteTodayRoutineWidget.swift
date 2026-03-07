import WidgetKit
import SwiftUI

struct OneByteRoutineEntry: TimelineEntry {
    let date: Date
    let dateText: String
    let totalCount: Int
    let completedCount: Int
    let nextRoutine: String

    var progressText: String {
        "\(completedCount)/\(totalCount)"
    }

    var progressValue: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
}

struct OneByteRoutineProvider: TimelineProvider {
    private let widgetAppGroupID = "group.com.san.OneByte"
    private let widgetTotalKey = "widget_today_total_count"
    private let widgetCompletedKey = "widget_today_completed_count"
    private let widgetDateKey = "widget_today_date_text"
    private let widgetNextRoutineKey = "widget_today_next_routine"

    func placeholder(in context: Context) -> OneByteRoutineEntry {
        OneByteRoutineEntry(
            date: Date(),
            dateText: "3월 7일 토요일",
            totalCount: 5,
            completedCount: 2,
            nextRoutine: "물 1잔 마시기"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (OneByteRoutineEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<OneByteRoutineEntry>) -> Void) {
        let entry = loadEntry()
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date().addingTimeInterval(1800)
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    private func loadEntry() -> OneByteRoutineEntry {
        guard let defaults = UserDefaults(suiteName: widgetAppGroupID) else {
            return OneByteRoutineEntry(
                date: Date(),
                dateText: "공유 설정 필요",
                totalCount: 0,
                completedCount: 0,
                nextRoutine: "App Group을 확인해 주세요"
            )
        }
        let totalCount = defaults.integer(forKey: widgetTotalKey)
        let completedCount = defaults.integer(forKey: widgetCompletedKey)
        let dateText = defaults.string(forKey: widgetDateKey) ?? "오늘"
        let nextRoutine = defaults.string(forKey: widgetNextRoutineKey) ?? "오늘의 루틴을 확인해보세요"

        return OneByteRoutineEntry(
            date: Date(),
            dateText: dateText,
            totalCount: totalCount,
            completedCount: completedCount,
            nextRoutine: nextRoutine
        )
    }
}

struct OneByteTodayRoutineWidgetEntryView: View {
    var entry: OneByteRoutineProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("오늘 루틴")
                .font(.headline)
            Text(entry.dateText)
                .font(.caption)
                .foregroundStyle(.secondary)

            ProgressView(value: entry.progressValue)
                .tint(.green)

            Text("완료 \(entry.progressText)")
                .font(.subheadline)
                .bold()

            Text("다음: \(entry.nextRoutine)")
                .font(.caption)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.vertical, 4)
    }
}

struct OneByteTodayRoutineWidget: Widget {
    let kind: String = "OneByteTodayRoutineWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OneByteRoutineProvider()) { entry in
            OneByteTodayRoutineWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("오늘 루틴")
        .description("오늘 루틴 완료 현황을 홈 화면에서 확인해요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

