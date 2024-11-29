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
            return ""
        case .greenClover:
            return "초록 클로버"
        case .goldClover:
            return "황금 클로버"
        }
    }
    
    var cloverCardTitle: String {
        switch self {
        case .noClover:
            return "획득한 클로버가 없어요.."
        case .greenClover:
            return "초록 클로버를 획득했어요!"
        case .goldClover:
            return "황금 클로버를 획득했어요!"
        }
    }
    
    var cloverCardMessage: String {
        switch self {
        case .noClover:
            return "새로운 한주는 좀 더 노력해 클로버를 획득해보세요"
        case .greenClover:
            return "다음엔 황금클로버에도 도전해보세요."
        case .goldClover:
            return "잘하고 있어요! 앞으로도 지금처럼만 노력해봐요"
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
