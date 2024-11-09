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
            HStack {
                nowOnboard.explainImage
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 353)
            }
            .padding()
            
            VStack(spacing: 20) {
                Text(nowOnboard.explainTitle)
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(nowOnboard.explainSubTitle)
                    .font(.system(size: 16))
                    .lineSpacing(4)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    OnboardingExplainPageView(nowOnboard: .first, nowOnboardingExplain: .first)
}
