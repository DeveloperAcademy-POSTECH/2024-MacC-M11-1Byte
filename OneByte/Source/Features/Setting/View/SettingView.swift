//
//  SettingView.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    
    @Query private var profile: [Profile]
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel = SettingViewModel()
    @Binding var isTabBarMainVisible: Bool
    
    @State private var nickname: String = UserDefaults.loadNickname()
    private let updateNotes: [UpdateVersionSection] = UpdateVersionSection.sampleNotes

    var body: some View {
        NavigationStack {
            ZStack {
                Color.myF0E8DF
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
//                    HStack {
//                        profileInfoView()
//                    }
//                    .padding()
//                    .background(.white)
                    
                    VStack {
                        Divider()
                            .foregroundStyle(.clear)

                        NavigationLink {
                            SettingNotificationGuideView(viewModel: viewModel)
                        } label: {
                            SettingMenuRow(
                                title: "알림 설정",
                                subtitle: viewModel.notificationStatus.description
                            )
                        }

                        Divider()
                            .foregroundStyle(Color.myF0E8DF)

                        NavigationLink {
                            UpdateHistoryView(currentVersion: viewModel.appVersion, notes: updateNotes)
                        } label: {
                            SettingMenuRow(
                                title: "업데이트 내역",
                                subtitle: "Version \(viewModel.appVersion) 변경사항 보기"
                            )
                        }

                        Divider()
                            .foregroundStyle(.clear)
                    }
                    .background(.white)

                    HStack {
                        Text("Version \(viewModel.appVersion)")
                            .font(.setPretendard(weight: .medium, size: 16))
                            .foregroundStyle(.myB4A99D)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.viewModel.settingViewTabBarVisible = true
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .tint(Color.myB4A99D)
                }
            }
        }
        .toolbar(viewModel.settingViewTabBarVisible ? .visible : .hidden, for: .tabBar)
        .onAppear {
            isTabBarMainVisible = false
            viewModel.settingViewTabBarVisible = false // 첫 진입시 Tabbar 숨김
            viewModel.readProfile(profile) // 닉네임 정보
            viewModel.getDaysSinceInstall() // 앱 설치한지 몇일 됐는지 계산
            viewModel.refreshNotificationStatus()
        }
        .sheet(isPresented: $viewModel.isEditNicknameSheet) {
            EditNicknameSheetView(viewModel: viewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(244/852 * UIScreen.main.bounds.height)])
        }
    }
    
    @ViewBuilder
    private func profileInfoView() -> some View {
        HStack(spacing: 20) {
            Image("DefaultProfile")
                .resizable()
                .clipShape(Circle())
                .frame(width: 82, height: 82)
            
            VStack(spacing: 5) {
                HStack {
                    let nickname = UserDefaults.loadNickname()
                    if !nickname.isEmpty {
                        Text("\(nickname)님")
                            .font(.setPretendard(weight: .bold, size: 18))
                            .lineLimit(1)
                    } else {
                        Text("닉네임 설정")
                            .font(.setPretendard(weight: .bold, size: 18))
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.setPretendard(weight: .medium, size: 16))
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .onTapGesture {
                    viewModel.isEditNicknameSheet = true
                }
                
                HStack {
                    Text("하고만다와 함께한지 \(viewModel.daysSinceInstall)일 째")
                        .font(.setPretendard(weight: .semiBold, size: 14))
                        .foregroundStyle(.my566956)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 5)
    }
}

private struct SettingMenuRow: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.setPretendard(weight: .semiBold, size: 16))
                    .foregroundStyle(.black)
                Text(subtitle)
                    .font(.setPretendard(weight: .medium, size: 13))
                    .foregroundStyle(.my878787)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.myB4A99D)
        }
        .padding()
    }
}

private struct SettingNotificationGuideView: View {
    @Query private var mainGoals: [MainGoal]
    @Bindable var viewModel: SettingViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("로컬 알림 안내")
                        .font(.setPretendard(weight: .bold, size: 20))
                        .foregroundStyle(.my2B2B2B)
                    Text("하고만다는 서버 없이 iPhone의 로컬 알림으로 루틴 시작 시간을 알려드려요.")
                        .font(.setPretendard(weight: .medium, size: 15))
                        .foregroundStyle(.my878787)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.white)
                .cornerRadius(16)

                VStack(alignment: .leading, spacing: 12) {
                    Text("현재 상태")
                        .font(.setPretendard(weight: .semiBold, size: 16))
                        .foregroundStyle(.my675542)
                    Text(viewModel.notificationStatus.description)
                        .font(.setPretendard(weight: .medium, size: 14))
                        .foregroundStyle(.my2B2B2B)
                    Button("iPhone 설정에서 알림 열기") {
                        viewModel.openAppSettings()
                    }
                    .font(.setPretendard(weight: .semiBold, size: 15))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.my6FB56F)
                    .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.white)
                .cornerRadius(16)

                VStack(alignment: .leading, spacing: 14) {
                    Text("앱 알림 종류")
                        .font(.setPretendard(weight: .semiBold, size: 16))
                        .foregroundStyle(.my675542)

                    notificationToggleRow(
                        title: "루틴 시간 알림",
                        description: "루틴 생성 시 설정한 시간의 알림을 받아요.",
                        isOn: Binding(
                            get: { viewModel.routineReminderEnabled },
                            set: { viewModel.updateRoutineReminderEnabled($0, mainGoals: mainGoals) }
                        )
                    )

                    Divider()

                    notificationToggleRow(
                        title: "미완료 루틴 알림",
                        description: "설정한 시간에 오늘 아직 완료하지 않은 루틴을 알려드려요.",
                        isOn: Binding(
                            get: { viewModel.incompleteRoutineReminderEnabled },
                            set: { viewModel.updateIncompleteRoutineReminderEnabled($0, mainGoals: mainGoals) }
                        )
                    )

                    if viewModel.incompleteRoutineReminderEnabled {
                        Divider()

                        HStack(alignment: .center, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("미완료 알림 시간")
                                    .font(.setPretendard(weight: .semiBold, size: 16))
                                    .foregroundStyle(.my2B2B2B)
                                Text("기본값은 오후 11시이며, 원하는 시간으로 바꿀 수 있어요.")
                                    .font(.setPretendard(weight: .medium, size: 13))
                                    .foregroundStyle(.my878787)
                            }
                            Spacer(minLength: 12)
                            DatePicker(
                                "",
                                selection: Binding(
                                    get: { viewModel.incompleteRoutineReminderTime },
                                    set: { viewModel.updateIncompleteRoutineReminderTime($0, mainGoals: mainGoals) }
                                ),
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "ko_KR"))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.white)
                .cornerRadius(16)
            }
            .padding()
        }
        .background(Color.myF0E8DF)
        .navigationTitle("알림 설정")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.refreshNotificationStatus()
        }
    }

    @ViewBuilder
    private func notificationToggleRow(title: String, description: String, isOn: Binding<Bool>) -> some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.setPretendard(weight: .semiBold, size: 16))
                    .foregroundStyle(.my2B2B2B)
                Text(description)
                    .font(.setPretendard(weight: .medium, size: 13))
                    .foregroundStyle(.my878787)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 16)
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.my538F53)
        }
    }
}

private struct UpdateVersionSection: Identifiable {
    struct Change: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let description: String
    }

    let id = UUID()
    let version: String
    let date: String
    let changes: [Change]

    static let sampleNotes: [UpdateVersionSection] = [
        UpdateVersionSection(
            version: "1.2.2",
            date: "2026.08.09",
            changes: [
                .init(icon: "checkmark.circle", title: "주 n회 루틴 안정화", description: "주간 수행 횟수가 정확하게 계산되고, 루틴을 체크하거나 편집해도 목록과 클로버가 자연스럽게 유지돼요."),
                .init(icon: "calendar.badge.clock", title: "오늘과 어제 루틴 구분", description: "오늘 루틴을 먼저 보여주고 어제 미완료 루틴은 아래에 구분했어요. 오후 1시 이후에는 수정 불가 안내도 함께 보여줘요."),
                .init(icon: "square.grid.3x3", title: "위젯 체크 동기화 개선", description: "위젯에서 체크한 루틴이 앱에 정확하게 반영되고, 오늘 수행할 수 없는 루틴은 회색으로 구분돼요."),
                .init(icon: "bell.badge", title: "루틴 알림 정확도 개선", description: "주 n회 목표를 달성하면 해당 루틴 알림이 더 이상 예약되지 않도록 개선했어요."),
                .init(icon: "wrench.and.screwdriver", title: "루틴 데이터 안정성 개선", description: "루틴을 삭제하거나 다시 만들 때 기존 체크 기록과 알림이 남지 않도록 정리했어요.")
            ]
        ),
        UpdateVersionSection(
            version: "1.2.1",
            date: "2026.07.03",
            changes: [
                .init(icon: "square.grid.2x2", title: "Large Widget 추가", description: "메인화면과 같은 루틴을 Large Widget으로 확인하고, 체크 상태도 앱과 함께 동기화할 수 있어요."),
                .init(icon: "arrow.triangle.2.circlepath", title: "위젯 루틴 표시 개선", description: "오늘 수행해야 하는 루틴은 연두색으로, 오늘 대상이 아닌 루틴은 연한 회색으로 구분해 더 쉽게 볼 수 있어요."),
                .init(icon: "clock.badge.checkmark", title: "어제 미완료 루틴 규칙 정리", description: "전날 미완료한 루틴은 한국시간 오후 1시 전까지만 확인하고 체크할 수 있어요."),
                .init(icon: "text.cursor", title: "루틴 생성 경험 개선", description: "텍스트 선택 메뉴를 한글로 맞추고, 요일 대신 주간 수행 횟수로 관리하는 루틴도 추가할 수 있어요."),
                .init(icon: "bell", title: "알림 설정 고도화", description: "기존 루틴 알림과 미완료 루틴 알림을 각각 켜고 끌 수 있고, 미완료 알림 시간도 원하는 대로 바꿀 수 있어요.")
            ]
        )
    ]
}

private struct UpdateHistoryView: View {
    let currentVersion: String
    let notes: [UpdateVersionSection]
    private let detailURL = URL(string: "https://app.notion.com/p/7-391eee5969208047a469ecf25836a521?source=copy_link")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("새로운 기능")
                        .font(.setPretendard(weight: .bold, size: 24))
                        .foregroundStyle(.my2B2B2B)
                    Text("현재 버전 \(currentVersion)")
                        .font(.setPretendard(weight: .medium, size: 14))
                        .foregroundStyle(.my878787)
                }
                .padding(.horizontal)

                HStack {
                    Button {
                        guard let detailURL else { return }
                        UIApplication.shared.open(detailURL)
                    }
                label: {
                        HStack(spacing: 6) {
                            Text("자세히보기")
                                .font(.setPretendard(weight: .semiBold, size: 14))
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.my6FB56F)
                    .cornerRadius(12)
                    Spacer()
                }
                .padding(.horizontal)

                ForEach(notes) { note in
                    UpdateVersionCard(note: note)
                }
            }
            .padding(.vertical)
        }
        .background(Color.myF0E8DF)
        .navigationTitle("업데이트 내역")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct UpdateVersionCard: View {
    let note: UpdateVersionSection

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(versionTitle)
                .font(.setPretendard(weight: .bold, size: 20))
                .foregroundStyle(.my2B2B2B)
            Text(note.date)
                .font(.setPretendard(weight: .medium, size: 13))
                .foregroundStyle(.my878787)

            ForEach(note.changes) { change in
                UpdateChangeCard(change: change)
            }
        }
        .padding()
        .background(Color.myFFFAF4)
        .cornerRadius(20)
        .padding(.horizontal)
    }

    private var versionTitle: String {
        "Version \(note.version)"
    }
}

private struct UpdateChangeCard: View {
    let change: UpdateVersionSection.Change

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: change.icon)
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Color.my6FB56F)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(change.title)
                    .font(.setPretendard(weight: .semiBold, size: 16))
                    .foregroundStyle(.my2B2B2B)
                Text(change.description)
                    .font(.setPretendard(weight: .medium, size: 14))
                    .foregroundStyle(.my878787)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}

extension UserDefaults {
    private static let nicknameKey = "nicknameKey"
    private static let deviceUUIDKey = "deviceUUIDKey"
    
    static let calendarData = [
        // 2024년 ( 연도 / 월 / 월차 / 주차 / 클로버 스테이트 0 )
        (2024, 11, 1, 45, 0), (2024, 11, 2, 46, 0), (2024, 11, 3, 47, 0), (2024, 11, 4, 48, 0),
        (2024, 12, 1, 49, 0), (2024, 12, 2, 50, 0), (2024, 12, 3, 51, 0), (2024, 12, 4, 52, 0),
        // 2025년
        (2025, 1, 1, 1, 0), (2025, 1, 2, 2, 0), (2025, 1, 3, 3, 0), (2025, 1, 4, 4, 0), (2025, 1, 5, 5, 0),
        (2025, 2, 1, 6, 0), (2025, 2, 2, 7, 0), (2025, 2, 3, 8, 0), (2025, 2, 4, 9, 0),
        (2025, 3, 1, 10, 0), (2025, 3, 2, 11, 0), (2025, 3, 3, 12, 0), (2025, 3, 4, 13, 0),
        (2025, 4, 1, 14, 0), (2025, 4, 2, 15, 0), (2025, 4, 3, 16, 0), (2025, 4, 4, 17, 0),
        (2025, 5, 1, 18, 0), (2025, 5, 2, 19, 0), (2025, 5, 3, 20, 0), (2025, 5, 4, 21, 0), (2025, 5, 5, 22, 0),
        (2025, 6, 1, 23, 0), (2025, 6, 2, 24, 0), (2025, 6, 3, 25, 0), (2025, 6, 4, 26, 0),
        (2025, 7, 1, 27, 0), (2025, 7, 2, 28, 0), (2025, 7, 3, 29, 0), (2025, 7, 4, 30, 0), (2025, 7, 5, 31, 0),
        (2025, 8, 1, 32, 0), (2025, 8, 2, 33, 0), (2025, 8, 3, 34, 0), (2025, 8, 4, 35, 0),
        (2025, 9, 1, 36, 0), (2025, 9, 2, 37, 0), (2025, 9, 3, 38, 0), (2025, 9, 4, 39, 0),
        (2025, 10, 1, 40, 0), (2025, 10, 2, 41, 0), (2025, 10, 3, 42, 0), (2025, 10, 4, 43, 0), (2025, 10, 5, 44, 0),
        (2025, 11, 1, 45, 0), (2025, 11, 2, 46, 0), (2025, 11, 3, 47, 0), (2025, 11, 4, 48, 0),
        (2025, 12, 1, 49, 0), (2025, 12, 2, 50, 0), (2025, 12, 3, 51, 0), (2025, 12, 4, 52, 0),
        // 2026년
        (2026, 1, 1, 1, 0), (2026, 1, 2, 2, 0), (2026, 1, 4, 3, 0), (2026, 1, 3, 4, 0), (2026, 1, 5, 5, 0),
        (2026, 2, 1, 6, 0), (2026, 2, 2, 7, 0), (2026, 2, 4, 8, 0), (2026, 2, 3, 9, 0),
        (2026, 3, 1, 10, 0), (2026, 3, 2, 11, 0), (2026, 3, 4, 12, 0), (2026, 3, 3, 13, 0),
        (2026, 4, 1, 14, 0), (2026, 4, 2, 15, 0), (2026, 4, 4, 16, 0), (2026, 4, 3, 17, 0), (2026, 4, 5, 18, 0),
        (2026, 5, 1, 19, 0), (2026, 5, 2, 20, 0), (2026, 5, 4, 21, 0), (2026, 5, 3, 22, 0),
        (2026, 6, 1, 23, 0), (2026, 6, 2, 24, 0), (2026, 6, 4, 25, 0), (2026, 6, 3, 26, 0),
        (2026, 7, 1, 27, 0), (2026, 7, 2, 28, 0), (2026, 7, 4, 29, 0), (2026, 7, 3, 30, 0), (2026, 7, 5, 31, 0),
        (2026, 8, 1, 32, 0), (2026, 8, 2, 33, 0), (2026, 8, 4, 34, 0), (2026, 8, 3, 35, 0),
        (2026, 9, 1, 36, 0), (2026, 9, 2, 37, 0), (2026, 9, 4, 38, 0), (2026, 9, 3, 39, 0),
        (2026, 10, 1, 40, 0), (2026, 10, 2, 41, 0), (2026, 10, 4, 42, 0), (2026, 10, 3, 43, 0), (2026, 10, 5, 44, 0),
        (2026, 11, 1, 45, 0), (2026, 11, 2, 46, 0), (2026, 11, 4, 47, 0), (2026, 11, 3, 48, 0),
        (2026, 12, 1, 49, 0), (2026, 12, 2, 50, 0), (2026, 12, 4, 51, 0), (2026, 12, 3, 52, 0), (2026, 12, 5, 53, 0)
    ]
    
    // 닉네임 저장
    static func saveNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: nicknameKey)
    }
    
    // 닉네임 불러오기
    static func loadNickname() -> String {
        return UserDefaults.standard.string(forKey: nicknameKey) ?? ""
    }
    
    static func saveDeviceUUID() {
        if UserDefaults.standard.string(forKey: deviceUUIDKey) == nil {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: deviceUUIDKey)
            print("✅ UUID 저장 완료: \(uuid)")
        }
    }

    static func loadDeviceUUID() -> String {
        let uuid = UserDefaults.standard.string(forKey: deviceUUIDKey) ?? "None"
        print("📤 UUID 불러오기: \(uuid)")
        return uuid
    }
        
    static func loadInstallYear() -> Int? {
        guard let installDateString = UserDefaults.standard.string(forKey: "userInstallDate") else {
            print("❌ userInstallDate을 찾을 수 없습니다")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let installDate = formatter.date(from: installDateString) else {
            print("❌ userInstallDate를 Date 객체로 변환하는 데 실패했습니다.")
            return nil
        }
        
        let calendar = Calendar(identifier: .iso8601)
        let year = calendar.component(.year, from: installDate)
        return year
    }
    
    static func loadInstallMonth() -> Int? {
        guard let installDateString = UserDefaults.standard.string(forKey: "userInstallDate") else {
            print("❌ userInstallDate을 찾을 수 없습니다")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let installDate = formatter.date(from: installDateString) else {
            print("❌ userInstallDate를 Date 객체로 변환하는 데 실패했습니다.")
            return nil
        }
        
        let calendar = Calendar(identifier: .iso8601)
        let weekOfYear = calendar.component(.weekOfYear, from: installDate)
        let year = calendar.component(.year, from: installDate)
        
        if let data = calendarData.first(where: { $0.0 == year && $0.3 == weekOfYear }) {
            return data.1
        }
        return calendar.component(.month, from: Date())
    }
    
    static func loadInstallWeekOfYear() -> Int? {
        guard let installDateString = UserDefaults.standard.string(forKey: "userInstallDate") else {
            print("❌ userInstallDate을 찾을 수 없습니다.")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let installDate = formatter.date(from: installDateString) else {
            print("❌ userInstallDate을 Date 객체로 변환하는 데 실패했습니다.")
            return nil
        }
        
        let calendar = Calendar(identifier: .iso8601)
        let weekOfYear = calendar.component(.weekOfYear, from: installDate)
        return weekOfYear
    }
}

#Preview {
    SettingView(isTabBarMainVisible: .constant(true))
}
