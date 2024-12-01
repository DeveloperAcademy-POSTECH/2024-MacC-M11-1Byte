//
//  CloverCard.swift
//  OneByte
//
//  Created by 이상도 on 11/29/24.
//

import Foundation
import SwiftUI

enum CloverCardType : String, CaseIterable {
    
    case noClover, greenClover, goldClover
    
    var cloverType: String {
        switch self {
        case .noClover:
            return "할 수 있다!"
        case .greenClover:
            return "초록 클로버"
        case .goldClover:
            return "황금 클로버"
        }
    }
    
    var cloverCardTitle: String {
        switch self {
        case .noClover:
            return "이번 주는 더 잘할 수 있어요"
        case .greenClover:
            return "초록 클로버를 획득했어요!"
        case .goldClover:
            return "황금 클로버를 획득했어요!"
        }
    }
    
    var cloverCardMessage: String {
        switch self {
        case .noClover:
            return "항상 완벽할 필요는 없어요\n다시 시작하려는 의지가 중요해요!"
        case .greenClover:
            return "한 주 동안 너무 수고했어요\n이번 주에는 황금클로버에도 도전해봐요!"
        case .goldClover:
            return "루틴을 완벽히 수행했어요\n지금처럼 꾸준히 한다면 곧 목표를 이룰 수 있을 거예요!"
        }
    }
    
    // 저번 주차 텍스트 색상
    var cloverLastWeekDateColor: Color {
        switch self {
        case .noClover:
            return Color.myE5E5E5
        case .greenClover:
            return Color.myD7FFD3
        case .goldClover:
            return Color.myFFF6D3
        }
    }
    
    // 완수율View 백그라운드 색상
    var completionRateBackgroundColor: Color {
        switch self {
        case .noClover:
            return Color.myE0E0E0
        case .greenClover:
            return Color.myD5E3D5
        case .goldClover:
            return Color.myF2EAD0
        }
    }
    
    // 클로버 카드 배경 이미지
    var cloverCardBackground: String {
        switch self {
        case .noClover:
            return "NoCloverBackground" // ⚠️ 디자인 생기면 수정
        case .greenClover:
            return "GreenCloverBackground"
        case .goldClover:
            return "GoldCloverBackground"
        }
    }
    
    // 회전 클로버 아이콘 이미지
    var cloverCardClover: String? {
        switch self {
        case .noClover:
            return ""
        case .greenClover:
            return "GreenClover"
        case .goldClover:
            return "GoldClover"
        }
    }
    
    // 클로버 모아보기 버튼 색상
    var buttonColor: Color {
        switch self {
        case .noClover:
            return Color.my4F4F4F
        case .greenClover:
            return Color.my538F53
        case .goldClover:
            return Color.myFBAC08
        }
    }
    
    // 배경 그라데이션 컬러
    var gradient: LinearGradient {
        switch self {
        case .noClover:
            return LinearGradient(
                gradient: Gradient(colors: [.my606060, .myB6B6B6]),
                startPoint: .top,
                endPoint: .bottom
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
