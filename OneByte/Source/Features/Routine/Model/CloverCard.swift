//
//  CloverCard.swift
//  OneByte
//
//  Created by 이상도 on 11/29/24.
//

import Foundation
import SwiftUI

enum CloverCardType : String, CaseIterable {
    
    case basicClover, greenClover, goldClover
    
    var cloverType: String {
        switch self {
        case.basicClover:
            return "클로버 획득 실패" // ⚠️ 디자인 생기면 수정
        case .greenClover:
            return "초록 클로버"
        case .goldClover:
            return "황금 클로버"
        }
    }
    
    var cloverCardTitle: String {
        switch self {
        case.basicClover:
            return "클로버를 획득하지 못했어요." // ⚠️ 디자인 생기면 수정
        case .greenClover:
            return "초록 클로버를 획득했어요!"
        case .goldClover:
            return "황금 클로버를 획득했어요!"
        }
    }
    
    var cloverCardMessage: String {
        switch self {
        case .basicClover:
            return "만북이와 함께 조금더 열심히 해볼까요?" // ⚠️ 디자인 생기면 수정
        case .greenClover:
            return "다음엔 황금클로버에도 도전해보세요."
        case .goldClover:
            return "잘하고 있어요! 앞으로도 지금처럼만 노력해봐요"
        }
    }
    
    // 클로버 카드 배경 이미지
    var cloverCardBackground: String {
        switch self {
        case .basicClover:
            return "GreenCloverBackground" // ⚠️ 디자인 생기면 수정
        case .greenClover:
            return "GreenCloverBackground"
        case .goldClover:
            return "GoldCloverBackground"
        }
    }
    
    // 회전 클로버 아이콘 이미지
    var cloverCardClover: String {
        switch self {
        case .basicClover:
            return "GreenClover"
        case .greenClover:
            return "GreenClover"
        case .goldClover:
            return "GoldClover"
        }
    }
    
    // 클로버 모아보기 버튼 색상
    var buttonColor: Color {
        switch self {
        case .basicClover:
            return Color.myFBAC08 // ⚠️ 디자인 생기면 수정
        case .greenClover:
            return Color.my538F53
        case .goldClover:
            return Color.myFBAC08
        }
    }
    
    // 배경 그라데이션 컬러
    var gradient: LinearGradient {
        switch self {
        case .basicClover: // ⚠️ 디자인 생기면 수정
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.gray]),
                startPoint: .bottom,
                endPoint: .top
            )
        case .greenClover:
            return LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .my3A933A, location: 1.0),
                    Gradient.Stop(color: .my95D895, location: 1.0),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        case .goldClover:
            return  LinearGradient(
                gradient: Gradient(stops: [
                    Gradient.Stop(color: .myC58300, location: 0.0),
                    Gradient.Stop(color: .myDAA728, location: 0.36),
                    Gradient.Stop(color: .myFFE46D, location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}
