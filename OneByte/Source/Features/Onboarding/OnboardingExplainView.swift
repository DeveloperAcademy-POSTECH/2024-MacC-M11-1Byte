//
//  OnboardingInfoView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingExplainView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    @State private var nowOnboardingExplain: OnboardingExplain = .first
    
    var body: some View {
        VStack {
            // 만다라트 설명 4페이지뷰를, 한 뷰에서 탭뷰로 표시
            TabView(selection: $nowOnboardingExplain) {
                ForEach(OnboardingExplain.allCases, id: \.self) { onboarding in
                    OnboardingExplainPageView(
                        nowOnboard: onboarding,
                        nowOnboardingExplain: nowOnboardingExplain
                    )
                    .tag(onboarding)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Indicator
            VStack {
                HStack(spacing: 8) {
                    ForEach(OnboardingExplain.allCases, id: \.self) { onboarding in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(nowOnboardingExplain == onboarding ? Color(hex: "636363") : Color(hex: "919191"))
                    }
                }
            }
            
            NextButton {
                navigationManager.push(to: .onboardMaingoal)
            } label: {
                Text("목표 작성하러 가기")
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationManager.pop()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.black)
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingExplainView()
        .environment(NavigationManager())
}
