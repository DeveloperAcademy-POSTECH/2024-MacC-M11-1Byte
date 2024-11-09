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
            Spacer()
            
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingTitle)
                    .font(.system(size: 26, weight: .bold))
                
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
            
            Button {
                //                       navigationManager.push(to: .onboardQuestion)
            } label: {
                Text("목표 세우러 가기")
            }
            .padding(.horizontal)
        }
    }
}


#Preview {
    QuestionView()
        .environment(NavigationManager())
}
