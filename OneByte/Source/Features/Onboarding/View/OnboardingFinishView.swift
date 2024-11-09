//
//  OnboardingFinishView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingFinishView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @AppStorage("FirstOnboarding") private var FirstOnboarding: Bool? // 온보딩 첫 동작시에만
    
    var nowOnboard: Onboarding = .finish
    
    var body: some View {
        VStack {
            // 상단 캐릭터 이미지 & 텍스트
            VStack(spacing: 10) {
                Image("Dara4")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 113)
                
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
                
                Text(nowOnboard.onboardingSubTitle)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color(hex: "919191"))
            }
            .padding()
            .padding(.top)
            
            Spacer()
            
            // 9x9 만다라트 View
            HStack {
                Image(systemName: "timelapse")
                    .resizable()
                    .frame(width: 300, height: 300)
            }
            .padding()
            
            Spacer()
            
            // 하단 Button
            HStack {
                GoButton {
                    // 온보딩끝내고 메인화면으로
                    FirstOnboarding = false
                } label: {
                    Text("이어서 작성하기")
                }
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingFinishView()
        .environment(NavigationManager())
}
