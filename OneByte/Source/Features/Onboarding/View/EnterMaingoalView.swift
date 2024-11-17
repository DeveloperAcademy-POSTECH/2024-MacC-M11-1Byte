//
//  EnterMainGoal.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

struct EnterMaingoalView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    @Environment(\.modelContext) private var modelContext
    @Query private var mainGoals: [MainGoal]
    
    @State var viewModel = OnboardingViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    @State private var userMainGoal: String = "" // 사용자 입력 MainGoal
    private let mainGoalLimit = 15 // 글자 수 제한
    @FocusState private var isFocused: Bool // TextField 포커스 상태 관리
    
    var nowOnboard: Onboarding = .maingoal
    
    var body: some View {
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
                OnboardingProgressBar(value: 2/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
            Text(nowOnboard.onboardingTitle)
                .font(.Pretendard.Bold.size26)
                .multilineTextAlignment(.center)
            
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
            
            // MainGoal 입력 창
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "EEEEEE"))
                    .onTapGesture {
                        isFocused = true // Cell 전체영역 터치 시 TextField에 포커스
                    }
                
                TextField("2025 최종 목표", text: $userMainGoal, axis: .vertical)
                    .font(.Pretendard.SemiBold.size20)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.clear)
                    .focused($isFocused) // FocusState와 연결
                    .submitLabel(.done)
                    .onChange(of: userMainGoal) { oldValue, newValue in
                        if newValue.count > mainGoalLimit {
                            userMainGoal = String(newValue.prefix(mainGoalLimit))
                        }
                        if let lastChar = newValue.last, lastChar == "\n" {
                            userMainGoal = String(newValue.dropLast())
                            isFocused = false // 키보드 내리기
                        }
                    }
                
                // 글자수 표시
                VStack {
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Spacer()
                        Text("\(userMainGoal.count)")
                            .foregroundStyle(Color.my6C6C6C)
                        Text("/15")
                            .foregroundStyle(Color.my6C6C6C.opacity(0.5))
                    }
                    .padding()
                }
            }
            .frame(width: 210, height: 210)
            
            Spacer()
            
            // 하단 Button
            HStack {
                NextButton(isEnabled: !userMainGoal.isEmpty) { // 사용자 입력 MainGoal이 비어있지 않을 때만 활성화
                    viewModel.updateMainGoal( // MainGoal 데이터 업데이트
                        mainGoals: mainGoals,
                        userMainGoal: userMainGoal,
                        modelContext: modelContext
                    )
                    navigationManager.push(to: .onboardSubgoal)
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            UIApplication.shared.endEditing() // 빈 화면 터치 시 키보드 숨기기
        }
    }
}

#Preview {
    EnterMaingoalView(nowOnboard: .maingoal)
        .environment(NavigationManager())
}
