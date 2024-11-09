//
//  OnboardingExplain.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

enum OnboardingExplain: CaseIterable {
    
    case first, second, third, fourth
    
    var explainTitle: String {
        switch self {
        case .first:
            return "만다라트란?"
        case .second:
            return "최종 목표를 이루기 위한\n세부목표와 할 일"
        case .third:
            return "만다라트의 모든 칸을\n다 채울 필요는 없습니다"
        case .fourth:
            return "만다라트를 활용해\n다라와 함께 목표를 작성해봐요"
        }
    }
    
    var explainSubTitle: String {
        switch self {
        case .first:
            return "나의 큰 목표를 달성하기 위해 목표를 세분화하고,\n시각화하여 이루고 싶은 목표가 무엇인지\n명확하게 보여주는 방법입니다."
        case .second:
            return "1개의 최종 목표를 정하고, 해당 최종 목표를 이루기 위한\n8개의 세부 목표를 작성합니다. 그리고 세부 목표 하나를\n이루기 위한 8개의 할 일을 작성하면 됩니다."
        case .third:
            return "\"내가 이룰 목표는 무엇인지\",\"그 목표를 이루기 위한\n하위 단계는 무엇이 될지\"를 고민하여 쪼개는 과정에\n집중해보세요."
        case .fourth:
            return ""
        }
    }
    
    var explainImage: Image {
        switch self {
        case .first:
            return Image(systemName: "command")
        case .second:
            return Image(systemName: "command.circle")
        case .third:
            return Image(systemName: "command.circle.fill")
        case .fourth:
            return Image(systemName: "command.square")
            
        }
    }
}
