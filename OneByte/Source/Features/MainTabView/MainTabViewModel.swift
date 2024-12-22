//
//  MainTabViewModel.swift
//  OneByte
//
//  Created by 이상도 on 12/20/24.
//

import Foundation
import UIKit

@Observable
class MainTabViewModel {
    
    var isTabBarMainVisible = true
    var selectedTab = 0
    var showCloverCardView = false  // 초기화 시점 판단 하여 클로버 카드뷰 제어
    
    // 햅틱
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
