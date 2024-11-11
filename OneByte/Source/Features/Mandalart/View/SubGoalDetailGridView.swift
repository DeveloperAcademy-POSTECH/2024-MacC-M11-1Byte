//
//  SubGoalDetailGridView.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import SwiftUI
import SwiftData

// MARK: 두번째 화면 - 클릭된 셀의 SubGoal 및 관련된 DetailGoals만 3x3 그리드로 표시하는 뷰
struct SubGoalDetailGridView: View {
    @Binding var subGoal: SubGoal?
    @Binding var isPresented: Bool
    @State private var selectedDetailGoal: DetailGoal?
    private let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    @State var subSheetIsPresented: Bool = false
    
    var body: some View {
        if let selectedSubGoal = subGoal {
            // 디테일골을 id 값에 따라 정렬
            let sortedDetailGoals = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
            
            LazyVGrid(columns: innerColumns, spacing: 10) {
                ForEach(0..<9, id: \.self) { index in
                    if index == 4 {
                        // 네 번째 셀에 서브골 제목 표시
                        Button(action: {
                            subSheetIsPresented = true
                        }, label: {
                            Text(selectedSubGoal.title)
                                .modifier(NextMandalartButtonModifier(color: Color.orange))
                        })
                        .sheet(isPresented: $subSheetIsPresented, content: {
                            SubGoalsheetView(subGoal: $subGoal, isPresented: $subSheetIsPresented)
                        })
                    } else {
                        // 나머지 셀에 디테일골 제목 표시
                        let detailGoalIndex = index < 4 ? index : index - 1
                        if detailGoalIndex < sortedDetailGoals.count {
                            let detailGoal = sortedDetailGoals[detailGoalIndex]
                            Button(action: {
                                selectedDetailGoal = sortedDetailGoals[detailGoalIndex] // 클릭된 SubGoal 저장
                                isPresented = true
                            }, label: {
                                Text(detailGoal.title)
                                    .modifier(NextMandalartButtonModifier(color: Color.green))
                            })
                            .sheet(isPresented: $isPresented) {
                                if selectedDetailGoal != nil {
                                    DetailGoalsheetView(detailGoal: $selectedDetailGoal, isPresented: $isPresented)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle(selectedSubGoal.title)
        }
    }
}
