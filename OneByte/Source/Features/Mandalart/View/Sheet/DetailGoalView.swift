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
    private let memoLimit = 100 // 메모 글자수 제한
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28/852 * UIScreen.main.bounds.height) {
            
            // 타이틀 입력란
            detailGaolTitle()
            // 메모 입력란
            DetailGoalMemo()
            if isEditing {
                
            } else {
                // 저장 모드일 경우 보일 현재 달성횟수
                achieveCount()
            }
            
            Spacer()
            // 삭제 버튼 영역
            VStack(spacing: 8) {
                Text("리마인드 알림")
                    .font(.Pretendard.Medium.size14)
                    
                Text("할 일을 시작할 때 받을 알림을 설정해주세요.")
                    .foregroundStyle(Color.myB4A99D)
//                    .padding(.top, -20)
            }
            .padding(.leading, 4)
            Spacer()
            
            
        }
        .navigationBarBackButtonHidden()
        .backButtonToolbar { dismiss() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isEditing.toggle()
                }, label: {
                    Text(isEditing ? "저장" : "편집")
                        .foregroundStyle(Color.my538F53)
                })
            })
        }
        .padding(.horizontal, 20)
        .background(Color.myFFFAF4)
        .onAppear {
            if let detailGoal = detailGoal {
                newTitle = detailGoal.title
                newMemo = detailGoal.memo.isEmpty ? "" : detailGoal.memo
                isAchieved = detailGoal.isAchieved
            }
        }
    }
}

extension DetailGoalView {
    @ViewBuilder
    func detailGaolTitle() -> some View {
        Text("할 일")
            .font(.Pretendard.SemiBold.size16)
            .padding(.top, 22/852 * UIScreen.main.bounds.height)
            .padding(.leading, 4)
        
        // 할 일 제목 입력란
        ZStack {
            TextField("할 일을 입력해주세요.", text: $newTitle)
                .padding()
                .background(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.myF0E8DF, lineWidth: 1)
                )
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
        .padding(.top, -20)
        
        if isEditing {
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
            .padding(.top, -20)
        }
    }
    
    @ViewBuilder
    func DetailGoalMemo() -> some  View {
        Text("메모")
            .font(.Pretendard.SemiBold.size16)
            .padding(.leading, 4)
        
        ZStack {
            VStack(alignment: .leading) {
                TextField("할 일에 대한 메모를 자유롭게 작성해보세요.", text: $newMemo, axis: .vertical)
                    .scrollContentBackground(.hidden)
                    .padding()
                    .background(.clear)
                    .cornerRadius(12)
                    .onChange(of: newMemo) { oldValue, newValue in
                        if newValue.count > memoLimit {
                            newMemo = String(newValue.prefix(memoLimit))
                        }
                    }
                Spacer()
            }
            
            if isEditing {
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
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 133/852 * UIScreen.main.bounds.height)
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myF0E8DF, lineWidth: 1)
        )
        .padding(.top, -20)
    }
    
    @ViewBuilder
    func achieveCount() -> some View {
        HStack(spacing: 0) {
            Text("현재 달성 횟수")
                .font(.Pretendard.SemiBold.size16)
            Spacer()
            Text("2/5")
                .font(.Pretendard.Medium.size16)
                .foregroundStyle(Color.my636363)
        }
        .padding()
        .background(.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myF0E8DF, lineWidth: 1)
        )
    }
}
