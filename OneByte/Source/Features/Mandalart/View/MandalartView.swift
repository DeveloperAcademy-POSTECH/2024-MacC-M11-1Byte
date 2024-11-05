//
//  ObjectiveView.swift
//  OneByte
//
//  Created by 트루디 on 11/03/24.
//
import SwiftUI
import SwiftData

struct MandalartView: View {
    // 저장된 MainGoal 데이터를 불러옴
    @Query private var mainGoals: [MainGoal]
    
    let outerColumns = Array(repeating: GridItem(.flexible()), count: 3) // 외부 3x3 그리드
    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3) // 내부 3x3 그리드
    
    @State var isPresented = false
    @State private var selectedSubGoal: SubGoal?
    
    var body: some View {
        NavigationStack {
            if let mainGoal = mainGoals.first {
                LazyVGrid(columns: outerColumns, spacing: 10) {
                    ForEach(0..<9, id: \.self) { outerIndex in
                        if outerIndex == 4 {
                            // 외부 그리드의 중앙 셀: MainGoal과 SubGoals만 표시, 클릭 시 NavigationLink로 이동
                            NavigationLink(destination: MainGoalDetailGridView(mainGoal: mainGoal)) {
                                LazyVGrid(columns: innerColumns, spacing: 5) {
                                    ForEach(0..<9, id: \.self) { innerIndex in
                                        if innerIndex == 4 {
                                            // 내부 그리드 중앙에 MainGoal 표시
                                            Text(mainGoal.title)
                                                .font(.system(size: 12))
                                                .frame(width: 40, height: 40)
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(8)
                                        } else {
                                            // 나머지 셀에 SubGoals 표시
                                            let subGoalIndex = innerIndex < 4 ? innerIndex : innerIndex - 1
                                            if subGoalIndex < mainGoal.subGoals.count {
                                                Text(mainGoal.subGoals[subGoalIndex].title)
                                                    .font(.system(size: 7))
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.green)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(8)
                                                    .sheet(isPresented: $isPresented) {
                                                        if let subGoal = selectedSubGoal {
                                                            SubGoalsheetView(subGoal: Binding(get: { subGoal }, set: { selectedSubGoal = $0 }), isPresented: $isPresented)
                                                        }
                                                    }
                                                
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                            }
                        } else {
                            // 외부 그리드의 나머지 셀: SubGoal과 DetailGoals 표시
                            let subGoalIndex = outerIndex < 4 ? outerIndex : outerIndex - 1
                            if subGoalIndex < mainGoal.subGoals.count {
                                NavigationLink(destination: DetailGridView(subGoal: mainGoal.subGoals[subGoalIndex])) {
                                    LazyVGrid(columns: innerColumns, spacing: 5) {
                                        ForEach(0..<9, id: \.self) { innerIndex in
                                            if innerIndex == 4 {
                                                // 내부 그리드의 가운데 셀에 각 SubGoal 표시
                                                Text(mainGoal.subGoals[subGoalIndex].title)
                                                    .font(.system(size: 7))
                                                    .frame(width: 40, height: 40)
                                                    .background(Color.green)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(8)
                                            } else {
                                                // 나머지 셀에 해당 SubGoal의 DetailGoals 표시
                                                let detailGoalIndex = innerIndex < 4 ? innerIndex : innerIndex - 1
                                                if detailGoalIndex < mainGoal.subGoals[subGoalIndex].detailGoals.count {
                                                    Text(mainGoal.subGoals[subGoalIndex].detailGoals[detailGoalIndex].title)
                                                        .font(.system(size: 7))
                                                        .frame(width: 40, height: 40)
                                                        .background(Color.yellow)
                                                        .foregroundColor(.black)
                                                        .cornerRadius(8)
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                .padding()
            } else {
                Text("MainGoal 데이터를 찾을 수 없습니다.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

// 메인 목표(MainGoal)와 관련된 SubGoals를 3x3 그리드로 표시하는 뷰
struct MainGoalDetailGridView: View {
    let mainGoal: MainGoal // 선택된 MainGoal
    
    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: innerColumns, spacing: 10) {
            ForEach(0..<9, id: \.self) { index in
                if index == 4 {
                    // 가운데 셀에 MainGoal 제목 표시
                    Text(mainGoal.title)
                        .font(.system(size: 12))
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                } else {
                    // 나머지 셀에 SubGoals 표시
                    let subGoalIndex = index < 4 ? index : index - 1
                    if subGoalIndex < mainGoal.subGoals.count {
                        Text(mainGoal.subGoals[subGoalIndex].title)
                            .font(.system(size: 10))
                            .frame(width: 60, height: 60)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .navigationTitle(mainGoal.title)
    }
}

// 클릭된 셀의 SubGoal 및 관련된 DetailGoals만 3x3 그리드로 표시하는 뷰
struct DetailGridView: View {
    let subGoal: SubGoal // 선택된 SubGoal
    
    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        LazyVGrid(columns: innerColumns, spacing: 10) {
            ForEach(0..<9, id: \.self) { index in
                if index == 4 {
                    // 가운데 셀에 SubGoal 제목 표시
                    Text(subGoal.title)
                        .font(.system(size: 12))
                        .frame(width: 60, height: 60)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                } else {
                    // 나머지 셀에는 DetailGoals 표시
                    let detailGoalIndex = index < 4 ? index : index - 1
                    if detailGoalIndex < subGoal.detailGoals.count {
                        Text(subGoal.detailGoals[detailGoalIndex].title)
                            .font(.system(size: 10))
                            .frame(width: 60, height: 60)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .navigationTitle(subGoal.title)
    }
}

struct SubGoalsheetView: View {
    @Environment(\.managedObjectContext) private var context
    @Binding var subGoal: SubGoal
    @Binding var isPresented: Bool
    @State private var newTitle: String = ""
    @State private var newMemo: String = ""
    var body: some View {
        VStack(spacing: 20) {
            Text("하위 목표")
                .font(.headline)
            
            // 하위 목표 제목 입력란
            TextField("하위 목표를 입력해주세요", text: $newTitle)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Spacer()
                        Text("\(newTitle.count)/15")
                            .padding(.trailing, 8)
                            .foregroundColor(.gray)
                    }
                )
            
            // 메모 입력란
            TextEditor(text: $newMemo)
                .frame(height: 100)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("\(subGoal.memo.count)/150")
                                .padding(.trailing, 8)
                                .foregroundColor(.gray)
                        }
                    }
                )
                .onAppear {
                    if subGoal.memo.isEmpty {
                        subGoal.memo = "메모를 입력해 주세요."
                    }
                }
            
            // 버튼 영역
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Button(action: {
                    //                    subGoal.title = subGoal.title
                    updateSubGoalTitle()
                    
                }) {
                    Text("저장")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .onAppear {
            // 초기 상태 설정
            newTitle = subGoal.title
            newMemo = subGoal.memo.isEmpty ? "메모를 입력해 주세요." : subGoal.memo
        }
    }
    
    private func updateSubGoalTitle() {
        subGoal.title = newTitle // 제목 업데이트
        subGoal.memo = newMemo
        isPresented = false
    }
}
