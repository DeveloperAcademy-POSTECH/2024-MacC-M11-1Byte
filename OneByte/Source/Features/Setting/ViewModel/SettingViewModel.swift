//
//  SettingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/15/24.
//

import SwiftUI
import SwiftData

@Observable
class SettingViewModel{
    enum NotificationStatusText {
        case loading
        case enabled
        case disabled
        case undecided

        var description: String {
            switch self {
            case .loading: return "상태 확인 중"
            case .enabled: return "iPhone 설정에서 알림이 허용되어 있어요"
            case .disabled: return "iPhone 설정에서 알림을 켜야 루틴 알림을 받을 수 있어요"
            case .undecided: return "앱에서 알림을 처음 켜면 권한을 요청해요"
            }
        }
    }
    
    var settingViewTabBarVisible: Bool = false // 탭바 hidden 변수
    
    // 프로필 관련 (닉네임 및 디데이)
    var isEditNicknameSheet: Bool = false
    var profile: [Profile] = []
    var newNickname: String = ""
    let nicknameLimit = 10
    var daysSinceInstall: Int = 0
    var notificationStatus: NotificationStatusText = .loading
    var routineReminderEnabled: Bool = isRoutineReminderEnabled()
    var incompleteRoutineReminderEnabled: Bool = isIncompleteRoutineReminderEnabled()
    var incompleteRoutineReminderTime: Date = loadIncompleteRoutineReminderTime()
    
    init() {
        self.isAppearAchieved = UserDefaults.standard.bool(forKey: "isAppearAchieved")
        getDaysSinceInstall()
    }
    
    var isAppearAchieved: Bool {
        didSet {
            // 달성 표시하기 Bool값을 변경될 때마다 UserDefaults에 저장
            UserDefaults.standard.set(isAppearAchieved, forKey: "isAppearAchieved")
        }
    }
    
    // 앱 설치 UserDefaults데이터와 current를 비교하여 디데이 계산
    func getDaysSinceInstall() {
        let userInstallDateKey = "userInstallDate"
        
        if let savedDateString = UserDefaults.standard.string(forKey: userInstallDateKey) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            
            if let installDate = formatter.date(from: savedDateString) {
                var calendar = Calendar(identifier: .gregorian)
                calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
                
                let installDateStartOfDay = calendar.startOfDay(for: installDate)
                let now = Date()
                let nowStartOfDay = calendar.startOfDay(for: now)
                
                let components = calendar.dateComponents([.day], from: installDateStartOfDay, to: nowStartOfDay)
                daysSinceInstall = components.day ?? 0
            }
        }
    }
    
    // 닉네임 정보 불러오기
    func readProfile(_ profile: [Profile]) {
        self.profile = profile
        if let nickName = profile.first?.nickName {
            newNickname = nickName
        }
    }
    
    // 세팅뷰 닉네임View 조건 처리 로직
    var nicknameDisplay: String {
        if let nickName = profile.first?.nickName, !nickName.isEmpty {
            return "\(nickName)님"
        } else {
            return "닉네임 설정"
        }
    }
    
    // 닉네임 변경중 타이핑한 닉네임 비우기
    func clearNewNickname() {
        newNickname = ""
    }
    
    // 닉네임 Update
    func updateNewNickname(modelContext: ModelContext) {
        if let existingProfile = profile.first {
            existingProfile.nickName = newNickname
        } else {
            // 만약 닉네임이 없을경우, 새로 생성
            let newProfile = Profile(nickName: newNickname)
            modelContext.insert(newProfile)
            profile.append(newProfile)
        }
        
        do {
            try modelContext.save()
            print("닉네임 저장 성공")
        } catch {
            print("닉네임 저장 실패: \(error)")
        }
    }
    
    // 하고만다 앱의 '휴대폰 설정'화면으로 이동
    func openAppSettings() {
        openSystemNotificationSettings()
    }

    func updateRoutineReminderEnabled(_ isEnabled: Bool, mainGoals: [MainGoal]) {
        updateNotificationPreference(
            isEnabled: isEnabled,
            applyPreference: {
                setRoutineReminderEnabled($0)
                self.routineReminderEnabled = $0
            },
            mainGoals: mainGoals
        )
    }

    func updateIncompleteRoutineReminderEnabled(_ isEnabled: Bool, mainGoals: [MainGoal]) {
        updateNotificationPreference(
            isEnabled: isEnabled,
            applyPreference: {
                setIncompleteRoutineReminderEnabled($0)
                self.incompleteRoutineReminderEnabled = $0
            },
            mainGoals: mainGoals
        )
    }

    func updateIncompleteRoutineReminderTime(_ date: Date, mainGoals: [MainGoal]) {
        incompleteRoutineReminderTime = date
        setIncompleteRoutineReminderTime(date)
        TodayRoutineViewModel().refreshNotificationSchedules(mainGoals: mainGoals)
    }

    func refreshNotificationStatus() {
        fetchNotificationAuthorizationState { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    self?.notificationStatus = .enabled
                case .denied:
                    self?.notificationStatus = .disabled
                case .notDetermined:
                    self?.notificationStatus = .undecided
                }
                self?.routineReminderEnabled = isRoutineReminderEnabled()
                self?.incompleteRoutineReminderEnabled = isIncompleteRoutineReminderEnabled()
                self?.incompleteRoutineReminderTime = loadIncompleteRoutineReminderTime()
            }
        }
    }
    
    // 앱 버전정보 가져오기
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "\(version)"
    }

    private func updateNotificationPreference(
        isEnabled: Bool,
        applyPreference: @escaping (Bool) -> Void,
        mainGoals: [MainGoal]
    ) {
        guard isEnabled else {
            applyPreference(false)
            TodayRoutineViewModel().refreshNotificationSchedules(mainGoals: mainGoals)
            return
        }

        fetchNotificationAuthorizationState { [weak self] state in
            switch state {
            case .authorized:
                DispatchQueue.main.async {
                    applyPreference(true)
                    TodayRoutineViewModel().refreshNotificationSchedules(mainGoals: mainGoals)
                    self?.refreshNotificationStatus()
                }
            case .notDetermined:
                requestNotificationPermission { granted in
                    DispatchQueue.main.async {
                        applyPreference(granted)
                        if granted {
                            TodayRoutineViewModel().refreshNotificationSchedules(mainGoals: mainGoals)
                        }
                        self?.refreshNotificationStatus()
                    }
                }
            case .denied:
                DispatchQueue.main.async {
                    applyPreference(false)
                    self?.refreshNotificationStatus()
                }
            }
        }
    }
}
