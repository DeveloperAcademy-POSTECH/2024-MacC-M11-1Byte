//
//  SettingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/15/24.
//

import SwiftUI

@Observable
class SettingViewModel{
    
    var isAppearAchieved: Bool {
        didSet {
            // 달성 표시하기 Bool값을 변경될 때마다 UserDefaults에 저장
            UserDefaults.standard.set(isAppearAchieved, forKey: "isAppearAchieved")
        }
    }
    
    init() {
        self.isAppearAchieved = UserDefaults.standard.bool(forKey: "isAppearAchieved")
    }
    
    // 앱 버전정보 가져오기
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "\(version)"
    }
}
