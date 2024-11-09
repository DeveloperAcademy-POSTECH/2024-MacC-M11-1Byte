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
    @AppStorage("isFirstOnboarding") private var isFirstOnboarding: Bool? // 온보딩 첫 동작시에만
    
    @Environment(\.modelContext) private var modelContext
    @Query private var subGoals: [SubGoal]
    var detailGoal: DetailGoal?
    @State private var userDetailGoal: String = "" // 사용자 SubGoal 입력 텍스트
    @State private var userDetailGoalNewMemo: String = ""
    @State var viewModel = OnboardingViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
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
                    .frame(height: 112)
                
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
            .padding()
            
            Spacer()
            
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
                        .frame(width: itemSize, height: itemSize) // 항상 1:1 비율 설정
                        
                        if item == 1 {
                            // 1번 셀일 경우 TextField와 터치 가능
                            TextField("할 일", text: $userDetailGoal)
                                .font(.Pretendard.Regular.size20)
                                .multilineTextAlignment(.center)
                                .padding(10)
                        }
                        
                        // item이 5인 중앙은 mainGoals
                        if item == 5 {
                            if let subGoal = subGoals.first {
                                Text(subGoal.title)
                                    .font(.Pretendard.Medium.size20)
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
                    navigationManager.push(to: .onboardFinish)
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
    }
}

#Preview {
    EnterDetailgoalView(nowOnboard: .detailgoal)
        .environment(NavigationManager())
}
