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
            Spacer()
            // 상단 텍스트
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3.6)
                Text(nowOnboard.onboardingSubTitle)
                    .font(.Pretendard.Regular.size16)
                    .foregroundStyle(Color.my919191)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2.4)
            }
            .padding()
            
            Spacer()
            
            // 중앙 캐릭터 이미지
            HStack {
                Image("OnboardingTurtle2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
            .padding()
            
            Spacer()
            
            // 하단 Button
            HStack {
                GoButton {
                    navigationManager.push(to: .onboardSubgoal)
                } label: {
                    Text("시작하기")
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ReadyCycleView()
        .environment(NavigationManager())
}
