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
    @State private var cloverState: Int = 0
    
    private let viewModel = MandalartViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []), deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: []))
    private let titleLimit = 15 // 제목 글자수 제한
    
    var body: some View {
        VStack {
            Text("나의 목표")
                .font(.Pretendard.SemiBold.size17)
            
            // 핵심 목표 제목 입력란
            ZStack {
                TextField("나의 목표를 입력해주세요", text: $newTitle)
                    .padding()
                    .background(.white)
                    .font(.Pretendard.Medium.size16)
                    .cornerRadius(12)
                    .onChange(of: newTitle) { oldValue, newValue in
                        if newValue.count > titleLimit {
                            newTitle = String(newValue.prefix(titleLimit))
                        }
                    }
                HStack {
                    Spacer()
                    if newTitle != "" {
                        Button(action: {
                            newTitle = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 23, height: 23)
                                .foregroundStyle(Color.myB9B9B9)
                        })
                        .padding(.trailing)
                    }
                }
            }
            .padding(.top, 20/852 * UIScreen.main.bounds.height)
            
            // 글자수 부분
            HStack(spacing: 0) {
                Spacer()
                Text("\(newTitle.count)")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color.my6C6C6C)
                Text("/\(titleLimit)")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color.my6C6C6C.opacity(0.5))
            }
            .padding(.trailing, 10)
            
            Spacer()
            
            // 버튼 영역
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .frame(maxWidth: .infinity)
                        .font(.Pretendard.Medium.size16)
                        .padding()
                        .background(Color.my787880.opacity(0.2))
                        .foregroundStyle(Color.my3C3C43.opacity(0.6))
                        .cornerRadius(12)
                }
                
                Button(action: {
                    if let mainGoal = mainGoal {
                        viewModel.updateMainGoal(mainGoal: mainGoal, modelContext: modelContext, id: mainGoal.id, newTitle: newTitle, cloverState: cloverState)
                    }
                    isPresented = false
                }) {
                    Text("저장")
                        .frame(maxWidth: .infinity)
                        .font(.Pretendard.Medium.size16)
                        .padding()
                        .background(Color.my538F53)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(Color.myF1F1F1)
        .onAppear {
            if let mainGoal = mainGoal {
                newTitle = mainGoal.title
            }
        }
    }
}
