//
//  EnterDetailgoalView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct EnterDetailgoalView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.dismiss) private var dismiss // Onboarding dismiss
    @AppStorage("isFirstOnboarding") private var isFirstOnboarding: Bool? // 온보딩 첫 동작시에만
    
    var nowOnboard: Onboarding = .detailgoal
    
    var body: some View {
        VStack {
            // Back Button & 프로그레스 바
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
                OnboardingProgressBar(value: 4/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingSubTitle)
                    .font(.Pretendard.Regular.size17)
                    .foregroundStyle(Color(hex: "919191"))
                    .multilineTextAlignment(.center)
                
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
            }
            
            // 팁 메세지 영역
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "D4F7D7"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 112)
                
                VStack(alignment: .leading) {
                    (Text("TIP ")
                        .font(.Pretendard.Bold.size14) +
                     Text(nowOnboard.onboardingTipMessage))
                    .font(.Pretendard.Regular.size14)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .padding()
                }
            }
            .padding()
            
            Spacer()
            
            // 중앙 3x3 View
            HStack {
                Image(systemName: "timelapse")
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            .padding()
            
            Spacer()
            
            // 하단 Button
            HStack {
                PassButton {
                    isFirstOnboarding = false
                    dismiss()
                } label: {
                    Text("건너 뛰기")
                }
                
                GoButton {
                    navigationManager.push(to: .onboardFinish)
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
    }
}

#Preview {
    EnterDetailgoalView(nowOnboard: .detailgoal)
        .environment(NavigationManager())
}
