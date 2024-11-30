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
    @Environment(\.modelContext) private var modelContext
    
    @State var viewModel = OnboardingViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    @Query private var subGoals: [SubGoal]
    @Query private var detailGoals: [DetailGoal]
    
    @State private var targetSubGoal: SubGoal? // id가 1인 SubGoal 저장변수
    @State private var targetDetailGoal: DetailGoal? // id가 1인 SubGoal 저장변수
    
    @State private var achieveGoal = 0
    @State private var alertMon: Bool = false
    @State private var alertTue: Bool = false
    @State private var alertWed: Bool = false
    @State private var alertThu: Bool = false
    @State private var alertFri: Bool = false
    @State private var alertSat: Bool = false
    @State private var alertSun: Bool = false
    
    @State var selectedTime = "color"
    var routineTimes = ["아침","점심","저녁","자기 전","자율"]
    
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
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.myD6F3D4)
                .frame(maxWidth: .infinity)
                .frame(height: 86)
                .overlay (
                    VStack(spacing: 6) {
                        Text(targetSubGoal?.title ?? "No SubGoal")
                            .foregroundStyle(.my538F53)
                            .font(.Pretendard.Medium.size16)
                        Text(targetDetailGoal?.title ?? "No DetailGoal")
                            .font(.Pretendard.Medium.size20)
                    }
                )
                .padding(.top, 32)
            
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
            .padding(.top, 32)
            
            VStack(spacing: 0) {
                HStack {
                    Text("반복 요일")
                        .font(.Pretendard.SemiBold.size16)
                        .kerning(0.2)
                        .padding([.leading, .top], 16)
                    Spacer()
                }
                
                HStack(spacing: 7) {
                    DaysCycleButton(day: "일", isSelected: $alertSun, onChange: updateAchieveGoal)
                    DaysCycleButton(day: "월", isSelected: $alertMon, onChange: updateAchieveGoal)
                    DaysCycleButton(day: "화", isSelected: $alertTue, onChange: updateAchieveGoal)
                    DaysCycleButton(day: "수", isSelected: $alertWed, onChange: updateAchieveGoal)
                    DaysCycleButton(day: "목", isSelected: $alertThu, onChange: updateAchieveGoal)
                    DaysCycleButton(day: "금", isSelected: $alertFri, onChange: updateAchieveGoal)
                    DaysCycleButton(day: "토", isSelected: $alertSat, onChange: updateAchieveGoal)
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
                    Picker("Choose a times", selection: $selectedTime) {
                            ForEach(routineTimes, id: \.self) {
                              Text($0)
                                .font(.Pretendard.Regular.size17)
                            }
                          }
                    .pickerStyle(.menu)
                    .tint(.my89898D)
                }
                .padding(.vertical)
                .padding(.horizontal,16)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.myB4A99D, lineWidth: 1)
            )
            .cornerRadius(12)
            .padding(.top, 10)
            
            Spacer()
            
            // 하단 Button
            HStack {
                NextButton(isEnabled: achieveGoal > 0 ) {
                    achieveGoal = [alertMon, alertTue, alertWed, alertThu, alertFri, alertSat, alertSun]
                        .filter { $0 }
                        .count
                    
                    guard let targetDetailGoal = targetDetailGoal else {
                        print("⚠️ targetDetailGoal is nil")
                        return
                    }
                    
                    // Picker에서 선택한 시간대에 따라 업데이트
                        let isMorning = selectedTime == "아침"
                        let isAfternoon = selectedTime == "점심"
                        let isEvening = selectedTime == "저녁"
                        let isNight = selectedTime == "자기 전"
                        let isFree = selectedTime == "자율"
                    
                    viewModel.updateDetailGoal(
                        detailGoal: targetDetailGoal,
                        newTitle: targetDetailGoal.title,
                        newMemo: targetDetailGoal.memo,
                        achieveCount: targetDetailGoal.achieveCount,
                        achieveGoal: achieveGoal,
                        alertMon: alertMon,
                        alertTue: alertTue,
                        alertWed: alertWed,
                        alertThu: alertThu,
                        alertFri: alertFri,
                        alertSat: alertSat,
                        alertSun: alertSun,
                        isRemind: targetDetailGoal.isRemind,
                        remindTime: targetDetailGoal.remindTime,
                        achieveMon: targetDetailGoal.achieveMon,
                        achieveTue: targetDetailGoal.achieveTue,
                        achieveWed: targetDetailGoal.achieveWed,
                        achieveThu: targetDetailGoal.achieveThu,
                        achieveFri: targetDetailGoal.achieveFri,
                        achieveSat: targetDetailGoal.achieveSat,
                        achieveSun: targetDetailGoal.achieveSun,
                        isMorning: isMorning,
                        isAfternoon: isAfternoon,
                        isEvening: isEvening,
                        isNight: isNight,
                        isFree: isFree
                    )
                    navigationManager.push(to: .onboardComplete)
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
        .padding(.horizontal, 16)
        .background(.myFFFAF4)
        .onAppear {
            // 사용자가 입력한 Subgoal id 1의 값을 targetSubGoal에 저장
            targetSubGoal = subGoals.first(where: { $0.id == 1 })
            // targetSubGoal의 DetailGoal 중 id 1의 값을 targetDetailGoal에 저장
            targetDetailGoal = targetSubGoal?.detailGoals.first(where: { $0.id == 1 })
        }
    }
    
    private func updateAchieveGoal() {
        achieveGoal = [alertMon, alertTue, alertWed, alertThu, alertFri, alertSat, alertSun]
            .filter { $0 }
            .count
    }
}


struct DaysCycleButton: View {
    
    let day: String
    @Binding var isSelected: Bool
    var onChange: () -> Void
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
            onChange()
        }) {
            Text(day)
                .font(.Pretendard.Medium.size17)
                .foregroundStyle(isSelected ? .white : .white)
                .frame(width: 36, height: 36)
                .background(isSelected ? .my95D895 : .myCFCFCF)
                .clipShape(Circle())
        }
    }
}

#Preview {
    DaysCycleView()
        .environment(NavigationManager())
}
