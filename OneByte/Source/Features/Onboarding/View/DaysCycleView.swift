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
    
    @State var viewModel = OnboardingViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))

    @Query private var detailGoals: [DetailGoal]
    @State private var targetDetailGoal: DetailGoal? // id가 1인 SubGoal 저장변수
    
    @State private var alertMon: Bool = false
    @State private var alertTue: Bool = false
    @State private var alertWed: Bool = false
    @State private var alertThu: Bool = false
    @State private var alertFri: Bool = false
    @State private var alertSat: Bool = false
    @State private var alertSun: Bool = false
    
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
                    .foregroundStyle(Color.my5A5A5A)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2.4)
            }
            .padding(.top, 31)
            
            VStack(spacing: 5) {
                Text("루틴")
                    .font(.Pretendard.Medium.size16)
                    .foregroundStyle(Color.myB4A99D)
                    .padding(.top)
                
                if let title = targetDetailGoal?.title {
                    Text(title)
                        .font(.Pretendard.Medium.size20)
                        .multilineTextAlignment(.center)
                }
                
                HStack(spacing: 7) {
                    DaysCycleButton(day: "일", isSelected: $alertSun)
                    DaysCycleButton(day: "월", isSelected: $alertMon)
                    DaysCycleButton(day: "화", isSelected: $alertTue)
                    DaysCycleButton(day: "수", isSelected: $alertWed)
                    DaysCycleButton(day: "목", isSelected: $alertThu)
                    DaysCycleButton(day: "금", isSelected: $alertFri)
                    DaysCycleButton(day: "토", isSelected: $alertSat)
                }
                .padding()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.myB4A99D, lineWidth: 1)
            )
            .cornerRadius(12)
            .padding(.top, 81)
            
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
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            // EnterSubgoalView에서 사용자가 입력한 Subgoal중 id 1번 값을 찾아 담음
            targetDetailGoal = detailGoals.first(where: { $0.id == 1 })
        }
    }
}

struct DaysCycleButton: View {
    
    let day: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            Text(day)
                .font(.Pretendard.Medium.size17)
                .foregroundStyle(isSelected ? .white : Color.my95D895)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.my95D895 : .white)
                .overlay(
                    Circle()
                        .stroke(isSelected ? .white : Color.my95D895 , lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    DaysCycleView()
        .environment(NavigationManager())
}
