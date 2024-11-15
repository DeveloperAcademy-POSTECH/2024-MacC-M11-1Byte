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
    private let innerColumns = Array(repeating: GridItem(.fixed(123/852 * UIScreen.main.bounds.height)), count: 2)
    @State var subSheetIsPresented: Bool = false
    
    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
    private let viewModel = MandalartViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []), deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: []))
    
    var body: some View {
        VStack(alignment: .center) {
            if let selectedSubGoal = subGoal {
                // 디테일골을 id 값에 따라 정렬
                let sortedDetailGoals = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
                
                LazyVGrid(columns: innerColumns, spacing: 5) {
                    ForEach(0..<4, id: \.self) { index in
                        let cornerRadius: CGFloat = 48
                        let cornerStyle = cornerStyle(for: index) // cornerStyle 함수 사용
                        
                        if index == 3 {
                            // 네 번째 셀에 서브골 제목 표시
                            Button(action: {
                                subSheetIsPresented = true
                            }, label: {
                                Text(selectedSubGoal.title)
                                    .font(.Pretendard.SemiBold.size18)
                                    .modifier(NextMandalartButtonModifier(color: Color.my95D895))
                            })
                            .cornerRadius(18)
                            .sheet(isPresented: $subSheetIsPresented, content: {
                                SubGoalsheetView(subGoal: $subGoal, isPresented: $subSheetIsPresented)
                                    .presentationDragIndicator(.visible)
                                    .presentationDetents([.height(244/852 * UIScreen.main.bounds.height)])
                            })
                            .contextMenu {
                                Button(role: .destructive){
                                    viewModel.deleteSubGoal(subGoal: selectedSubGoal, modelContext: modelContext, id: selectedSubGoal.id, newTitle: "")
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        } else {
                            // 나머지 셀에 디테일골 제목 표시
                            let detailGoalIndex = index < 3 ? index : index - 1
                            if detailGoalIndex < sortedDetailGoals.count {
                                let detailGoal = sortedDetailGoals[detailGoalIndex]
                                Button(action: {
                                    selectedDetailGoal = sortedDetailGoals[detailGoalIndex] // 클릭된 SubGoal 저장
                                    isPresented = true
                                }, label: {
                                    Text(detailGoal.title)
                                        .font(.Pretendard.Medium.size18)
                                        .modifier(NextMandalartButtonModifier(color: Color.myBFEBBB))
                                })
                                .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 18)
                                .sheet(isPresented: $isPresented) {
                                    if selectedDetailGoal != nil {
                                        DetailGoalsheetView(detailGoal: $selectedDetailGoal, isPresented: $isPresented)
                                            .presentationDragIndicator(.visible)
                                            .presentationDetents([.height(447/852 * UIScreen.main.bounds.height)])
                                    }
                                }
                                .contextMenu {
                                    Button(role: .destructive){
                                        viewModel.deleteDetailGoal(detailGoal: detailGoal, modelContext: modelContext, id: detailGoal.id, newTitle: "", newMemo: "", isAcheived: false)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20/393 * UIScreen.main.bounds.width)
                .navigationTitle(selectedSubGoal.title)
            }
        }
    }
}
