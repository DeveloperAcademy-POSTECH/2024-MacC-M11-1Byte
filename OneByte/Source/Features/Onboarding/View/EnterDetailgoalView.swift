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
    //    var detailGoal: DetailGoal?
    @State var viewModel = OnboardingViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    @State private var userDetailGoal: String = "" // 사용자 SubGoal 입력 텍스트
    @State private var userDetailGoalNewMemo: String = ""
    @State private var userDetailGoalAchieved: Bool = false
    @State private var targetSubGoal: SubGoal? // id가 1인 SubGoal 저장변수
    @FocusState private var isFocused: Bool // TextField 포커스 상태 관리
    private let detailGoalLimit = 15 // 글자 수 제한
    
    // 3x3 View Custom 변수들
    let items = Array(1...9)
    let gridSpacing: CGFloat = 5 // 셀 간 수직 간격
    let horizontalPadding: CGFloat = 15 // 양쪽 여백 설정
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3) // 수평 간격 설정
    
    var nowOnboard: Onboarding = .detailgoal
    
    var body: some View {
        let gridWidth = UIScreen.main.bounds.width - (horizontalPadding * 2)
        let itemSize = (gridWidth - (gridSpacing * 2)) / 3
        
        VStack {
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
            
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingSubTitle)
                    .font(.Pretendard.Bold.size17)
                    .foregroundStyle(Color(hex: "919191"))
                    .multilineTextAlignment(.center)
                
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
            }
            
            // 팁 메세지 영역
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "D4F7D7"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 112) // ✅ 나중에 디자인팀에서 보여주는 방식 바꿔주면, mini에서 텍스트 짤림문제 해결하기
                
                VStack(alignment: .leading) {
                    (Text("TIP ")
                        .font(.Pretendard.Bold.size14) +
                     Text(nowOnboard.onboardingTipMessage))
                    .font(.Pretendard.Regular.size14)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .padding()
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 0) {
                Spacer()
                Text("\(userDetailGoal.count)")
                    .foregroundStyle(Color(hex: "6C6C6C"))
                Text("/15")
                    .foregroundStyle(Color(hex: "6C6C6C").opacity(0.5))
            }
            .padding(.trailing)
            
            // 중앙 3x3 View
            LazyVGrid(columns: columns, spacing: gridSpacing) {
                ForEach(items, id: \.self) { item in
                    let radiusValues = item.cornerRadiusValues(for3x3Grid: 20)
                    
                    ZStack {
                        CustomCornerRoundedRectangle(
                            topLeft: radiusValues.topLeft,
                            topRight: radiusValues.topRight,
                            bottomLeft: radiusValues.bottomLeft,
                            bottomRight: radiusValues.bottomRight
                        )
                        .fill(
                            item == 1 ? Color(hex: "F7F7A0") :
                                item == 5 ? Color(hex: "D2E3D6") :
                                Color(hex: "EEEEEE")
                        )
                        .onTapGesture {
                            if item == 1 {
                                isFocused = true // 1번 아이템 터치 시 TextField에 포커스 맞추기
                            }
                        }
                        .frame(width: itemSize, height: itemSize) // 항상 1:1 비율 설정
                        
                        if item == 1 {
                            // 1번 셀일 경우 TextField와 터치 가능
                            TextField("할 일", text: $userDetailGoal, axis: .vertical)
                                .font(.Pretendard.Regular.size18)
                                .multilineTextAlignment(.center)
                                .focused($isFocused)
                                .padding(10)
                                .onChange(of: userDetailGoal) { newValue in
                                    if newValue.count > detailGoalLimit {
                                        userDetailGoal = String(newValue.prefix(detailGoalLimit))
                                    }
                                }
                        }
                        
                        // item이 5인 중앙은 SubGoal
                        if item == 5 {
                            if let title = targetSubGoal?.title {
                                Text(title)
                                    .font(.Pretendard.Medium.size18)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text("")
                            }
                        } else {
                            Text("")
                        }
                    }
                }
            }
            .frame(width: gridWidth) // LazyVGrid의 너비를 설정하여 양쪽 여백을 구현
            .padding(.horizontal, gridSpacing) // 수직 간격을 위한 추가 패딩
            
            Spacer()
            
            // 하단 Button
            HStack {
                PassButton {
                    isFirstOnboarding = false // 온보딩 close
                } label: {
                    Text("건너 뛰기")
                }
                
                GoButton {
                    if let targetSubGoal = targetSubGoal, // id = 1에 해당하는 SubGoal의
                       let detailGoalToUpdate = targetSubGoal.detailGoals.first(where: { $0.id == 1 }) { // id = 1 DetailGoal 공간에 Update
                        viewModel.updateDetailGoal(
                            detailGoal: detailGoalToUpdate,
                            modelContext: modelContext,
                            newTitle: userDetailGoal,
                            newMemo: userDetailGoalNewMemo,
                            isAchieved: userDetailGoalAchieved
                        )
                        navigationManager.push(to: .onboardFinish)
                    } else {
                        print("Error: DetailGoal with ID 1 not found.")
                    }
                    
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
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
    EnterDetailgoalView(nowOnboard: .detailgoal)
        .environment(NavigationManager())
}
