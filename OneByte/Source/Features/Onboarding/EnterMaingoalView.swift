//
//  EnterMainGoal.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct EnterMaingoalView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var nowOnboard: Onboarding = .maingoal
    
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
                OnboardingProgressBar(value: 2/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
            Text(nowOnboard.onboardingTitle)
                .font(.system(size: 26, weight: .bold))
                .multilineTextAlignment(.center)
            
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
                NextButton {
                    //                navigationManager.push(to: .onboardMainGoal)
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
    EnterMaingoalView(nowOnboard: .maingoal)
        .environment(NavigationManager())
}
