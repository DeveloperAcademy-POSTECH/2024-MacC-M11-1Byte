//
//  DaysCycleView.swift
//  OneByte
//
//  Created by 이상도 on 11/22/24.
//

import SwiftUI
import SwiftData

struct CompleteCycleView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.modelContext) private var modelContext
    
    @State var viewModel = OnboardingViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    @Query private var subGoals: [SubGoal] // 전체 SubGoals
    @State private var targetSubGoal: SubGoal? // SubGoal id 1번
    @State private var targetDetailGoal: DetailGoal? // SubGoal id 1번의 DetailGoal id 1번
    
    @State private var achieveGoal = 0
    @State private var alertMon: Bool = false
    @State private var alertTue: Bool = false
    @State private var alertWed: Bool = false
    @State private var alertThu: Bool = false
    @State private var alertFri: Bool = false
    @State private var alertSat: Bool = false
    @State private var alertSun: Bool = false
    
    var nowOnboard: Onboarding = .completeCycle
    
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
                OnboardingProgressBar(value: 4/5)
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
            
            VStack(spacing: 12) {
                VStack(spacing: 4) {
                    Text("목표")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.my538F53)
                    Text(targetSubGoal?.title ?? "")
                        .font(.Pretendard.Medium.size20)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 86)
                .background(.my95D895)
                .cornerRadius(12)
                
                VStack(spacing: 8) {
                    Text("루틴")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.myB4A99D)
                        .padding(.top)
                    Text(targetDetailGoal?.title ?? "")
                        .font(.Pretendard.Medium.size20)
                    
                    Text("요일")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.myB4A99D)
                        .padding(.top)
                    
                    HStack(spacing: 8) {
                        DaysCycleCell(
                            day: "일",
                            isSelected: Binding(
                                get: { targetDetailGoal?.alertSun ?? false },
                                set: { targetDetailGoal?.alertSun = $0 }
                            )
                        )
                        DaysCycleCell(
                            day: "월",
                            isSelected: Binding(
                                get: { targetDetailGoal?.alertMon ?? false },
                                set: { targetDetailGoal?.alertMon = $0 }
                            )
                        )
                        
                        DaysCycleCell(
                            day: "화",
                            isSelected: Binding(
                                get: { targetDetailGoal?.alertTue ?? false },
                                set: { targetDetailGoal?.alertTue = $0 }
                            )
                        )
                        DaysCycleCell(
                            day: "수",
                            isSelected: Binding(
                                get: { targetDetailGoal?.alertWed ?? false },
                                set: { targetDetailGoal?.alertWed = $0 }
                            )
                        )
                        DaysCycleCell(
                            day: "목",
                            isSelected: Binding(
                                get: { targetDetailGoal?.alertThu ?? false },
                                set: { targetDetailGoal?.alertThu = $0 }
                            )
                        )
                        DaysCycleCell(
                            day: "금",
                            isSelected: Binding(
                                get: { targetDetailGoal?.alertFri ?? false },
                                set: { targetDetailGoal?.alertFri = $0 }
                            )
                        )
                        DaysCycleCell(
                            day: "토",
                            isSelected: Binding(
                                get: { targetDetailGoal?.alertSat ?? false },
                                set: { targetDetailGoal?.alertSat = $0 }
                            )
                        )
                    }
                    .padding(.bottom, 26)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 179)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.myF0E8DF, lineWidth: 1)
                )
                .cornerRadius(12)
            }
            .padding(.top, 81)
            .padding(.horizontal)
            
            Spacer()
            
            // 하단 Button
            HStack {
                GoButton {
                    navigationManager.push(to: .onboardFinish)
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
        .background(.myFFFAF4)
        .onAppear {
            targetSubGoal = subGoals.first(where: { $0.id == 1 })
            if let subGoal = targetSubGoal {
                targetDetailGoal = subGoal.detailGoals.first(where: { $0.id == 1 })
            }
        }
    }
}

struct DaysCycleCell: View {
    
    let day: String
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack {
            Text(day)
                .font(.Pretendard.Medium.size14)
                .foregroundStyle(isSelected ? .white : Color.my95D895)
                .frame(width: 28, height: 28)
                .background(isSelected ? Color.my95D895 : .white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? .white : Color.my95D895, lineWidth: 1)
                )
        }
    }
}

#Preview {
    CompleteCycleView()
        .environment(NavigationManager())
}
