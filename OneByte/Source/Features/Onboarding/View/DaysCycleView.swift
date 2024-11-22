//
//  DaysCycleView.swift
//  OneByte
//
//  Created by 이상도 on 11/22/24.
//

import SwiftUI
import SwiftData

struct DaysCycleView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @AppStorage("FirstOnboarding") private var isFirstOnboarding: Bool? // 온보딩 첫 동작시에만
    
    @Environment(\.modelContext) private var modelContext
    @Query private var subGoals: [SubGoal]
    
    @State var viewModel = OnboardingViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    @State private var targetSubGoal: SubGoal? // id가 1인 SubGoal 저장변수
    var nowOnboard: Onboarding = .daysCycle
    
    var body: some View {
        VStack(spacing: 0) {
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
                OnboardingProgressBar(value: 3/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
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
            .padding(.top, 31)
            
            
            
            Spacer()
            // 하단 Button
            HStack {
                GoButton {
                    // action
                } label: {
                    Text("다음")
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    DaysCycleView()
        .environment(NavigationManager())
}
