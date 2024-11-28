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
    @Binding var isTabBarMainVisible: Bool
    @State var isSubNavigation: Bool = false // 네비게이션 활성화 상태
    private let innerColumns = Array(repeating: GridItem(.fixed(74/852 * UIScreen.main.bounds.height)), count: 2)

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let selectedSubGoal = selectedSubGoal {
                // 디테일골을 id에 따라 정렬
                let detailGoalsSorted = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })

                LazyVGrid(columns: innerColumns, spacing: 4) {
                    ForEach(0..<4, id: \.self) { index in
                        let cornerRadius: CGFloat = 30
                        let cornerStyle = cornerStyle(for: index)
                        if index == (4 - selectedSubGoal.id) {
                            // 서브골 제목 버튼
//                            Button(action: {
//                                isSubNavigation = true // 네비게이션 활성화
//                            }) {
                                Text(selectedSubGoal.title)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 15)
                                    .modifier(MandalartButtonModifier())
                                    .background(Color.my95D895)
                                    .font(.Pretendard.Bold.size14)
                                    .cornerRadius(11)
//                            }
                        } else {
                            let detailGoalIndex = index < (4 - selectedSubGoal.id) ? index : index - 1
                            if detailGoalIndex < detailGoalsSorted.count {
                                let detailGoal = detailGoalsSorted[detailGoalIndex]
//                                Button(action: {
//                                    isSubNavigation = true // 네비게이션 활성화
//                                }) {
                                    Text(detailGoal.title)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 15)
                                        .modifier(MandalartButtonModifier())
                                        .font(.Pretendard.Medium.size12)
                                        .background(colorForGoal(achieveGoal: detailGoal.achieveGoal, achieveCount: detailGoal.achieveCount))
                                        .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 11)
                                        .cornerRadius(11)
                                }
//                            }
                        }
                    }
                }
//                .navigationDestination(isPresented: $isSubNavigation) {
//                    let selectedSubGoal = selectedSubGoal
//               SubGoalDetailGridView(
//                    subGoal: $selectedSubGoal,
//                    tabBarVisible: $tabBarVisible,
//                    isTabBarMainVisible: $isTabBarMainVisible,
//                    isSubNavigation: $isSubNavigation
//                )}
            }
        }
        .onAppear {
            tabBarVisible = true
        }
    }
}
