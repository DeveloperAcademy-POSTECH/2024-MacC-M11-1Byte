//
//  OnboardingExplainPageView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingExplainPageView: View {
    
    var nowOnboard: OnboardingExplain
    var nowOnboardingExplain: OnboardingExplain
    
    var body: some View {
        VStack {
            // 상단 Lottie 들어갈 공간
            HStack {
                nowOnboard.explainImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 225)
            }
            .padding()
            
            // 하단 Text
            VStack(spacing: 20) {
                Text(nowOnboard.explainTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
                
                Text(nowOnboard.explainSubTitle)
                    .font(.Pretendard.Regular.size16)
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    OnboardingExplainPageView(nowOnboard: .first, nowOnboardingExplain: .first)
}
