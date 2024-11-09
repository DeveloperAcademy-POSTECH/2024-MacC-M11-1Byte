//
//  EnterSubgoalView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct EnterSubgoalView: View {
    @Environment(NavigationManager.self) var navigationManager
    
    var nowOnboard: Onboarding = .subgoal
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    navigationManager.pop()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.black)
                            .bold()
                    }
                }
                OnboardingProgressBar(value: 3/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingSubTitle)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color(hex: "919191"))
                
                Text(nowOnboard.onboardingTitle)
                    .font(.system(size: 26, weight: .bold))
                    .multilineTextAlignment(.center)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                HStack {
                    Text("TIP")
                    Text(nowOnboard.onboardingTipMessage)
                        .font(.system(size: 14))
                        .lineSpacing(4)
                }
            }
            .padding()
            
            Spacer()
            
            HStack {
                Image(systemName: "timelapse")
                    .resizable()
                    .frame(width: 350, height: 350)
            }
            .padding()
            
            Spacer()
            
            HStack {
                PassButton {
                    // 온보딩 종료
                } label: {
                    Text("건너 뛰기")
                        .font(.system(size: 18))
                }
                
                NextButton {
                                    navigationManager.push(to: .onboardDetailgoal)
                } label: {
                    Text("다음")
                        .font(.system(size: 18))
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    EnterSubgoalView(nowOnboard: .subgoal)
        .environment(NavigationManager())
}
