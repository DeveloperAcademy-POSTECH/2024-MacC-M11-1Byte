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
            // Back Button & 프로그레스 바
            HStack {
                Button {
                    navigationManager.pop()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.black)
                            .bold()
                    }
                }
                OnboardingProgressBar(value: 5/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3.6)
                    .kerning(0.4)
                Text(nowOnboard.onboardingSubTitle)
                    .font(.Pretendard.Regular.size16)
                    .foregroundStyle(.my5A5A5A)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2.4)
                    .kerning(0.4)
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
