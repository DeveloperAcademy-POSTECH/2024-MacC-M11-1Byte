//
//  SettingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/15/24.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    
    // 앱 버전정보 가져오기
    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        return "\(version)"
    }
}
