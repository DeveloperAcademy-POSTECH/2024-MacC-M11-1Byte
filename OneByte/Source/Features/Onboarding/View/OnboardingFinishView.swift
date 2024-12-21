//
//  OnboardingFinishView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingFinishView: View {
    
    @Environment(NavigationRouter.self) var navigationRouter
    @AppStorage("FirstOnboarding") private var FirstOnboarding: Bool?
    
    var nowOnboard: Onboarding = .finish
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(progressValue: 5/5) {
                navigationRouter.pop()
            }
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingTitle)
                    .customMainStyle()
                nowOnboard.onboardingSubTitle
                    .customSubStyle()
            }
            .padding(.top, 31)
            
            Spacer()
            Image("OnboardingTurtle3")
                .resizable()
                .scaledToFit()
            Spacer()
            
            GoButton {
                FirstOnboarding = false  // 온보딩 종료
            } label: {
                Text("하고만다 시작하기")
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
        .background(.myFFFAF4)
    }
}

#Preview {
    OnboardingFinishView()
        .environment(NavigationRouter())
}
