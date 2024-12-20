//
//  DaysCycleView.swift
//  OneByte
//
//  Created by 이상도 on 11/22/24.
//

import SwiftUI
import SwiftData

struct CompleteCycleView: View {
    
    @Environment(NavigationRouter.self) var navigationRouter
    @Environment(\.modelContext) private var modelContext
    @Query private var subGoals: [SubGoal]
    @State var viewModel = RoutineCycleViewModel(updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    var nowOnboard: Onboarding = .completeCycle
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(progressValue: 4/5) {
                navigationRouter.pop()
            }
            
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .customMainStyle()
                nowOnboard.onboardingSubTitle
                    .customSubStyle()
            }
            .padding(.top, 31)
            
            VStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.myD6F3D4)
                    .frame(maxWidth: .infinity)
                    .frame(height: 86)
                    .overlay (
                        VStack(spacing: 6) {
                            Text(viewModel.targetSubGoal?.title ?? "No SubGoal")
                                .font(.Pretendard.Medium.size16)
                                .foregroundStyle(.my538F53)
                                .kerning(0.43)
                            Text(viewModel.targetDetailGoal?.title ?? "No DetailGoal")
                                .font(.Pretendard.Medium.size20)
                                .kerning(0.43)
                        }
                    )
                    .padding(.top, 32)
                
                VStack(spacing: 8) {
                    Text("요일")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.myB4A99D)
                        .padding(.top, 24)
                        .kerning(0.43)
                    
                    HStack(spacing: 11) {
                        ForEach(viewModel.getSelectedDays(), id: \.day) { dayInfo in
                            DaysCycleCell(day: dayInfo.day, isSelected: .constant(dayInfo.isSelected))
                        }
                    }
                    .padding(.top, 12)
                    
                    Text("시간대")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.myB4A99D)
                        .kerning(0.43)
                        .padding(.top, 28)
                    
                    Text(viewModel.getSelectedTime())
                        .font(.Pretendard.Medium.size20)
                        .kerning(0.43)
                        .padding(.bottom, 30)
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 209)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.myF0E8DF, lineWidth: 1)
                )
                .cornerRadius(12)
            }
            Spacer()
            
            GoButton {
                navigationRouter.push(to: .onboardFinish)
            } label: {
                Text("다음")
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
        .background(.myFFFAF4)
        .onAppear {
            viewModel.targetSubGoal = subGoals.first(where: { $0.id == 1 })
            viewModel.targetDetailGoal = viewModel.targetSubGoal?.detailGoals.first(where: { $0.id == 1 })
        }
    }
}

#Preview {
    CompleteCycleView()
        .environment(NavigationRouter())
}
