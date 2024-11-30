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
            return "여러분의 루틴 관리를\n도와드릴게요"
        case .second:
            return "목표와 루틴을 설정해서\n클로버를 심을 수 있어요"
        case .third:
            return "주간 루틴을 잘 지키고 있는지\n한눈에 확인할 수 있어요"
        case .fourth:
            return "한 주를 마무리하며\n성취를 확인할 수 있어요"
        case .fifth:
            return "설정 시간에 맞춰\n알림을 보내드릴게요"
        }
    }
    
    var onboardingSubTitle: String {
        switch self {
        case .first:
            return "지금부터 앱에 대한 소개를 시작해볼게요!"
        case .second:
            return "최대 4개의 목표와\n목표당 최대 3개의 루틴을 작성할 수 있어요"
        case .third:
            return "루틴을 하나씩 완료할 때마다\n클로버의 색상이 점점 진해져요"
        case .fourth:
            return "매주 일요일 자정에 지난주의 성취에 따라\n클로버를 획득할 수 있어요"
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
