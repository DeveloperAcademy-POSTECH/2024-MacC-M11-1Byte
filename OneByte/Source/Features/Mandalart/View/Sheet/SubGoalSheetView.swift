//
//  SubGoalSheetView.swift
//  OneByte
//
//  Created by 트루디 on 11/12/24.
//

import SwiftUI

struct SubGoalsheetView: View {
    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
    @Environment(\.managedObjectContext) private var context
    @Binding var subGoal: SubGoal? // 옵셔널로 변경
    @Binding var isPresented: Bool
    @State private var newTitle: String = ""
    @State private var leafState: Int = 0
    private let viewModel = MandalartViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []), deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: []))
    
    private let titleLimit = 20 // 제목 글자수 제한
    
    var body: some View {
        VStack {
            Text("하위 목표")
                .font(.Pretendard.SemiBold.size17)
                .padding(.top, 22/852 * UIScreen.main.bounds.height)
            
            // 하위 목표 제목 입력란
            ZStack {
                TextField("하위 목표를 입력해주세요", text: $newTitle)
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
                    if let subGoal = subGoal {
                        viewModel.updateSubGoal(
                            subGoal: subGoal,
                            modelContext: modelContext,
                            newTitle: newTitle,
                            leafState: leafState
                        )
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
        //        .padding(.vertical, 50)
        .background(Color.myF1F1F1)
        .onAppear {
            if let subGoal = subGoal {
                newTitle = subGoal.title
            }
        }
    }
}
