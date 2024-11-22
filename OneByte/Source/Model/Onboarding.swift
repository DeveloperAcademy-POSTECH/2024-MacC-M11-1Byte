//
//  Onboarding.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

// MARK: 온보딩 목표설정 Enumeration 데이터
enum Onboarding: CaseIterable {
    
    case ready, subgoalCycle, detailgoalCycle, daysCycle, completeCycle, finish
    
    var onboardingTitle: String {
        switch self {
        case .ready:
            return "다라와 함께\n목표설정을 시작해봐요"
        case .subgoalCycle:
            return "달성하고 싶은 목표가\n무엇인가요?"
        case .detailgoalCycle:
            return "목표 달성을 위해\n어떤 루틴이 필요할까요?"
        case .daysCycle:
            return "매주 어떤 요일에\n실천할 루틴인가요?"
        case .completeCycle:
            return "첫 목표와 루틴 작성이\n완료되었어요"
        case .finish:
            return "이제 스스로 목표와 루틴을\n작성해봐요"
        }
    }
    
    var onboardingSubTitle: String {
        switch self {
        case .ready:
            return "4가지 목표 중 하나를 함께 작성해보고\n목표달성을 위한 루틴도 만들어봐요"
        case .subgoalCycle:
            return "나의 꾸준한 노력으로 이루고 싶은 일들은\n어떤 것이 있을지 떠올려보세요"
        case .detailgoalCycle:
            return "목표를 달성하기 위해 실천해야 하는\n노력들은 무엇이 있을지 생각해보세요"
        case .daysCycle:
            return "루틴을 실천할 요일을 선정하여\n루틴을 구체화해보세요"
        case .completeCycle:
            return "루틴 설정으로 이동하여\n메모와 알람 시간도 추가할 수 있어요"
        case .finish:
            return "꾸준한 노력으로 목표를 이루는 그 날까지\n만부기가 응원할게요!"
        }
    }
}
