//
//  OnboardingExplainPageView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingExplainPageView: View {
    
    @State private var opacity = 0.0
    var nowOnboard: OnboardingExplain
    var selectedOnboarding: OnboardingExplain
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 온보딩 설명 텍스트
            VStack(spacing: 12) {
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
            .padding(.top, 40)
            
            Spacer()
            // 하단 온보딩 설명 이미지
            HStack {
                nowOnboard.explainImage
                    .resizable()
                    .scaledToFit()
            }
            .padding(.horizontal)
            Spacer()
        }
        .background(.myFFFAF4)
        .onAppear {
            if selectedOnboarding == nowOnboard {
                withAnimation(.easeInOut(duration: 0.5)) {
                    opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    OnboardingExplainPageView(nowOnboard: .fourth, selectedOnboarding: .fourth)
}
