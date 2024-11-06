//
//  ObjectiveView.swift
//  OneByte
//
//  Created by 트루디 on 11/03/24.
//
import SwiftUI
import SwiftData

struct MandalartView: View {
    @Query private var mainGoals: [MainGoal]
    @State var isPresented = false
    @State private var selectedSubGoal: SubGoal?
    
    var body: some View {
        NavigationStack {
            if let mainGoal = mainGoals.first {
                OuterGridView(isPresented: $isPresented, selectedSubGoal: $selectedSubGoal, mainGoal: mainGoal)
            } else {
                Text("MainGoal 데이터를 찾을 수 없습니다.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

// MARK: 첫화면 -  전체 81개짜리
struct OuterGridView: View {
    @Binding var isPresented: Bool
    @Binding var selectedSubGoal: SubGoal?
    
    let mainGoal: MainGoal
    private let outerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        let sortedSubGoals = mainGoal.subGoals.sorted(by: { $0.id < $1.id }) // 정렬된 SubGoals 배열
        
        LazyVGrid(columns: outerColumns, spacing: 10) {
            ForEach(0..<9, id: \.self) { index in
                if index == 4{
                    MainGoalCell(mainGoal: mainGoal, isPresented: $isPresented) // 가운데는 메인골-서브골
                } else {
                    let subGoalIndex = index < 4 ? index : index - 1 // 중앙 셀을 제외하고 인덱스 조정
                    if subGoalIndex < mainGoal.subGoals.count {
                        let subGoal = sortedSubGoals[subGoalIndex]
                        // 메인골-서브골을 둘러싸는 서브골-디테일골뷰
                        SubGoalCell(subGoal: subGoal, isPresented: $isPresented, selectedSubGoal: $selectedSubGoal)
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: 첫화면 - 9개 메인골-서브골
struct MainGoalCell: View {
    let mainGoal: MainGoal
    @Binding var isPresented: Bool
    
    private let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        // 섭골 아이디로 정렬
        let sortedSubGoals = mainGoal.subGoals.sorted(by: { $0.id < $1.id })
        
        NavigationLink(destination: MainGoalDetailGridView(mainGoal: mainGoal, isPresented: $isPresented)) {
            LazyVGrid(columns: innerColumns, spacing: 5) {
                ForEach(0..<9, id: \.self) { innerIndex in
                    if innerIndex == 4 {
                        // 메인골 제목 표시
                        Text(mainGoal.title)
                            .modifier(MandalartButtonModifier(color: Color.blue))
                    } else {
                        let subGoalIndex = innerIndex < 4 ? innerIndex : innerIndex - 1
                        
                        if subGoalIndex < sortedSubGoals.count {
                            let subGoal = sortedSubGoals[subGoalIndex]
                            Text(subGoal.title)
                                .modifier(MandalartButtonModifier(color: Color.orange))
                        }
                    }
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}

// MARK: 첫화면 - 9개 서브골-디테일골들
struct SubGoalCell: View {
    let subGoal: SubGoal
    @Binding var isPresented: Bool
    @Binding var selectedSubGoal: SubGoal?
    
    private let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        // 디테일골을 id에 따라 정렬
        let detailGoalsSorted = subGoal.detailGoals.sorted(by: { $0.id < $1.id })
        
        NavigationLink(destination: DetailGridView(subGoal: subGoal, isPresented: $isPresented)) {
            LazyVGrid(columns: innerColumns, spacing: 5) {
                ForEach(0..<9, id: \.self) { innerIndex in
                    if innerIndex == 4 {
                        // 서브골 제목 표시
                        Text(subGoal.title)
                            .modifier(MandalartButtonModifier(color: Color.orange)) // 첫화면 중앙 서브골
                    } else {
                        // 디테일골 인덱스 계산
                        let detailGoalIndex = innerIndex < 4 ? innerIndex : innerIndex - 1
                        // 디테일골의 개수 확인 후 표시
                        if detailGoalIndex < detailGoalsSorted.count {
                            let detailGoal = detailGoalsSorted[detailGoalIndex]
                            Text(detailGoal.title)
                                .modifier(MandalartButtonModifier(color: Color.green)) // 첫화면 디테일골
                        }
                    }
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}



// MARK: 두번째 화면 - 메인 목표(MainGoal)와 관련된 SubGoals를 3x3 그리드로 표시하는 뷰
struct MainGoalDetailGridView: View {
    let mainGoal: MainGoal // 선택된 MainGoal
    @Binding var isPresented: Bool
    @State private var selectedSubGoal: SubGoal?
    
    let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        // 나머지 셀에 정렬된 SubGoals 표시
        let sortedSubGoals = mainGoal.subGoals.sorted(by: { $0.id < $1.id })
        
        LazyVGrid(columns: innerColumns, spacing: 10) {
            ForEach(0..<9, id: \.self) { index in
                if index == 4 {
                    // 가운데 셀에 MainGoal 제목 표시
                    Text(mainGoal.title)
                        .modifier(NextMandalartButtonModifier(color: Color.blue))
                    
                } else {
                    let subGoalIndex = index < 4 ? index : index - 1
                    
                    if subGoalIndex < sortedSubGoals.count {
                        Button(action: {
                            selectedSubGoal = sortedSubGoals[subGoalIndex] // 클릭된 SubGoal 저장
                            isPresented = true
                        }, label: {
                            Text(sortedSubGoals[subGoalIndex].title)
                                .modifier(NextMandalartButtonModifier(color: Color.orange)) // 서브골들
                        })
                        .sheet(isPresented: $isPresented) {
                            if selectedSubGoal != nil {
                                SubGoalsheetView(subGoal: $selectedSubGoal, isPresented: $isPresented)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(mainGoal.title)
    }
}



// MARK: 두번째 화면 - 클릭된 셀의 SubGoal 및 관련된 DetailGoals만 3x3 그리드로 표시하는 뷰
struct DetailGridView: View {
    let subGoal: SubGoal
    @Binding var isPresented: Bool
    @State private var selectedDetailGoal: DetailGoal?
    private let innerColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        // 디테일골을 id 값에 따라 정렬
        let sortedDetailGoals = subGoal.detailGoals.sorted(by: { $0.id < $1.id })
        
        LazyVGrid(columns: innerColumns, spacing: 10) {
            ForEach(0..<9, id: \.self) { index in
                if index == 4 {
                    // 네 번째 셀에 서브골 제목 표시
                    Text(subGoal.title)
                        .modifier(NextMandalartButtonModifier(color: Color.orange))
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
        .navigationTitle(subGoal.title)
    }
}


struct SubGoalsheetView: View {
    @Environment(\.managedObjectContext) private var context
    @Binding var subGoal: SubGoal? // 옵셔널로 변경
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
                            Text("\(newMemo.count)/150")
                                .padding(.trailing, 8)
                                .foregroundColor(.gray)
                        }
                    }
                )
                .onAppear {
                    if let subGoal = subGoal {
                        newTitle = subGoal.title
                        newMemo = subGoal.memo.isEmpty ? "메모를 입력해 주세요." : subGoal.memo
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
                    if let subGoal = subGoal {
                        updateSubGoalTitle(for: subGoal)
                    }
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
    }
    
    private func updateSubGoalTitle(for subGoal: SubGoal) {
        subGoal.title = newTitle // 제목 업데이트
        subGoal.memo = newMemo
        isPresented = false
    }
}
struct DetailGoalsheetView: View {
    @Environment(\.managedObjectContext) private var context
    @Binding var detailGoal: DetailGoal?
    //    @Binding var subGoal: SubGoal? // 옵셔널로 변경
    @Binding var isPresented: Bool
    @State private var newTitle: String = ""
    @State private var newMemo: String = ""
    @State private var isAchieved: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("할 일")
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
                            Text("\(newMemo.count)/150")
                                .padding(.trailing, 8)
                                .foregroundColor(.gray)
                        }
                    }
                )
                .onAppear {
                    if let detailGoal = detailGoal {
                        newTitle = detailGoal.title
                        newMemo = detailGoal.memo.isEmpty ? "메모를 입력해 주세요." : detailGoal.memo
                        isAchieved = detailGoal.isAchieved
                    }
                }
            
            // 성취완료
            // 성취 완료 토글 스위치
            Toggle(isAchieved ? "성취 완료" : "미완료", isOn: $isAchieved)
                .padding()
            
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
                    if let detailGoal = detailGoal {
                        updateDetailGoalTitle(for: detailGoal)
                    }
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
    }
    
    private func updateDetailGoalTitle(for detailGoal: DetailGoal) {
        detailGoal.title = newTitle // 제목 업데이트
        detailGoal.memo = newMemo
        detailGoal.isAchieved = isAchieved
        isPresented = false
    }
}
