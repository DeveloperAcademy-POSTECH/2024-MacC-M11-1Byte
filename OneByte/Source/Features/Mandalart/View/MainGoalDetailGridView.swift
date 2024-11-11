//
//  MainGoalDetailGridVIew.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import SwiftUI
import SwiftData

// MARK: 두번째 화면 - 메인 목표(MainGoal)와 관련된 SubGoals를 3x3 그리드로 표시하는 뷰
struct MainGoalDetailGridView: View {
    @Binding var mainGoal: MainGoal? // 선택된 MainGoal
    @Binding var isPresented: Bool
    @State var mainIsPresented: Bool = false
    @State private var selectedSubGoal: SubGoal?
    
    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        if let selectedMainGoal = mainGoal {
            let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id })
            
            LazyVGrid(columns: innerColumns, spacing: 10) {
                ForEach(0..<9, id: \.self) { index in
                    if index == 4 {
                        Button(action: {
                            mainIsPresented = true
                        }) {
                            Text(selectedMainGoal.title)
                                .modifier(NextMandalartButtonModifier(color: Color.blue))
                        }
                        .sheet(isPresented: $mainIsPresented) {
                            MainGoalsheetView(mainGoal: $mainGoal, isPresented: $mainIsPresented)
                        }
                    } else {
                        let subGoalIndex = index < 4 ? index : index - 1
                        if subGoalIndex < sortedSubGoals.count {
                            Button(action: {
                                selectedSubGoal = sortedSubGoals[subGoalIndex]
                                isPresented = true
                            }) {
                                Text(sortedSubGoals[subGoalIndex].title)
                                    .modifier(NextMandalartButtonModifier(color: Color.orange))
                            }
                            .sheet(isPresented: $isPresented) {
                                if selectedSubGoal != nil {
                                    SubGoalsheetView(subGoal: $selectedSubGoal, isPresented: $isPresented)
                                } else {
                                    Text("SubGoal 데이터를 찾을 수 없습니다.")
                                        .foregroundStyle(.gray)
                                        .padding()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(selectedMainGoal.title)
        } else {
            Text("MainGoal 데이터를 찾을 수 없습니다.")
                .foregroundStyle(.gray)
                .padding()
        }
    }
}
