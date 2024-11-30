import SwiftUI
import SwiftData

struct SubgoalCycleView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @Query private var mainGoals: [MainGoal]
    @State var viewModel = RoutineCycleViewModel(updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    @FocusState private var isFocused: Bool // TextField 포커스 상태 관리
    var nowOnboard: Onboarding = .subgoalCycle
    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingHeaderView(progressValue: 1/5) {
                navigationManager.pop()
            }
            // 상단 텍스트
            VStack(spacing: 12) {
                Text(nowOnboard.onboardingTitle)
                    .customMainStyle()
                Text(nowOnboard.onboardingSubTitle)
                    .customSubStyle()
            }
            .padding(.top, 31)
            
            // SubGoal 입력 뷰
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.my6FB56F)
                    .onTapGesture {
                        isFocused = true // Cell 전체영역 터치 시 TextField에 포커스
                    }
                
                TextField("이루고 싶은 목표", text: $viewModel.userNewSubGoal, axis: .vertical)
                    .font(.Pretendard.Medium.size20)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .padding(10)
                    .onChange(of: viewModel.userNewSubGoal) { oldValue, newValue in
                        if newValue.count > viewModel.subGoalLimit {
                            viewModel.userNewSubGoal = String(newValue.prefix(viewModel.subGoalLimit))
                        }
                        if let lastChar = newValue.last, lastChar == "\n" {
                            viewModel.userNewSubGoal = String(newValue.dropLast())
                            isFocused = false
                        }
                    }
                
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        Spacer()
                        Text("\(viewModel.userNewSubGoal.count)")
                            .foregroundStyle(.my6C6C6C)
                        Text("/\(viewModel.subGoalLimit)")
                            .foregroundStyle(.my6C6C6C.opacity(0.5))
                    }
                }
                .padding()
            }
            .frame(width: 199, height: 199)
            .padding(.top, 83)
            
            Spacer()
            
            NextButton(isEnabled: !viewModel.userNewSubGoal.isEmpty) {
                if let subGoal = mainGoals.first?.subGoals.first(where: { $0.id == 1 }) {
                    viewModel.updateSubGoal(
                        subGoal: subGoal,
                        newTitle: viewModel.userNewSubGoal,
                        category: subGoal.category
                    )
                    navigationManager.push(to: .onboardDetailgoal)
                }
            } label: {
                Text("다음")
            }
            .padding(.vertical)
        }
        .padding(.horizontal, 16)
        .background(.myFFFAF4)
        .contentShape(Rectangle())
        .ignoresSafeArea(.keyboard, edges: .bottom) // 키보드 올라올때, 뷰 자동 스크롤 제어
        .onTapGesture {
            UIApplication.shared.endEditing() // 빈 화면 터치 시 키보드 숨기기
        }
    }
}

#Preview {
    SubgoalCycleView(nowOnboard: .subgoalCycle)
        .environment(NavigationManager())
}
