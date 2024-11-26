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
    @State var tabBarVisible: Bool = true
    //    @State private var isHidden = true
    @Binding var isTabBarMainVisible: Bool
    private let innerColumns = Array(repeating: GridItem(.fixed(74/852 * UIScreen.main.bounds.height)), count: 2)
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let selectedSubGoal = selectedSubGoal {
                // 디테일골을 id에 따라 정렬
                let detailGoalsSorted = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
                
                NavigationLink(destination: SubGoalDetailGridView(subGoal: $selectedSubGoal, tabBarVisible: $tabBarVisible, isTabBarMainVisible: $isTabBarMainVisible)
                ){
                    LazyVGrid(columns: innerColumns, spacing: 4) {
                        ForEach(0..<4, id: \.self) { index in
                            let cornerRadius: CGFloat = 30
                            let cornerStyle = cornerStyle(for: index)
                            if index == (4 - selectedSubGoal.id) {
                                Text(selectedSubGoal.title.prefix(8))
                                    .modifier(MandalartButtonModifier())
                                    .background(Color.my95D895)
                                    .font(.Pretendard.Bold.size14)
                                    .cornerRadius(11)
                                
                            } else {
                                let detailGoalIndex = index < (4 - selectedSubGoal.id) ? index : index - 1
                                if detailGoalIndex < detailGoalsSorted.count {
                                    let detailGoal = detailGoalsSorted[detailGoalIndex]
                                    Text(detailGoal.title.prefix(8))
                                        .modifier(MandalartButtonModifier())
                                        .font(.Pretendard.Medium.size12)
                                        .background(colorForGoal(achieveGoal: detailGoal.achieveGoal, achieveCount: detailGoal.achieveCount))
                                        .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 11)
                                        .cornerRadius(11)
                                }
                            }
                        }
                    }
                }
            } else {
                Text("SubGoal을 찾을 수가 없습니다.")
            }
        }
        .onAppear{
            tabBarVisible = true
        }
    }
}
