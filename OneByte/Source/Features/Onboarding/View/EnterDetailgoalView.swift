//
//  EnterDetailgoalView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

struct EnterDetailgoalView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @AppStorage("FirstOnboarding") private var isFirstOnboarding: Bool? // 온보딩 첫 동작시에만
    
    @Environment(\.modelContext) private var modelContext
    @Query private var subGoals: [SubGoal]
    
    @State var viewModel = OnboardingViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    @State private var userDetailGoal: String = "" // 사용자 SubGoal 입력 텍스트
    @State private var targetSubGoal: SubGoal? // id가 1인 SubGoal 저장변수
    @FocusState private var isFocused: Bool // TextField 포커스 상태 관리
    private let detailGoalLimit = 20 // 글자 수 제한
    
    var nowOnboard: Onboarding = .detailgoalCycle
    
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
                OnboardingProgressBar(value: 2/5)
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
                .fill(Color.my95D895)
                .frame(maxWidth: .infinity)
                .frame(height: 154)
                .overlay (
                    VStack(spacing: 5) {
                        Text("목표")
                            .font(.Pretendard.Medium.size16)
                            .foregroundStyle(Color.my538F53)
                            .padding(.top)
                        
                        if let title = targetSubGoal?.title {
                            Text(title)
                                .font(.Pretendard.Medium.size20)
                                .multilineTextAlignment(.center)
                        }
                        
                        ZStack {
                            TextField("목표를 위한 루틴을 추가해보세요", text: $userDetailGoal)
                                .font(.Pretendard.Medium.size16)
                                .multilineTextAlignment(.leading)
                                .focused($isFocused)
                                .submitLabel(.done)
                                .frame(height: 54)
                                .padding(.horizontal)
                                .background(.white)
                                .cornerRadius(12)
                                .onChange(of: userDetailGoal) { oldValue, newValue in
                                    if newValue.count > detailGoalLimit {
                                        userDetailGoal = String(newValue.prefix(detailGoalLimit))
                                    }
                                }
                            
                            HStack(spacing: 0) {
                                Spacer()
                                Text("\(userDetailGoal.count)")
                                    .foregroundStyle(Color.my6C6C6C)
                                    .font(.Pretendard.Medium.size14)
                                Text("/20")
                                    .foregroundStyle(Color.my6C6C6C.opacity(0.5))
                                    .font(.Pretendard.Medium.size14)
                            }
                            .padding(.trailing)
                        }
                        .padding()
                    }
                )
                .padding(.horizontal)
                .padding(.top, 81)
            
            Spacer()
            
            // 하단 Button
            HStack {
                GoButton {
                    if let targetSubGoal = targetSubGoal, // id = 1에 해당하는 SubGoal의
                       let detailGoalToUpdate = targetSubGoal.detailGoals.first(where: { $0.id == 1 }) { // id = 1 DetailGoal 공간에 Update
                        viewModel.updateDetailGoal(
                            detailGoal: detailGoalToUpdate,
                            modelContext: modelContext,
                            newTitle: userDetailGoal,
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
                            achieveSun: false
                        )
                        //                        navigationManager.push(to: .onboardFinish)
                    } else {
                        print("Error: DetailGoal with ID 1 not found.")
                    }
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
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
    EnterDetailgoalView(nowOnboard: .detailgoalCycle)
        .environment(NavigationManager())
}
