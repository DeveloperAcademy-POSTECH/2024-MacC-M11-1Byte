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
    @Query private var subGoals: [SubGoal]
    @State var viewModel = RoutineCycleViewModel(updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    @StateObject private var wwhVM = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    var nowOnboard: Onboarding = .detailgoalCycle
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(progressValue: 2/5) {
                navigationManager.pop()
            }
            
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .customMainStyle()
                nowOnboard.onboardingSubTitle
                    .customSubStyle()
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
                        
                        Text(viewModel.targetSubGoal?.title ?? "서브목표")
                            .font(.Pretendard.ExtraBold.size20)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                        
                        ZStack {
                            TextField("목표를 위한 루틴을 추가해보세요", text: $viewModel.userNewDetailGoal)
                                .font(.Pretendard.Medium.size16)
                                .multilineTextAlignment(.leading)
                                .submitLabel(.done)
                                .frame(height: 46)
                                .padding(.horizontal)
                                .background(.white)
                                .cornerRadius(12)
                                .onChange(of: viewModel.userNewDetailGoal) { oldValue, newValue in
                                    wwhVM.detailGoalTitleText = newValue // MandalartViewModel에 전달
                                    
                                    if newValue.count > viewModel.detailGoalLimit {
                                        viewModel.userNewDetailGoal = String(newValue.prefix(viewModel.detailGoalLimit))
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
                                .opacity(viewModel.isVisibleXmark())
                                .padding(.trailing)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.top, 20)
                        
                        wwhCheckView() // wwh View
                    }
                )
                .padding(.top, 81)
            
            Spacer()
            
            NextButton(isEnabled: !viewModel.userNewDetailGoal.isEmpty) {
                if let targetSubGoal = viewModel.targetSubGoal, // id = 1에 해당하는 SubGoal의
                   let detailGoalToUpdate = targetSubGoal.detailGoals.first(where: { $0.id == 1 }) { // id = 1 DetailGoal 공간에 Update
                    viewModel.updateDetailGoal(
                        detailGoal: detailGoalToUpdate,
                        newTitle: viewModel.userNewDetailGoal,
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
                }
            } label: {
                Text("다음")
            }
            .padding(.vertical)
        }
        .padding(.horizontal)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .background(.myFFFAF4)
        .contentShape(Rectangle())
        .onAppear {
            // EnterSubgoalView에서 사용자가 입력한 Subgoal중 id 1번 값을 찾아 담음
            viewModel.targetSubGoal = subGoals.first(where: { $0.id == 1 })
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    @ViewBuilder
    private func wwhCheckView() -> some View {
        HStack(spacing: 4) {
            Image(wwhVM.wwh[0] ? "Onboarding_Routine_Check" : "Onboarding_Routine_NoCheck")
                .resizable()
                .frame(width: 16, height: 16)
            Text("어디서")
                .font(.Pretendard.SemiBold.size14)
                .foregroundStyle(wwhVM.wwh[0] ? .my385E38 : .white.opacity(0.6))
                .kerning(0.2)
            Image(wwhVM.wwh[1] ? "Onboarding_Routine_Check" : "Onboarding_Routine_NoCheck")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.leading, 8)
            Text("무엇을")
                .font(.Pretendard.SemiBold.size14)
                .foregroundStyle(wwhVM.wwh[1] ? .my385E38 : .white.opacity(0.6))
                .kerning(0.2)
            Image(wwhVM.wwh[2] ? "Onboarding_Routine_Check" : "Onboarding_Routine_NoCheck")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.leading, 8)
            Text("얼마나")
                .font(.Pretendard.SemiBold.size14)
                .foregroundStyle(wwhVM.wwh[2] ? .my385E38 : .white.opacity(0.6))
                .kerning(0.2)
            
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                Text("\(viewModel.userNewDetailGoal.count)")
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(.myE8E8E8)
                Text("/\(viewModel.detailGoalLimit)")
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

#Preview {
    RoutineCycleView(nowOnboard: .detailgoalCycle)
        .environment(NavigationManager())
}
