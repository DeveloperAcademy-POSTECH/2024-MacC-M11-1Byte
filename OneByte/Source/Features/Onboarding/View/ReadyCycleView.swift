//
//  QuestionView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//
import SwiftUI

struct ReadyCycleView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    var nowOnboard: Onboarding = .ready
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 텍스트
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .customMainStyle()
                nowOnboard.onboardingSubTitle
                    .customSubStyle()
            }
            .padding(.top, 40)
            
            // 중앙 캐릭터 이미지
            HStack {
                Image("OnboardingTurtle2")
                    .resizable()
                    .scaledToFit()
            }
            .padding(.top, 23)
            Spacer()
            
            GoButton {
                navigationManager.push(to: .onboardSubgoal)
            } label: {
                Text("시작하기")
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
        .background(.myFFFAF4)
    }
}

#Preview {
    ReadyCycleView()
        .environment(NavigationManager())
}
