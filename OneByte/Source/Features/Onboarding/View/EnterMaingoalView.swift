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
    
    @State private var mainGoal: String = "" // MainGoal
    private let mainGoalLimit = 15 // 글자 수 제한 -> 나중에 디자인팀이라 의논해서 수정해야함
    
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
                OnboardingProgressBar(value: 2/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
            Text(nowOnboard.onboardingTitle)
                .font(.Pretendard.Bold.size26)
                .multilineTextAlignment(.center)
            
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
            
            // MainGoal 입력 창
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "EEEEEE"))
                    .frame(width: 210, height: 210) // 가로 세로 크기 고정
                
                TextField("2025 최종 목표", text: $mainGoal)
                    .font(.system(size: 20, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.clear)
                    .onChange(of: mainGoal) { newValue in
                        if newValue.count > mainGoalLimit {
                            mainGoal = String(newValue.prefix(mainGoalLimit))
                        }
                    }
            }
            .padding()
            
            Spacer()
            
            // 하단 Button
            HStack {
                NextButton(isEnabled: !mainGoal.isEmpty) { // mainGoal이 비어있지 않을 때만 활성화
                    navigationManager.push(to: .onboardSubgoal)
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
    }
}

#Preview {
    EnterMaingoalView(nowOnboard: .maingoal)
        .environment(NavigationManager())
}
