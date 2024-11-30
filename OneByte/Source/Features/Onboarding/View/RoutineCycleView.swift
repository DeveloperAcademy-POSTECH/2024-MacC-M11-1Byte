//
//  EnterDetailgoalView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

struct RoutineCycleView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.modelContext) private var modelContext
    @Query private var subGoals: [SubGoal]
    
    @State var viewModel = OnboardingViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    @StateObject private var wwhViewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    
    @State private var targetSubGoal: SubGoal? // id가 1인 SubGoal 저장변수
    var nowOnboard: Onboarding = .detailgoalCycle
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(progressValue: 2/5) {
                navigationManager.pop()
            }
            
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3.6)
                    .kerning(0.4)
                Text(nowOnboard.onboardingSubTitle)
                    .font(.Pretendard.Regular.size16)
                    .foregroundStyle(.my5A5A5A)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2.4)
                    .kerning(0.4)
            }
            .padding(.top, 31)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.my6FB56F)
                .frame(maxWidth: .infinity)
                .frame(height: 178)
                .overlay (
                    VStack(spacing: 0) {
                        Text("목표")
                            .font(.Pretendard.Medium.size16)
                            .foregroundStyle(Color.myBFEBBB)
                            .padding(.top, 14)
                        
                        if let title = targetSubGoal?.title {
                            Text(title)
                                .font(.Pretendard.Medium.size20)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding(.top, 4)
                        }
                        
                        ZStack {
                            TextField("목표를 위한 루틴을 추가해보세요", text: $viewModel.userDetailGoal)
                                .font(.Pretendard.Medium.size16)
                                .multilineTextAlignment(.leading)
                                .submitLabel(.done)
                                .frame(height: 46)
                                .padding(.horizontal)
                                .background(.white)
                                .cornerRadius(12)
                                .onChange(of: viewModel.userDetailGoal) { oldValue, newValue in
                                    wwhViewModel.text = newValue // MandalartViewModel에 전달
                                    
                                    if newValue.count > viewModel.detailGoalLimit {
                                        viewModel.userDetailGoal = String(newValue.prefix(viewModel.detailGoalLimit))
                                    }
                                }
                            HStack {
                                Spacer()
                                Button {
                                    viewModel.clearUserDetailGoal()
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .frame(width: 23, height: 23)
                                        .foregroundStyle(Color.myB9B9B9)
                                }
                                .opacity(viewModel.userDetailGoal.isEmpty ? 0 : 1)
                                .padding(.trailing)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 20)
                        
                        HStack(spacing: 4) {
                            Image(wwhViewModel.wwh[0] ? "Onboarding_Routine_Check" : "Onboarding_Routine_NoCheck")
                                .resizable()
                                .frame(width: 16, height: 16)
                            Text("어디서")
                                .font(.Pretendard.SemiBold.size14)
                                .kerning(0.2)
                                .foregroundStyle(wwhViewModel.wwh[0] ? .my385E38 : .white.opacity(0.6))
                            Image(wwhViewModel.wwh[1] ? "Onboarding_Routine_Check" : "Onboarding_Routine_NoCheck")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .padding(.leading, 8)
                            Text("무엇을")
                                .font(.Pretendard.SemiBold.size14)
                                .kerning(0.2)
                                .foregroundStyle(wwhViewModel.wwh[1] ? .my385E38 : .white.opacity(0.6))
                            Image(wwhViewModel.wwh[2] ? "Onboarding_Routine_Check" : "Onboarding_Routine_NoCheck")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .padding(.leading, 8)
                            Text("얼마나")
                                .font(.Pretendard.SemiBold.size14)
                                .kerning(0.2)
                                .foregroundStyle(wwhViewModel.wwh[2] ? .my385E38 : .white.opacity(0.6))
                            
                            Spacer()
                            
                            HStack(spacing: 0) {
                                Spacer()
                                Text("\(viewModel.userDetailGoal.count)")
                                    .foregroundStyle(.myE8E8E8)
                                    .font(.Pretendard.Medium.size14)
                                Text("/\(viewModel.detailGoalLimit)")
                                    .foregroundStyle(.white.opacity(0.5))
                                    .font(.Pretendard.Medium.size14)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 14)
                        .padding(.bottom, 14)
                    }
                )
                .padding(.top, 81)
            
            Spacer()
            
            // 하단 Button
            HStack {
                NextButton(isEnabled: !viewModel.userDetailGoal.isEmpty) {
                    if let targetSubGoal = targetSubGoal, // id = 1에 해당하는 SubGoal의
                       let detailGoalToUpdate = targetSubGoal.detailGoals.first(where: { $0.id == 1 }) { // id = 1 DetailGoal 공간에 Update
                        viewModel.updateDetailGoal(
                            detailGoal: detailGoalToUpdate,
                            newTitle: viewModel.userDetailGoal,
                            newMemo: "",
                            achieveCount: 0,
                            achieveGoal: 0,
                            alertMon: false,
                            alertTue: false,
                            alertWed: false,
                            alertThu: false,
                            alertFri: false,
                            alertSat: false,
                            alertSun: false,
                            isRemind: false,
                            remindTime: nil,
                            achieveMon: false,
                            achieveTue: false,
                            achieveWed: false,
                            achieveThu: false,
                            achieveFri: false,
                            achieveSat: false,
                            achieveSun: false,
                            isMorning: true,
                            isAfternoon: false,
                            isEvening: false,
                            isNight: false,
                            isFree: false
                        )
                        navigationManager.push(to: .onboardDays)
                    } else {
                        print("❌ Error: DetailGoal ID 1 not found.")
                    }
                } label: {
                    Text("다음")
                }
            }
            .padding(.vertical)
        }
        .padding(.horizontal, 16)
        .ignoresSafeArea(.keyboard, edges: .bottom) // 키보드 올라올때, 뷰 자동 스크롤 제어
        .background(.myFFFAF4)
        .contentShape(Rectangle())
        .onAppear {
            // EnterSubgoalView에서 사용자가 입력한 Subgoal중 id 1번 값을 찾아 담음
            targetSubGoal = subGoals.first(where: { $0.id == 1 })
        }
        .onTapGesture {
            UIApplication.shared.endEditing() // 빈 화면 터치 시 키보드 숨기기
        }
    }
}

#Preview {
    RoutineCycleView(nowOnboard: .detailgoalCycle)
        .environment(NavigationManager())
}
