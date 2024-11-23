//
//  OnboardingExplainPageView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingExplainPageView: View {
    
    var nowOnboard: OnboardingExplain
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 온보딩 설명 텍스트
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3.6)
                Text(nowOnboard.onboardingSubTitle)
                    .font(.Pretendard.Regular.size16)
                    .foregroundStyle(.my5A5A5A)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2.4)
            }
            .padding(.top, 80)
            
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
    }
}

#Preview {
    OnboardingExplainPageView(nowOnboard: .fifth)
}
