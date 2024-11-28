//
//  CloverCard.swift
//  OneByte
//
//  Created by 이상도 on 11/29/24.
//

import Foundation

enum CloverCardType : String, CaseIterable {
    
    case basicClover, greenClover, goldClover
    
    var cloverCardTitle: String {
        switch self {
        case.basicClover:
            return "클로버를 획득하지 못했어요."
        case .greenClover:
            return "초록 클로버를 획득했어요!"
        case .goldClover:
            return "황금 클로버를 획득했어요!"
        }
    }
    
    var cloverCardMessage: String {
        switch self {
        case .basicClover:
            return "만북이와 함께 조금더 열심히 해볼까요?"
        case .greenClover:
            return "다음엔 황금클로버에도 도전해보세요."
        case .goldClover:
            return "잘하고 있어요! 앞으로도 지금처럼만 노력해봐요"
        }
    }
}
