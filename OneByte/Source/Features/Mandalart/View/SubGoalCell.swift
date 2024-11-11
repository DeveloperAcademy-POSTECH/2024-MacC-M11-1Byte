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
                LazyVGrid(columns: innerColumns, spacing: 5) {
                    ForEach(0..<9, id: \.self) { innerIndex in
                        if innerIndex == 4 {
                            Text(selectedSubGoal.title)
                                .modifier(MandalartButtonModifier(color: Color.orange))
                        } else {
                            let detailGoalIndex = innerIndex < 4 ? innerIndex : innerIndex - 1
                            if detailGoalIndex < detailGoalsSorted.count {
                                let detailGoal = detailGoalsSorted[detailGoalIndex]
                                Text(detailGoal.title)
                                    .modifier(MandalartButtonModifier(color: Color.green))
                            }
                        }
                    }
                }
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        } else {
            Text("SubGoal을 찾을 수가 없습니다.")
        }
    }
}
