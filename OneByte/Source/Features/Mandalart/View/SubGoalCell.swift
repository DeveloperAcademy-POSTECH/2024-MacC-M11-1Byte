//
//  SubGoalCell.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import SwiftUI
import SwiftData

// MARK: 첫화면 - 9개 서브골-디테일골들
struct SubGoalCell: View {
    @Binding var isPresented: Bool
    @Binding var selectedSubGoal: SubGoal?
    
    private let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        if let selectedSubGoal = selectedSubGoal {
            // 디테일골을 id에 따라 정렬
            let detailGoalsSorted = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
            
            NavigationLink(destination: SubGoalDetailGridView(subGoal: $selectedSubGoal, isPresented: $isPresented)) {
                LazyVGrid(columns: innerColumns, spacing: 1) {
                    ForEach(0..<9, id: \.self) { index in
                        if index == 4 {
                            Text(selectedSubGoal.title.prefix(8))
                                .modifier(MandalartButtonModifier(color: Color.my95D895))
                        } else {
                            let detailGoalIndex = index < 4 ? index : index - 1
                            if detailGoalIndex < detailGoalsSorted.count {
                                let detailGoal = detailGoalsSorted[detailGoalIndex]
                                Text(detailGoal.title.prefix(8))
                                    .modifier(MandalartButtonModifier(color: Color.myBFEBBB))
                            }
                        }
                    }
                }
            }
        } else {
            Text("SubGoal을 찾을 수가 없습니다.")
        }
    }
}
