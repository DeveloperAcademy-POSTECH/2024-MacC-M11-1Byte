import SwiftUI
import SwiftData

struct SubgoalCycleView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.modelContext) private var modelContext
    
    @Query private var mainGoals: [MainGoal]
    @State var viewModel = OnboardingViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    @State private var userSubGoal: String = "" // 사용자 SubGoal 입력 텍스트
    @FocusState private var isFocused: Bool // TextField 포커스 상태 관리
    private let subGoalLimit = 15 // 글자 수 제한
    
    var nowOnboard: Onboarding = .subgoalCycle
    
    var body: some View {
        VStack(spacing: 0) {
            // Back Button & 프로그레스 바
            HStack(spacing: 14) {
                Button {
                    navigationManager.pop()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .frame(width: 24, height: 24)
                            .tint(.black)
                            .padding(.leading, 4)
                    }
                }
                OnboardingProgressBar(value: 1/5)
                    .frame(height: 10)
                    .padding(.trailing, 43)
            }
            
            // 상단 텍스트
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
            
            // SubGoal 입력 창
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.my6FB56F)
                    .onTapGesture {
                        isFocused = true // Cell 전체영역 터치 시 TextField에 포커스
                    }
                
                TextField("이루고 싶은 목표", text: $userSubGoal, axis: .vertical)
                    .font(.Pretendard.Medium.size20)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .focused($isFocused)
                    .submitLabel(.done)
                    .padding(10)
                    .onChange(of: userSubGoal) { oldValue, newValue in
                        if newValue.count > subGoalLimit {
                            userSubGoal = String(newValue.prefix(subGoalLimit))
                        }
                        if let lastChar = newValue.last, lastChar == "\n" {
                            userSubGoal = String(newValue.dropLast())
                            isFocused = false
                        }
                    }
                
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        Spacer()
                        Text("\(userSubGoal.count)")
                            .foregroundStyle(.my6C6C6C)
                        Text("/15")
                            .foregroundStyle(.my6C6C6C.opacity(0.5))
                    }
                }
                .padding()
            }
            .frame(width: 199, height: 199)
            .padding(.top, 83)
            
            Spacer()
            
            // 하단 Button
            HStack {
                NextButton(isEnabled: !userSubGoal.isEmpty) {
                    if let subGoal = mainGoals.first?.subGoals.first(where: { $0.id == 1 }) {
                        viewModel.updateSubGoal(
                            subGoal: subGoal,
                            newTitle: userSubGoal,
                            category: subGoal.category
                        )
                        navigationManager.push(to: .onboardDetailgoal)
                    } else {
                        print("Error: subGoal with ID 1 not found.")
                    }
                } label: {
                    Text("다음")
                }
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
