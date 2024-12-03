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
    @Query private var subGoals: [SubGoal]
    @Query private var detailGoals: [DetailGoal]
    @State var viewModel = RoutineCycleViewModel(updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    var nowOnboard: Onboarding = .daysCycle
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(progressValue: 3/5) {
                navigationManager.pop()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    Text(nowOnboard.onboardingTitle)
                        .customMainStyle()
                    nowOnboard.onboardingSubTitle
                        .customSubStyle()
                }
                .padding(.top, 31)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.myD6F3D4)
                    .frame(maxWidth: .infinity)
                    .frame(height: 86)
                    .overlay (
                        VStack(spacing: 6) {
                            Text(viewModel.targetSubGoal?.title ?? "No SubGoal")
                                .font(.Pretendard.Bold.size16)
                                .foregroundStyle(.my538F53)
                            Text(viewModel.targetDetailGoal?.title ?? "No DetailGoal")
                                .font(.Pretendard.SemiBold.size20)
                        }
                    )
                    .padding(.top, 32)
                
                selectDayView() // 요일 선택 뷰
                
                selectTimesView() // 시간대 선택 뷰
            }
            NextButton(isEnabled: viewModel.achieveGoal > 0 ) {
                viewModel.performUpdateDetailGoal()
                navigationManager.push(to: .onboardComplete)
            } label: {
                Text("다음")
            }
            .padding(.vertical)
        }
        .padding(.horizontal, 16)
        .background(.myFFFAF4)
        .onAppear {
            // 사용자가 입력한 Subgoal id 1의 값을 targetSubGoal에 저장
            viewModel.targetSubGoal = subGoals.first(where: { $0.id == 1 })
            // targetSubGoal의 DetailGoal 중 id 1의 값을 targetDetailGoal에 저장
            viewModel.targetDetailGoal = viewModel.targetSubGoal?.detailGoals.first(where: { $0.id == 1 })
        }
    }
    
    @ViewBuilder
    private func selectDayView() -> some View {
        VStack(spacing: 2) {
            HStack {
                Text("요일 선택")
                    .font(.Pretendard.SemiBold.size17)
                    .foregroundStyle(.my675542)
                    .kerning(0.2)
                Spacer()
            }
            HStack {
                Text("루틴을 실행할 요일을 선택해주세요 " )
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(.myB4A99D)
                    .kerning(0.2)
                Spacer()
            }
        }
        .padding(.leading, 4)
        .padding(.top, 20)
        
        VStack(spacing: 0) {
            HStack {
                Text("반복 요일")
                    .font(.Pretendard.SemiBold.size16)
                    .kerning(0.2)
                    .padding([.leading, .top], 16)
                Spacer()
            }
            
            HStack(spacing: 10) {
                DaysCycleCellButton(day: "월", isSelected: $viewModel.alertMon, onChange: viewModel.updateAchieveGoal)
                DaysCycleCellButton(day: "화", isSelected: $viewModel.alertTue, onChange: viewModel.updateAchieveGoal)
                DaysCycleCellButton(day: "수", isSelected: $viewModel.alertWed, onChange: viewModel.updateAchieveGoal)
                DaysCycleCellButton(day: "목", isSelected: $viewModel.alertThu, onChange: viewModel.updateAchieveGoal)
                DaysCycleCellButton(day: "금", isSelected: $viewModel.alertFri, onChange: viewModel.updateAchieveGoal)
                DaysCycleCellButton(day: "토", isSelected: $viewModel.alertSat, onChange: viewModel.updateAchieveGoal)
                DaysCycleCellButton(day: "일", isSelected: $viewModel.alertSun, onChange: viewModel.updateAchieveGoal)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 15)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myB4A99D, lineWidth: 1)
        )
        .cornerRadius(12)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func selectTimesView() -> some View {
        VStack(spacing: 2) {
            HStack {
                Text("시간대 선택")
                    .font(.Pretendard.SemiBold.size17)
                    .foregroundStyle(.my675542)
                    .kerning(0.2)
                Spacer()
            }
            HStack {
                Text("루틴을 실행할 대략적인 시간대를 선택해주세요. " )
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(.myB4A99D)
                    .kerning(0.2)
                Spacer()
            }
        }
        .padding(.leading, 4)
        .padding(.top, 28)
        
        VStack(spacing: 0) {
            HStack {
                Text("루틴 시간대")
                    .font(.Pretendard.SemiBold.size16)
                    .kerning(0.2)
                Spacer()
                Picker("Choose a times", selection: $viewModel.selectedTime) {
                    ForEach(viewModel.routineTimes, id: \.self) {
                        Text($0)
                            .font(.Pretendard.Regular.size17)
                    }
                }
                .pickerStyle(.menu)
                .tint(.my89898D)
            }
            .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myB4A99D, lineWidth: 1)
        )
        .cornerRadius(12)
        .padding(.top, 10)
        .padding(.bottom, 32)
    }
}

#Preview {
    DaysCycleView()
        .environment(NavigationManager())
}
