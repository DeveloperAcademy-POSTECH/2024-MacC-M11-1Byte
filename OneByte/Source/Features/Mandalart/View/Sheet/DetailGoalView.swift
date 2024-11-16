//
//  DetailGoalSheetView.swift
//  OneByte
//
//  Created by 트루디 on 11/12/24.
//

import SwiftUI

struct DetailGoalView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
    private let viewModel = MandalartViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []), deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: []))
    @Environment(\.managedObjectContext) private var context
    @Binding var detailGoal: DetailGoal?
    @State private var newTitle: String = ""
    @State private var newMemo: String = ""
    @State private var isAchieved: Bool = false
    @State private var isEditing: Bool = false
    
    private let titleLimit = 20 // 제목 글자수 제한
    private let memoLimit = 150 // 메모 글자수 제한
    
    var body: some View {
            VStack {
                Text("할 일")
                    .font(.Pretendard.SemiBold.size17)
                    .padding(.top, 22/852 * UIScreen.main.bounds.height)
                
                // 할 일 제목 입력란
                ZStack {
                    TextField("할 일을 입력해주세요", text: $newTitle)
                        .padding()
                        .background(.white)
                        .cornerRadius(8)
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
                
                // 메모 입력란
                ZStack{
                    VStack {
                        TextField("메모를 입력해주세요", text: $newMemo, axis: .vertical)
                            .scrollContentBackground(.hidden)
                            .padding()
                            .background(.clear)
                            .onChange(of: newMemo) { oldValue, newValue in
                                if newValue.count > memoLimit {
                                    newMemo = String(newValue.prefix(memoLimit))
                                }
                            }
                        Spacer()
                    }
                    
                    // 글자수 부분
                    VStack(spacing: 0){
                        Spacer()
                        HStack(spacing: 0){
                            Spacer()
                            Text("\(newMemo.count)")
                                .font(.Pretendard.Medium.size12)
                                .foregroundStyle(Color.my6C6C6C)
                            Text("/\(memoLimit)")
                                .font(.Pretendard.Medium.size12)
                                .foregroundStyle(Color.my6C6C6C.opacity(0.5))
                        }
                        .padding([.trailing, .bottom], 10)
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 133/852 * UIScreen.main.bounds.height)
                .background(.white)
                .cornerRadius(8)
                
                Spacer()
                
                // 버튼 영역
                HStack {
                    Button(action: {
                        //                    isPresented = false
                    }) {
                        Text("취소")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.my787880.opacity(0.2))
                            .foregroundStyle(Color.my3C3C43.opacity(0.6))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        if let detailGoal = detailGoal {
                            viewModel.updateDetailGoal(detailGoal: detailGoal, modelContext: modelContext, newTitle: newTitle, newMemo: newMemo, isAchieved: isAchieved)
                        }
                        //                    isPresented = false
                    }) {
                        Text("저장")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.my538F53)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                }.padding(.bottom, 33/852 * UIScreen.main.bounds.height)
            }
        .navigationBarBackButtonHidden()
        .backButtonToolbar { dismiss() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isEditing.toggle()
                }, label: {
                    Text(isEditing ? "저장" : "편집")
                })
            })
        }
        .padding(.horizontal)
        .background(Color.myF1F1F1)
        .onAppear {
            if let detailGoal = detailGoal {
                newTitle = detailGoal.title
                newMemo = detailGoal.memo.isEmpty ? "" : detailGoal.memo
                isAchieved = detailGoal.isAchieved
            }
        }
    }
}

