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
            // 나머지 셀에 정렬된 SubGoals 표시
            let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id })
            
            LazyVGrid(columns: innerColumns, spacing: 10) {
                ForEach(0..<9, id: \.self) { index in
                    if index == 4 {
                        // 가운데 셀에 MainGoal 제목 표시
                        Button(action: {
                            mainIsPresented = true
                        }, label: {
                            Text(selectedMainGoal.title)
                                .modifier(NextMandalartButtonModifier(color: Color.blue))
                        })
                        .sheet(isPresented: $mainIsPresented, content: {
                            MainGoalsheetView(mainGoal: $mainGoal, isPresented: $mainIsPresented)
                        })
                    } else {
                        let subGoalIndex = index < 4 ? index : index - 1
                        
                        if subGoalIndex < sortedSubGoals.count {
                            Button(action: {
                                selectedSubGoal = sortedSubGoals[subGoalIndex] // 클릭된 SubGoal 저장
                                isPresented = true
                            }, label: {
                                Text(sortedSubGoals[subGoalIndex].title)
                                    .modifier(NextMandalartButtonModifier(color: Color.orange)) // 서브골들
                            })
                            .sheet(isPresented: $isPresented) {
                                if selectedSubGoal != nil {
                                    SubGoalsheetView(subGoal: $selectedSubGoal, isPresented: $isPresented)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(selectedMainGoal.title)
        }
    }
}

