//
//  OnboardingExplain.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

// MARK: 온보딩 설명탭 Pages Enumeration 데이터
enum OnboardingExplain: CaseIterable {
    
    case first, second, third, fourth, fifth
    
    var onboardingTitle: String {
        switch self {
        case .first:
            return "안녕하세요\n주간 루틴 관리 메이트\n만부기예요."
        case .second:
            return "달성하고 싶은 목표를\n루틴으로 관리해 보세요"
        case .third:
            return "주간 루틴을 잘 지키고 있는지\n한눈에 확인할 수 있어요"
        case .fourth:
            return "성취도에 따라 매주 일요일 자정\n주간 클로버가 수집됩니다"
        case .fifth:
            return "설정 시간에 맞춰\n알림을 보내드릴게요"
        }
    }
    
    var onboardingSubTitle: String {
        switch self {
        case .first:
            return ""
        case .second:
            return "최대 4개의 목표와\n목표당 최대 3개의 루틴을 작성할 수 있어요"
        case .third:
            return "주간 루틴을 실천할 때마다\n클로버의 색상이 진해지는 것을 확인할 수 있어요"
        case .fourth:
            return "일주일중 1개라도 실천하면 초록 클로버\n모든 루틴을 성취하면 황금클로버를 수집할 수 있어요"
        case .fifth:
            return "알림을 통해 잊지 않고 루틴을 실천해보세요"
        }
    }
    
    var explainImage: Image {
        switch self {
        case .first:
            return Image("OnboardingTurtle1")
        case .second:
            return Image("OnboardingImage1")
        case .third:
            return Image("OnboardingImage2")
        case .fourth:
            return Image("OnboardingImage3")
        case .fifth:
            return Image("OnboardingImage4")
        }
    }
}
