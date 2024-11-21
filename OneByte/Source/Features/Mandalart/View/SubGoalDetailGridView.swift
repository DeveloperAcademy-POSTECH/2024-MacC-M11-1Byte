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
//    @Environment(\.dismiss) private var dismiss
    @State var navigation: Bool = false
    @State private var selectedDetailGoal: DetailGoal?
    @State var subSheetIsPresented: Bool = false
    @Binding var subGoal: SubGoal?
    
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let selectedSubGoal = subGoal {
                let sortedDetailGoals = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
                Spacer()
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(123/852 * UIScreen.main.bounds.height)), count: 2), spacing: 5) {
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
                                    viewModel.deleteSubGoal(subGoal: selectedSubGoal, id: selectedSubGoal.id, newTitle: "", leafState: 0)
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
                                    let detailGoal = sortedDetailGoals[detailGoalIndex]
                                    selectedDetailGoal = detailGoal
                                    navigation = true
                                }) {
                                    Text(detailGoal.title)
                                        .font(.Pretendard.Medium.size18)
                                        .modifier(NextMandalartButtonModifier(color: Color.myBFEBBB))
                                }
                                .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 18)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        viewModel.deleteDetailGoal(
                                            detailGoal: detailGoal, newTitle: "", newMemo: "", achieveCount: 0, achieveGoal: 0, alertMon: false, alertTue: false, alertWed: false, alertThu: false, alertFri: false, alertSat: false, alertSun: false, isRemind: false, remindTime: nil, achieveMon: false, achieveTue: false, achieveWed: false, achieveThu: false, achieveFri: false, achieveSat: false, achieveSun: false
                                        )
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $navigation) {
                    let detailGoal = selectedDetailGoal
                        DetailGoalView(detailGoal: .constant(detailGoal))
//                    }
                }
                Spacer()
                // 메모 모아보기
                memoes()
                    .navigationTitle(selectedSubGoal.title)
                    .padding(.top, 63)
                Spacer()
            } else {
                ProgressView("loading..")
            }
        } // VStack 끝
        .padding(.horizontal, 20/393 * UIScreen.main.bounds.width)
        .padding(.top, 55)
//        .navigationBarBackButtonHidden()
//        .backButtonToolbar { dismiss() }
        .background(Color.myFFFAF4)
        .navigationTitle(subGoal?.title ?? "")
    }
}

extension SubGoalDetailGridView {
    @ViewBuilder
    func memoes() -> some View {
        // 메모 모아보기 리스트
        if let selectedSubGoal = subGoal {
            let sortedDetailGoals = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
            let filteredMemos = sortedDetailGoals.filter { !$0.memo.isEmpty }
            
            if !filteredMemos.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    Text("메모 모아보기")
                        .font(.Pretendard.SemiBold.size18)
                        .padding(.leading, 4)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredMemos, id: \.id) { detailGoal in
                                HStack(spacing: 14) {
                                    let randomFace = ["Face1", "Face2", "Face3"].randomElement() ?? "Face1"
                                    Image(randomFace) // 랜덤 아이콘
                                        .scaledToFit()
                                        .frame(width: 33/393 * UIScreen.main.bounds.width)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(detailGoal.title) // 디테일골 제목
                                            .font(.Pretendard.Bold.size16)
                                            .foregroundStyle(Color.my2D5C2D)
                                        
                                        Text(detailGoal.memo) // 디테일골 메모
                                            .font(.Pretendard.Medium.size14)
                                            .foregroundStyle(Color.my657665)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.myF0E8DF, lineWidth: 1)
                                )
                            }
                        }
                    }
                }
            } else {
                HStack(){
                    Text("메모 모아보기")
                        .font(.Pretendard.SemiBold.size18)
                        .padding(.leading, 20)
                        .padding(.bottom, 53)
                    Spacer()
                }
                Image("Turtle_Empty")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 149/852 * UIScreen.main.bounds.height)
                Text("아직 메모가 없어요!")
                    .font(.Pretendard.SemiBold.size16)
                    .padding(.vertical, 10)
                Text("루틴에 대한 메모를 작성하고 확인해 보세요.")
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(Color.my878787)
            }
        }
    }
}
