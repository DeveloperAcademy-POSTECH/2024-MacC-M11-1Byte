//
//  Onboarding.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

enum Onboarding {
    case start, question, maingoal
    
    var onboardingTitle: String {
        switch self {
        case .start:
            return "안녕하세요. 다라에요!"
        case .question:
            return "만다라트가 무엇인지\n알고 계시나요?"
        case .maingoal:
            return "2025년 달성하고 싶은\n최종 목표는 무엇인가요?"
        }
    }
    
    var onboardingSubTitle: String {
        switch self {
        case .start:
            return "2025년 목표를 세우고 싶으신가요?\n1년 동안 이루고 싶은 목표를 세우기를\n도와드릴게요!"
        case .question:
            return "'만다라트' 기법을 사용해 1년의 목표를\n 세울 수 있도록 도와드릴게요."
        case .maingoal:
            return ""
        }
    }
    
    var onboardingTipMessage: String {
        switch self {
        case .start:
            return ""
        case .question:
            return ""
        case .maingoal:
            return "'매일 성장하는 사람', 프로 갓생러'와 같이 내가 되고\n싶은 나의 모습을 떠올려 보세요. '잔잔하지만, 알맹이 있는\n한 해'와 같이 2025년이 어떤 모습이었으면 좋겠는지\n상상해도 좋습니다."
        }
    }
    
}


