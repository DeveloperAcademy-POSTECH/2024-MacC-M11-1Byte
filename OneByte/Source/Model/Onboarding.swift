//
//  Onboarding.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

enum Onboarding {
    
    case start, question, maingoal, subgoal, detailgoal, finish
    
    var onboardingTitle: String {
        switch self {
        case .start:
            return "안녕하세요. 다라에요!"
        case .question:
            return "만다라트가 무엇인지\n알고 계시나요?"
        case .maingoal:
            return "2025년 달성하고 싶은\n최종 목표는 무엇인가요?"
        case .subgoal:
            return "세부 목표를 작성해보세요."
        case .detailgoal:
            return "할 일 하나를 작성해보아요."
        case .finish:
            return "수고하셨습니다."
        }
    }
    
    var onboardingSubTitle: String {
        switch self {
        case .start:
            return "2025년 목표를 세우고 싶으신가요?\n1년 동안 이루고 싶은 목표 세우기를\n도와드릴게요!"
        case .question:
            return "'만다라트' 기법을 사용해 1년의 목표를\n 세울 수 있도록 도와드릴게요."
        case .maingoal:
            return ""
        case .subgoal:
            return "최종 목표를 달성하기 위한"
        case .detailgoal:
            return "마지막으로,\n작성하신 세부 목표를 달성하기 위한"
        case .finish:
            return "이제 스스로 남은 만다라트 칸을 채워보세요."
        }
    }
    
    var onboardingTipMessage: String {
        switch self {
        case .start:
            return ""
        case .question:
            return ""
        case .maingoal:
            return "'매일 성장하는 사람', 프로 갓생러'와 같이 내가 되고싶은 나의 모습을 떠올려 보세요. '잔잔하지만, 알맹이 있는한 해'와 같이 2025년이 어떤 모습이었으면 좋겠는지상상해도 좋습니다."
        case .subgoal:
            return "세부 목표는 '건강','학업'과 같은 카테고리나 '새로운 도전을 주저하지 않기'와 같은 목표로도 작성할 수 있습니다."
        case .detailgoal:
            return "할 일을 작성할 때에는 현실적으로 달성 가능한지 또는 구체적으로 행동할 수 있는 내용인지 고려해보아요."
        case .finish:
            return ""
        }
    }
}
