import SwiftUI
import SwiftData

struct EnterSubgoalView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @AppStorage("FirstOnboarding") private var isFirstOnboarding: Bool?
    @Environment(\.modelContext) private var modelContext
    
    @Query private var mainGoals: [MainGoal]
    
    @State var viewModel = OnboardingViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    let items = Array(1...9)
    let gridSpacing: CGFloat = 5 // 셀 간 수직 간격
    let horizontalPadding: CGFloat = 15 // 양쪽 여백 설정
    let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3) // 수평 간격 설정
    
    var nowOnboard: Onboarding = .subgoal
    
    @State private var userSubGoal: String = "" // 사용자 SubGoal 입력 텍스트
    
    var body: some View {
        let gridWidth = UIScreen.main.bounds.width - (horizontalPadding * 2)
        let itemSize = (gridWidth - (gridSpacing * 2)) / 3
        
        VStack {
            // Back Button & 프로그레스 바
            HStack {
                Button {
                    navigationManager.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.black)
                        .bold()
                }
                OnboardingProgressBar(value: 3/5)
                    .frame(height: 10)
                    .padding()
                    .padding(.trailing)
            }
            .padding(.horizontal)
            
            // 상단 텍스트
            VStack(spacing: 10) {
                Text(nowOnboard.onboardingSubTitle)
                    .font(.Pretendard.Bold.size17)
                    .foregroundStyle(Color(hex: "919191"))
                
                Text(nowOnboard.onboardingTitle)
                    .font(.Pretendard.Bold.size26)
                    .multilineTextAlignment(.center)
            }
            
            // 팁 메시지 영역
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "D4F7D7"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 112)
                
                VStack(alignment: .leading) {
                    (Text("TIP ")
                        .font(.Pretendard.Bold.size18) +
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
                            item == 1 ? Color(hex: "AAF0B1") :
                                item == 5 ? Color(hex: "C6CBC6") :
                                Color(hex: "EEEEEE")
                        )
                        .frame(width: itemSize, height: itemSize) // 항상 1:1 비율 설정
                        
                        if item == 1 {
                            // 1번 셀일 경우 TextField와 터치 가능
                            TextField("세부 목표", text: $userSubGoal)
                                .font(.Pretendard.Regular.size20)
                                .multilineTextAlignment(.center)
                                .padding(10)
                        }
                        
                        // item이 5인 중앙은 MainGoal
                        if item == 5 {
                            if let mainGoal = mainGoals.first {
                                Text(mainGoal.title)
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
                    isFirstOnboarding = false
                } label: {
                    Text("건너 뛰기")
                }
                
                GoButton {
                    if let subGoal = mainGoals.first?.subGoals.first(where: { $0.id == 1 }) {
                           viewModel.updateSubGoal(
                               subGoal: subGoal,
                               modelContext: modelContext,
                               newTitle: userSubGoal,
                               newMemo: subGoal.memo // 기존 메모를 유지하거나, 새 메모를 전달할 수 있음
                           )
                           do {
                               try modelContext.save()
                           } catch {
                               print("Error saving subGoal: \(error.localizedDescription)")
                           }
                           navigationManager.push(to: .onboardDetailgoal)
                       } else {
                           print("Error: subGoal with ID 1 not found.")
                       }
                } label: {
                    Text("다음")
                }
            }
            .padding()
        }
    }
}

#Preview {
    EnterSubgoalView(nowOnboard: .subgoal)
        .environment(NavigationManager())
}
