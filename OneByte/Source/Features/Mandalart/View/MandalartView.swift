//
//  ObjectiveView.swift
//  OneByte
//
//  Created by 트루디 on 11/03/24.
//
import SwiftUI
import SwiftData

struct MandalartView: View {
    @AppStorage("FirstOnboarding") var FirstOnboarding: Bool = true
    @Query private var mainGoals: [MainGoal]
    @State var isPresented = false
    @State private var subGoal: SubGoal?
    @State private var mainGoal: MainGoal?
    
    var body: some View {
        NavigationStack {
            if let firstMainGoal = mainGoals.first {
                OuterGridView(
                    isPresented: $isPresented,
                    subGoal: $subGoal,
                    mainGoal: $mainGoal
                )
                .onAppear {
                    mainGoal = firstMainGoal
                }
            } else {
                Text("MainGoal 데이터를 찾을 수 없습니다.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .fullScreenCover(isPresented: $FirstOnboarding) {
            OnboardingStartView()
        }
    }
}


// MARK: 첫화면 -  전체 81개짜리
struct OuterGridView: View {
    @Binding var isPresented: Bool
    @Binding var subGoal: SubGoal?
    @Binding var mainGoal: MainGoal? // mainGoal을 @Binding으로 사용

    private let outerColumns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        if let selectedMainGoal = mainGoal {
            let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id }) // 정렬된 SubGoals 배열
            
            LazyVGrid(columns: outerColumns, spacing: 10) {
                ForEach(0..<9, id: \.self) { index in
                    if index == 4 {
                        MainGoalCell(subGoal: $subGoal, mainGoal: $mainGoal, isPresented: $isPresented)
                    } else {
                        let subGoalIndex = index < 4 ? index : index - 1
                        if subGoalIndex < sortedSubGoals.count {
                            SubGoalCell(isPresented: $isPresented, selectedSubGoal: Binding(
                                get: { sortedSubGoals[subGoalIndex] },
                                set: { _ in }
                            ))
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            .padding()
        } else {
            Text("찾을 수 없습니다.")
        }
    }
}
