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
    @Environment(\.modelContext) private var modelContext
    
    @Binding var subGoal: SubGoal?
    @State private var selectedDetailGoal: DetailGoal?
    @State var subSheetIsPresented: Bool = false
    @State private var detailSheetIsPresented = false
    
    private let innerColumns = Array(repeating: GridItem(.fixed(123/852 * UIScreen.main.bounds.height)), count: 2)
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    
    var body: some View {
        VStack(alignment: .center) {
            if let selectedSubGoal = subGoal {
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
                                    viewModel.deleteSubGoal(subGoal: selectedSubGoal, modelContext: modelContext, id: selectedSubGoal.id, newTitle: "", leafState: 0)
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
                                    detailSheetIsPresented = true
                                }, label: {
                                    Text(detailGoal.title)
                                        .font(.Pretendard.Medium.size18)
                                        .modifier(NextMandalartButtonModifier(color: Color.myBFEBBB))
                                })
                                .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 18)
                                .sheet(isPresented: $detailSheetIsPresented) {
                                    if selectedDetailGoal != nil {
                                        DetailGoalsheetView(detailGoal: $selectedDetailGoal, isPresented: $detailSheetIsPresented)
                                            .presentationDragIndicator(.visible)
                                            .presentationDetents([.height(447/852 * UIScreen.main.bounds.height)])
                                    }
                                }
                                .contextMenu {
                                    Button(role: .destructive){
                                        viewModel.deleteDetailGoal(
                                            detailGoal: detailGoal, modelContext: modelContext, newTitle: "", newMemo: "", achieveCount: 0, achieveGoal: 0, alertMon: false, alertTue: false, alertWed: false, alertThu: false, alertFri: false, alertSat: false, alertSun: false, isRemind: false, remindTime: nil, achieveMon: false, achieveTue: false, achieveWed: false, achieveThu: false, achieveFri: false, achieveSat: false, achieveSun: false
                                        )
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
