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
    
    var settingViewTabBarVisible: Bool = false // 탭바 hidden 변수
    
    // 프로필 관련 (닉네임 및 디데이)
    var isEditNicknameSheet: Bool = false
    var profile: [Profile] = []
    var newNickname: String = ""
    let nicknameLimit = 10
    var daysSinceInstall: Int = 0
    
    init() {
        self.isAppearAchieved = UserDefaults.standard.bool(forKey: "isAppearAchieved")
        calculateDaysSinceInstall()
    }
    
    var isAppearAchieved: Bool {
        didSet {
            // 달성 표시하기 Bool값을 변경될 때마다 UserDefaults에 저장
            UserDefaults.standard.set(isAppearAchieved, forKey: "isAppearAchieved")
        }
    }
    
    // 앱 설치한지 디데이 계산
    func calculateDaysSinceInstall() {
        let userDefaults = UserDefaults.standard
        let installDateKey = "installDate"
        
        // 앱 설치일을 처음 실행할 때 저장
        if userDefaults.object(forKey: installDateKey) == nil {
            userDefaults.set(Date(), forKey: installDateKey)
        }
        
        // 저장된 설치일과 현재 날짜의 차이 계산
        if let installDate = userDefaults.object(forKey: installDateKey) as? Date {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.day], from: installDate, to: Date())
            daysSinceInstall = components.day ?? 0
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
    
    // 앱 버전정보 가져오기
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "\(version)"
    }
}
