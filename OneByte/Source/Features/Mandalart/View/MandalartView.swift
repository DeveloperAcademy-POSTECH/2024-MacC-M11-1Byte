//
//  ObjectiveView.swift
//  OneByte
//
//  Created by 트루디 on 11/03/24.
//
//import SwiftUI
//import SwiftData
//// MARK: - MandalartView
//struct MandalartView: View {
//    let mainGoal: MainGoal = {
//        let subGoalTitles = [
//            "서브골1", "서브골2", "서브골3",
//            "서브골4", "서브골5", "서브골6",
//            "서브골7", "서브골8"
//        ]
//        
//        let subGoals = subGoalTitles.map { title in
//            let detailGoals = (1...8).map { _ in DetailGoal(backingData: <#any BackingData<DetailGoal>#>) }
//            return SubGoal()
//        }
//        
//        return MainGoal()
//    }()
//    
//    let outerColumns = Array(repeating: GridItem(.flexible()), count: 3)
//    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
//    
//    var body: some View {
//        NavigationStack {
//            LazyVGrid(columns: outerColumns, spacing: 10) {
//                ForEach(0..<9, id: \.self) { outerIndex in
//                    if outerIndex == 4 {
//                        NavigationLink(destination: MainGoalDetailGridView(mainGoal: mainGoal)) {
//                            LazyVGrid(columns: innerColumns, spacing: 5) {
//                                ForEach(0..<9, id: \.self) { innerIndex in
//                                    if innerIndex == 4 {
//                                        Text(mainGoal.title)
//                                            .font(.system(size: 12))
//                                            .frame(width: 40, height: 40)
//                                            .background(Color.blue)
//                                            .foregroundColor(.white)
//                                            .cornerRadius(8)
//                                    } else {
//                                        let subGoalIndex = innerIndex < 4 ? innerIndex : innerIndex - 1
//                                        Text(mainGoal.subGoals[subGoalIndex].title)
//                                            .font(.system(size: 7))
//                                            .frame(width: 40, height: 40)
//                                            .background(Color.green)
//                                            .foregroundColor(.white)
//                                            .cornerRadius(8)
//                                    }
//                                }
//                            }
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                        }
//                    } else {
//                        NavigationLink(destination: DetailGridView(subGoal: mainGoal.subGoals[outerIndex < 4 ? outerIndex : outerIndex - 1])) {
//                            LazyVGrid(columns: innerColumns, spacing: 5) {
//                                ForEach(0..<9, id: \.self) { innerIndex in
//                                    if innerIndex == 4 {
//                                        let subGoalIndex = outerIndex < 4 ? outerIndex : outerIndex - 1
//                                        Text(mainGoal.subGoals[subGoalIndex].title)
//                                            .font(.system(size: 7))
//                                            .frame(width: 40, height: 40)
//                                            .background(Color.green)
//                                            .foregroundColor(.white)
//                                            .cornerRadius(8)
//                                    } else {
//                                        let subGoalIndex = outerIndex < 4 ? outerIndex : outerIndex - 1
//                                        let detailGoalIndex = innerIndex < 4 ? innerIndex : innerIndex - 1
//                                        if detailGoalIndex < mainGoal.subGoals[subGoalIndex].detailGoals.count {
//                                            Text(mainGoal.subGoals[subGoalIndex].detailGoals[detailGoalIndex].title)
//                                                .font(.system(size: 7))
//                                                .frame(width: 40, height: 40)
//                                                .background(Color.yellow)
//                                                .foregroundColor(.black)
//                                                .cornerRadius(8)
//                                        }
//                                    }
//                                }
//                            }
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(8)
//                        }
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//// MainGoal의 SubGoals를 표시하는 뷰
//struct MainGoalDetailGridView: View {
//    let mainGoal: MainGoal
//    @State private var selectedSubGoal: SubGoal?
//    
//    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
//
//    var body: some View {
//        LazyVGrid(columns: innerColumns, spacing: 10) {
//            ForEach(0..<9, id: \.self) { index in
//                if index == 4 {
//                    Text(mainGoal.title)
//                        .font(.system(size: 12))
//                        .frame(width: 60, height: 60)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                } else {
//                    let subGoalIndex = index < 4 ? index : index - 1
//                    if subGoalIndex < mainGoal.subGoals.count {
//                        Button(action: {
//                            selectedSubGoal = mainGoal.subGoals[subGoalIndex]
//                        }) {
//                            Text(mainGoal.subGoals[subGoalIndex].title)
//                                .font(.system(size: 10))
//                                .frame(width: 60, height: 60)
//                                .background(Color.green)
//                                .foregroundColor(.white)
//                                .cornerRadius(8)
//                        }
//                        .sheet(item: $selectedSubGoal) { subGoal in
//                            SubGoalDetailView(subGoal: subGoal)
//                        }
//                    }
//                }
//            }
//        }
//        .padding()
//        .navigationTitle(mainGoal.title)
//    }
//}
//
//// SubGoal과 관련된 DetailGoals를 표시하는 뷰
//struct DetailGridView: View {
//    let subGoal: SubGoal
//    
//    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
//
//    var body: some View {
//        LazyVGrid(columns: innerColumns, spacing: 10) {
//            ForEach(0..<9, id: \.self) { index in
//                if index == 4 {
//                    Text(subGoal.title)
//                        .font(.system(size: 12))
//                        .frame(width: 60, height: 60)
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(8)
//                } else {
//                    let detailGoalIndex = index < 4 ? index : index - 1
//                    if detailGoalIndex < subGoal.detailGoals.count {
//                        Text(subGoal.detailGoals[detailGoalIndex].title)
//                            .font(.system(size: 10))
//                            .frame(width: 60, height: 60)
//                            .background(Color.yellow)
//                            .foregroundColor(.black)
//                            .cornerRadius(8)
//                    }
//                }
//            }
//        }
//        .padding()
//        .navigationTitle(subGoal.title)
//    }
//}
//
//// SubGoal의 세부 사항을 표시하는 뷰
//
//// SubGoal의 세부 사항을 표시하는 뷰
//struct SubGoalDetailView: View {
//    @Environment(\.modelContext) private var modelContext  // 모델 컨텍스트를 가져옴
//    @State var subGoal: SubGoal
//
//    var body: some View {
//        VStack {
//            Text(subGoal.title)
//                .font(.title)
//                .padding()
//            
//            TextField("테스크를 입력해 주세요.", text: $subGoal.title)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//            
////            TextField("메모를 입력해주세요", text: $subGoal.subGoalMemo)
////                .padding()
////                .background(Color(.systemGray6))
////                .cornerRadius(8)
//
//            Button(action: {
//                updateSubGoal()  // 버튼을 눌렀을 때 업데이트 함수 호출
//            }, label: {
//                Text("저장")  // 버튼 레이블
//            })
//            .padding()
//        }
//        .padding()
//    }
//
//    private func updateSubGoal() {
//        // 여기서 subGoal을 데이터베이스에 업데이트
//        do {
//            try modelContext.save()  // 변경 사항 저장
//        } catch {
//            // 오류 처리
//            print("오류 발생: \(error.localizedDescription)")
//        }
//    }
//}
