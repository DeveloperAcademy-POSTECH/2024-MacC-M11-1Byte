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
            
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingTitle)
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text(nowOnboard.onboardingSubTitle)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding()
            
            Spacer()
            
            HStack {
                Image(systemName: "timelapse")
                    .resizable()
                    .frame(width: 300, height: 300)
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
