//
//  SubGoalDetailGridView.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import SwiftUI
import SwiftData

struct SubGoalDetailGridView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var subGoal: SubGoal?
    @State private var selectedDetailGoal: DetailGoal? // 선택된 DetailGoal 저장
    @State private var isSubSheetPresented: Bool = false
    @State private var isNavigationActive: Bool = false  // 네비게이션 활성화 여부
    
    private let gridColumns = Array(repeating: GridItem(.fixed(123 / 852 * UIScreen.main.bounds.height)), count: 2)
    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
    private let viewModel = MandalartViewModel(
        createService: ClientCreateService(),
        updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    
    var body: some View {
//        NavigationStack {
            VStack {
                //  Goal Grid
                if let selectedSubGoal = subGoal {
                    // MARK: - SubGoal + DetailGoal Grid
                    buildGrid(for: selectedSubGoal)
                        .padding(.horizontal, 20 / 393 * UIScreen.main.bounds.width)
                        .navigationTitle(selectedSubGoal.title)
                }
                // 네비게이션 링크
                NavigationLink(
                    destination: DetailGoalView(detailGoal: $selectedDetailGoal),
                    isActive: $isNavigationActive
                ) { EmptyView() }
                // 메모들
            }
            .navigationBarBackButtonHidden()
            .backButtonToolbar { dismiss() }
            
            
        }
//    }
}

extension SubGoalDetailGridView {
    // MARK: - SubGoal + DetailGoal Grid
    func buildGrid(for subGoal: SubGoal) -> some View {
        let sortedDetailGoals = subGoal.detailGoals.sorted(by: { $0.id < $1.id })
        
        return LazyVGrid(columns: gridColumns, spacing: 5) {
            ForEach(0..<4, id: \.self) { index in
                if index == (4 - subGoal.id) {
                    buildSubGoalButton(for: subGoal)
                } else {
                    buildDetailGoalButton(for: subGoal,detailGoals: sortedDetailGoals, at: index)
                }
            }
        }
    }
    
    // MARK: - SubGoal Button
    func buildSubGoalButton(for subGoal: SubGoal) -> some View {
        Button(action: { isSubSheetPresented = true }) {
            Text(subGoal.title)
                .font(.Pretendard.SemiBold.size18)
                .modifier(NextMandalartButtonModifier(color: Color.my95D895))
        }
        .cornerRadius(18)
        .sheet(isPresented: $isSubSheetPresented) {
            SubGoalsheetView(subGoal: $subGoal, isPresented: $isSubSheetPresented)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(244 / 852 * UIScreen.main.bounds.height)])
        }
        .contextMenu {
            Button(role: .destructive) {
                viewModel.deleteSubGoal(
                    subGoal: subGoal,
                    modelContext: modelContext,
                    id: subGoal.id,
                    newTitle: ""
                )
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    // MARK: - DetailGoal Button
    @ViewBuilder
    func buildDetailGoalButton(for subGoal: SubGoal, detailGoals: [DetailGoal], at index: Int) -> some View {
        let detailGoalIndex = index < (4 - subGoal.id) ? index : index - 1
        if detailGoalIndex < detailGoals.count {
            let detailGoal = detailGoals[detailGoalIndex]
            
            Button(action: {
                selectedDetailGoal = detailGoal // 클릭된 DetailGoal 설정
                isNavigationActive = true
            }) {
                Text(detailGoal.title)
                    .font(.Pretendard.Medium.size18)
                    .modifier(NextMandalartButtonModifier(color: Color.myBFEBBB))
            }
            .cornerRadius(48, corners: cornerStyle(for: index), defaultRadius: 18)
            .contextMenu {
                Button(role: .destructive) {
                    viewModel.deleteDetailGoal(
                        detailGoal: detailGoal,
                        modelContext: modelContext,
                        id: detailGoal.id,
                        newTitle: "",
                        newMemo: "",
                        isAcheived: false
                    )
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
}
