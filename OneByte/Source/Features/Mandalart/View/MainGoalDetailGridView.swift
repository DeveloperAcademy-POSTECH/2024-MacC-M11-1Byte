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
    @Binding var mainGoal: MainGoal?
    @Binding var isPresented: Bool
    @State var mainIsPresented: Bool = false
    @State private var selectedSubGoal: SubGoal?
    
    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        if let selectedMainGoal = mainGoal {
            let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id })
            
            LazyVGrid(columns: innerColumns, spacing: 3) {
                ForEach(0..<9, id: \.self) { index in
                    let cornerRadius: CGFloat = 20
                    let cornerStyle = cornerStyle(for: index) // cornerStyle 함수 사용
                    
                    if index == 4 {
                        Button(action: {
                            mainIsPresented = true
                        }) {
                            Text(selectedMainGoal.title)
                                .modifier(NextMandalartButtonModifier(color: Color.my538F53))
                        }
                        .cornerRadius(20)
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
                                    .modifier(NextMandalartButtonModifier(color: Color.my98DD98))
                            }
                            .cornerRadius(cornerRadius, corners: cornerStyle)
                            .sheet(isPresented: $isPresented) {
                                SubGoalsheetView(subGoal: $selectedSubGoal, isPresented: $isPresented)
                            }
                        }
                    }
                }
            }
            .navigationTitle(selectedMainGoal.title)
            .padding(.horizontal, 20/393 * UIScreen.main.bounds.width)
        } else {
            Text("MainGoal 데이터를 찾을 수 없습니다.")
                .foregroundStyle(.gray)
        }
    }
}
