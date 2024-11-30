//
//  QuestionView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//
import SwiftUI

struct ReadyCycleView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.dismiss) private var dismiss
    
    var nowOnboard: Onboarding = .ready
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 텍스트
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .customMainStyle()
                Text(nowOnboard.onboardingSubTitle)
                    .customSubStyle()
            }
            .padding(.top, 40)
            
            // 중앙 캐릭터 이미지
            HStack {
                Image("OnboardingTurtle2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 353, height: 399)
            }
            .padding(.top, 23)
            Spacer()
            
            GoButton {
                navigationManager.push(to: .onboardSubgoal)
            } label: {
                Text("시작하기")
            }
            .padding()
        }
        .background(.myFFFAF4)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ReadyCycleView()
        .environment(NavigationManager())
}
