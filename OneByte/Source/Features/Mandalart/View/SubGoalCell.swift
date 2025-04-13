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
    
    private let innerColumns = Array(repeating: GridItem(.fixed(74/852 * UIScreen.main.bounds.height)), count: 2)
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: []),
        firebaseService: FirebaseService()
    )
    
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
                            // 서브골 제목
                            Text(selectedSubGoal.title)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 15)
                                .frame(width: 78/393 * UIScreen.main.bounds.width, height: 78/852 * UIScreen.main.bounds.height)
                                .background(Color.my95D895)
                                .font(.setPretendard(weight: .bold, size: 14))
                                .cornerRadius(11)
                                .foregroundStyle(.white)
                        } else {
                            let detailGoalIndex = index < (4 - selectedSubGoal.id) ? index : index - 1
                            if detailGoalIndex < detailGoalsSorted.count {
                                let detailGoal = detailGoalsSorted[detailGoalIndex]
                                // 디테일 골 제목
                                Text(detailGoal.title)
                                    .padding(10)
                                    .frame(width: 78/393 * UIScreen.main.bounds.width, height: 78/852 * UIScreen.main.bounds.height)
                                    .foregroundStyle(.black)
                                    .font(.setPretendard(weight: .medium, size: 12))
                                    .background(viewModel.colorForGoal(achieveGoal: detailGoal.achieveGoal, achieveCount: detailGoal.achieveCount))
                                    .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 11)
                                    .cornerRadius(11)
                            }
                        }
                    }
                }
            }
        }
    }
}
