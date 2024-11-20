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
    @Binding var selectedSubGoal: SubGoal?
    @State private var isHidden = true
    private let innerColumns = Array(repeating: GridItem(.fixed(78/852 * UIScreen.main.bounds.height)), count: 2)
    
    var body: some View {
        VStack(alignment: .center) {
            if let selectedSubGoal = selectedSubGoal {
                // 디테일골을 id에 따라 정렬
                let detailGoalsSorted = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
                
                NavigationLink(destination: SubGoalDetailGridView(subGoal: $selectedSubGoal)
                    .toolbar(isHidden ? .hidden : .visible, for: .tabBar) // 상태 관리
                    .onAppear {
                        isHidden = true
                    }
                    .onDisappear {
                        isHidden = false
                    }) {
                        LazyVGrid(columns: innerColumns, spacing: 4) {
                            ForEach(0..<4, id: \.self) { index in
                                let cornerRadius: CGFloat = 30
                                let cornerStyle = cornerStyle(for: index) // cornerStyle 함수 사용
                                if index == (4 - selectedSubGoal.id) { // 서브골을 메인화면에서 중앙에 놓기 위한 계산식.
                                    Text(selectedSubGoal.title.prefix(8))
                                        .modifier(MandalartButtonModifier(color: Color.my95D895))
                                        .font(.Pretendard.Bold.size14)
                                        .cornerRadius(11)
                                } else {
                                    let detailGoalIndex = index < (4 - selectedSubGoal.id) ? index : index - 1
                                    if detailGoalIndex < detailGoalsSorted.count {
                                        let detailGoal = detailGoalsSorted[detailGoalIndex]
                                        Text(detailGoal.title.prefix(8))
                                            .modifier(MandalartButtonModifier(color: Color.myBFEBBB))
                                            .font(.Pretendard.Medium.size12)
                                            .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 11)
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
}
