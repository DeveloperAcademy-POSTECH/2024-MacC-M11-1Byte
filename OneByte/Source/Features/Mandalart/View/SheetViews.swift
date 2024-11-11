//
//  SheetViews.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import SwiftUI
import SwiftData

struct MainGoalsheetView: View {
    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
    @Environment(\.managedObjectContext) private var context
    @Binding var mainGoal: MainGoal? // 옵셔널로 변경
    @Binding var isPresented: Bool
    @State private var newTitle: String = ""
    @State private var newMemo: String = ""
    @State private var newGoalYear: String = ""
    private let viewModel = CUTestViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    var body: some View {
        VStack(spacing: 20) {
            Text("최종 목표")
                .font(.headline)
            
            // 최종 목표 제목 입력란
            TextField("최종 목표를 입력해주세요", text: $newTitle)
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
            // 연도 입력
            TextField("연도 입력", text: $newGoalYear)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .keyboardType(.numberPad)
                .overlay(
                    HStack {
                        Spacer()
                        Text("\(newGoalYear.count)/4")
                            .padding(.trailing, 8)
                            .foregroundColor(.gray)
                    }
                )
            
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
                    if let mainGoal = mainGoal, let goalYear = Int(newGoalYear) {
                        viewModel.updateMainGoal(mainGoal: mainGoal, modelContext: modelContext, id: mainGoal.id, newTitle: newTitle, newGoalYear: goalYear)
                    }
                    isPresented = false
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
            if let mainGoal = mainGoal {
                newTitle = mainGoal.title
                newGoalYear = String(mainGoal.goalYear)
            }
        }
    }
}

struct SubGoalsheetView: View {
    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
    @Environment(\.managedObjectContext) private var context
    @Binding var subGoal: SubGoal? // 옵셔널로 변경
    @Binding var isPresented: Bool
    @State private var newTitle: String = ""
    @State private var newMemo: String = ""
    private let viewModel = CUTestViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
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
                        viewModel.updateSubGoal(subGoal: subGoal, modelContext: modelContext, newTitle: newTitle, newMemo: newMemo)
                    }
                    isPresented = false
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
            if let subGoal = subGoal {
                newTitle = subGoal.title
                newMemo = subGoal.memo.isEmpty ? "메모를 입력해 주세요." : subGoal.memo
            }
        }
    }
}

struct DetailGoalsheetView: View {
    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
    private let viewModel = CUTestViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
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
                        viewModel.updateDetailGoal(detailGoal: detailGoal, modelContext: modelContext, newTitle: newTitle, newMemo: newMemo, isAchieved: isAchieved)
                    }
                    isPresented = false
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
}
