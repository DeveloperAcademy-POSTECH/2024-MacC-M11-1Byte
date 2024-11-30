//
//  OnboardingFinishView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingFinishView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @AppStorage("FirstOnboarding") private var FirstOnboarding: Bool?
    
    var nowOnboard: Onboarding = .finish
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(progressValue: 5/5) {
                navigationManager.pop()
            }
            
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingTitle)
                    .customMainStyle()
                Text(nowOnboard.onboardingSubTitle)
                    .customSubStyle()
            }
            .padding(.top, 31)
            
            Spacer()
            Image("OnboardingTurtle3")
                .resizable()
                .scaledToFit()
            
            Spacer()
            // 하단 Button
            HStack {
                GoButton {
                    FirstOnboarding = false  // 온보딩 종료
                } label: {
                    Text("하고만다 시작하기")
                }
            }
            .padding(.vertical)
        }
        .padding(.horizontal, 16)
        .background(.myFFFAF4)
    }
}

#Preview {
    OnboardingFinishView()
        .environment(NavigationManager())
}
