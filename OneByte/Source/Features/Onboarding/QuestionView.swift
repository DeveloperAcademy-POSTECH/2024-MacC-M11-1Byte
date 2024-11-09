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
                    navigationManager.pop()
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
            Spacer()
            
            HStack {
                Image(systemName: "timelapse")
                    .resizable()
                    .frame(width: 350, height: 350)
            }
            .padding()
            
            Spacer()
            
            // 하단 Button
            HStack {
                PassButton {
                    //
                } label: {
                    Text("아니요, 잘 몰라요.")
                }
                
                NextButton {
                    //                       navigationManager.push(to: .onboardQuestion)
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
