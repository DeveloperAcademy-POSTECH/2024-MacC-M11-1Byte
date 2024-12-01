//
//  OnboardingExplainPageView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingExplainPageView: View {
    
    @State var viewModel = OnboardingStartViewModel(createService: CreateService())
    
    var nowOnboard: OnboardingExplain
    var selectedOnboarding: OnboardingExplain
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 온보딩 설명 텍스트
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .customMainStyle()
                Text(nowOnboard.onboardingSubTitle)
                    .customSubStyle()
            }
            .padding(.top, 40)
            
            Spacer()
            // 하단 온보딩 설명 이미지
            HStack {
                nowOnboard.explainImage
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
        }
        .background(.myFFFAF4)
        .padding(.horizontal)
        .onAppear {
            viewModel.setOpacity(selectedOnboarding: selectedOnboarding)
        }
    }
}

#Preview {
    OnboardingExplainPageView(nowOnboard: .fourth, selectedOnboarding: .fourth)
}
