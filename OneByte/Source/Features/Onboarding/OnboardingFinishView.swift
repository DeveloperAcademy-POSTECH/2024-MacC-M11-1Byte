//
//  OnboardingFinishView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingFinishView: View {
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.dismiss) private var dismiss // Onboarding dismiss
    @AppStorage("isFirstOnboarding") private var isFirstOnboarding: Bool? // 온보딩 첫 동작시에만
    
    var nowOnboard: Onboarding = .finish
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Image(systemName: "timelapse")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text(nowOnboard.onboardingTitle)
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(nowOnboard.onboardingSubTitle)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color(hex: "919191"))
            }
            .padding()
            
            Spacer()
            
            HStack {
                Image(systemName: "timelapse")
                    .resizable()
                    .frame(width: 300, height: 300)
            }
            .padding()
            
            Spacer()
            
            HStack {
                NextButton {
                    // 온보딩끝내고 메인화면으로
                    isFirstOnboarding = false
                    dismiss()
                } label: {
                    Text("이어서 작성하기")
                        .font(.system(size: 18))
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
