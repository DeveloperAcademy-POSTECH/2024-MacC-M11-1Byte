//
//  MainGoalCell.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import SwiftUI
import SwiftData

// MARK: 첫화면 - 9개 메인골-서브골
struct MainGoalCell: View {
    @Binding var subGoal: SubGoal?
    @Binding var mainGoal: MainGoal?
    @Binding var isPresented: Bool
    
    private let innerColumns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        if let selectedMainGoal = mainGoal {
            // 섭골 아이디로 정렬
            let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id })
            
            NavigationLink(destination: MainGoalDetailGridView(mainGoal: $mainGoal, isPresented: $isPresented)) {
                LazyVGrid(columns: innerColumns, spacing: 1) {
                    ForEach(0..<4, id: \.self) { index in
                        if index == 3 {
                            // 메인골 제목 표시
                            Text(selectedMainGoal.title.prefix(8))
                                .modifier(MandalartButtonModifier(color: Color.my538F53))
                        } else {
                            let subGoalIndex = index < 3 ? index : index - 1
                            
                            if subGoalIndex < sortedSubGoals.count {
                                let subGoal = sortedSubGoals[subGoalIndex]
                                Text(subGoal.title.prefix(8))
                                    .modifier(MandalartButtonModifier(color: Color.my95D895))
                            }
                        }
                    }
                }
            }
        }
    }
}
