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
            // 만다라트 설명 4페이지뷰를, 한 뷰에서 탭뷰로 생성
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
            
            // Indicator ( 현재 Page/전체 Page 나타내는 dots )
            VStack {
                HStack(spacing: 8) {
                    ForEach(OnboardingExplain.allCases, id: \.self) { onboarding in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(nowOnboardingExplain == onboarding ? Color.my636363 : Color.my919191)
                    }
                }
            }
            
            // 하단 Button
            GoButton {
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
