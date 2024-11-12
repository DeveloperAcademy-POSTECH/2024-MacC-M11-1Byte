//
//  QuestionView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//
import SwiftUI

struct QuestionView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var nowOnboard: Onboarding = .question
    
    var body: some View {
        VStack {
            // Back Button & 프로그레스 바
            HStack {
                Button{
                    navigationManager.popToRoot()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.black)
                            .bold()
                    }
                }
                OnboardingProgressBar(value: 1/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding()
            
            // 상단 텍스트
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
                
                Text(nowOnboard.onboardingSubTitle)
                    .font(.Pretendard.Regular.size18)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding()
            
            Spacer()
            
            // 중앙 캐릭터 이미지
            HStack {
                Image("Turtle_2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 224)
                    .padding(.leading, 70)
            }
            .padding()
            
            Spacer()
            
            // 하단 Button
            HStack {
                PassButton {
                    navigationManager.push(to: .onboardInfo)
                } label: {
                    Text("아니요, 잘 몰라요.")
                }
                
                GoButton {
                    navigationManager.push(to: .onboardMaingoal)
                } label: {
                    Text("네, 알고있어요.")
                }
            }
            .padding()
        }
    }
}

#Preview {
    QuestionView()
        .environment(NavigationManager())
}
