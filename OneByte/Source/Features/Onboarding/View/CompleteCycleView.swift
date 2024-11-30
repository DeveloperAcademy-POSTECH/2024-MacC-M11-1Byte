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
            OnboardingHeaderView(progressValue: 4/5) {
                navigationManager.pop()
            }
            
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
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.myD6F3D4)
                    .frame(maxWidth: .infinity)
                    .frame(height: 86)
                    .overlay (
                        VStack(spacing: 6) {
                            Text(targetSubGoal?.title ?? "No SubGoal")
                                .foregroundStyle(.my538F53)
                                .kerning(0.43)
                                .font(.Pretendard.Medium.size16)
                            Text(targetDetailGoal?.title ?? "No DetailGoal")
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
                        ForEach(selectedDays(), id: \.day) { dayInfo in
                            DaysCycleCell(day: dayInfo.day, isSelected: .constant(dayInfo.isSelected))
                        }
                    }
                    .padding(.top, 12)
                    
                    Text("시간대")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.myB4A99D)
                        .kerning(0.43)
                        .padding(.top, 28)
                    
                    Text(getSelectedTime())
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
            
            // 하단 Button
            HStack {
                GoButton {
                    navigationManager.push(to: .onboardFinish)
                } label: {
                    Text("다음")
                }
            }
            .padding(.vertical)
        }
        .padding(.horizontal, 16)
        .background(.myFFFAF4)
        .onAppear {
            targetSubGoal = subGoals.first(where: { $0.id == 1 })
            targetDetailGoal = targetSubGoal?.detailGoals.first(where: { $0.id == 1 })
        }
    }
    
    // 선택된 요일만 반환
    private func selectedDays() -> [(day: String, isSelected: Bool)] {
        guard let detailGoal = targetDetailGoal else { return [] }
        
        var days: [(day: String, isSelected: Bool)] = []
        
        if detailGoal.alertSun { days.append((day: "일", isSelected: true)) }
        if detailGoal.alertMon { days.append((day: "월", isSelected: true)) }
        if detailGoal.alertTue { days.append((day: "화", isSelected: true)) }
        if detailGoal.alertWed { days.append((day: "수", isSelected: true)) }
        if detailGoal.alertThu { days.append((day: "목", isSelected: true)) }
        if detailGoal.alertFri { days.append((day: "금", isSelected: true)) }
        if detailGoal.alertSat { days.append((day: "토", isSelected: true)) }
        
        return days
    }
    
    // 사용자가 선택한 시간대 반환
    private func getSelectedTime() -> String {
        guard let detailGoal = targetDetailGoal else { return "시간대 없음" }
        
        if detailGoal.isMorning { return "아침" }
        if detailGoal.isAfternoon { return "점심" }
        if detailGoal.isEvening { return "저녁" }
        if detailGoal.isNight { return "자기 전" }
        if detailGoal.isFree { return "자율" }
        
        return "시간대 없음"
    }
}

struct DaysCycleCell: View {
    
    let day: String
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack {
            Text(day)
                .font(.Pretendard.Medium.size14)
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(.my6FB56F)
                .clipShape(Circle())
        }
    }
}

#Preview {
    CompleteCycleView()
        .environment(NavigationManager())
}
