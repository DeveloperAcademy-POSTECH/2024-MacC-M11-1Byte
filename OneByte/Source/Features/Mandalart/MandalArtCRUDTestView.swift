import SwiftUI
import SwiftData

struct CUTestView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @StateObject private var viewModel: CUTestViewModel
    @State var goalTitle: String = ""
    
    @Query private var mainGoals: [MainGoal]
    
    init(viewModel: CUTestViewModel = CUTestViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("메인 골을 입력해주세요.", text: $goalTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("메인Goal 생성") {
                    let newGoal = viewModel.createMainGoal(title: goalTitle)
                    modelContext.insert(newGoal)
                    goalTitle = ""  // Reset the input field
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                List(mainGoals, id: \.id) { goal in // 메인골 리스트
                    NavigationLink(destination: SubGoalView(mainGoalId: goal.id, viewModel: CUTestViewModel(), mainGoal: goal)) {
                        Text(goal.title).font(.headline)
                    }
                }
                Button("전체 데이터 출력") {
                    printAllGoals()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
    
    // 전체 데이터를 콘솔에 출력하는 함수
    private func printAllGoals() {
        for mainGoal in mainGoals {
            print("MainGoal: \(mainGoal.id), Title: \(mainGoal.title)")
            for subGoal in mainGoal.subGoals {
                print("  SubGoal: \(subGoal.id), Title: \(subGoal.title)")
            }
        }
    }
}

struct SubGoalView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var subGoalTitle: String = ""
    let mainGoalId: UUID
    @StateObject var viewModel: CUTestViewModel
    let mainGoal: MainGoal
    
    @Query private var subGoals: [SubGoal] // mainGoal에 속한 subGoals를 가져오는 query
    
//    init(mainGoal: MainGoal, viewModel: CUTestViewModel = CUTestViewModel()) {
//        self.mainGoal = mainGoal
//        self.viewModel = viewModel
//        // mainGoal에 속한 subGoals만 필터링
//        _subGoals = Query(filter: #Predicate<SubGoal> { subGoal in
//            subGoal.mainGoal?.id == mainGoal.id
//        })
//    }
    
    var body: some View {
        VStack {
            VStack {
                TextField("서브 골을 입력해주세요", text: $subGoalTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("서브Goal 생성") {
                    if let newSubGoal = viewModel.createSubGoal(mainGoal: mainGoalId, title: subGoalTitle) {
                        modelContext.insert(newSubGoal)
                        subGoalTitle = ""  // 입력 필드 초기화
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            // SubGoal 목록
            List(subGoals, id: \.id) { subGoal in
                Text(subGoal.title)
                    .font(.headline)
            }
        }
        .navigationTitle(mainGoal.title)
    }
}

