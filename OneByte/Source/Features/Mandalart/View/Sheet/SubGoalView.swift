//
//  SubGoalView.swift
//  OneByte
//
//  Created by 트루디 on 11/27/24.
//

import SwiftUI
import SwiftUI

struct SubGoalView: View {
    @Binding var subGoal: SubGoal?
    @Binding var subNavigation: Bool
    @State private var selectedCategory: String = ""
    @State private var isCustomCategoryActive: Bool = false
    @State private var customCategory: String = ""
    @State private var newTitle: String = ""
    @State private var showAlert: Bool = false
    @State private var isModified: Bool = false
    @State private var showBackAlert: Bool = false
    
    private let titleLimit = 20
    private let categoryLimit = 6
    private let categories = ["건강", "공부", "운동", "경제", "자기계발", "취미 생활", "일상", "집안일"]
    private let customCategoryLimit = 6
    
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 카테고리 선택란
            categorySelectionGrid()
            
            // "기타" 선택 시 입력란
            if isCustomCategoryActive {
                customCategoryView()
            }
            // 작은 목표 입력란
            WritingObject()
            
            Spacer()
            
            if let subGoal = subGoal {
                if subGoal.title != "" {
                    // 삭제 버튼
                    deleteButton()
                        .padding(.bottom)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isModified = false
                    subNavigation = false
                    if let subGoal = subGoal {
                        viewModel.updateSubGoal(
                            subGoal: subGoal,
                            newTitle: newTitle,
                            category: selectedCategory
                        )
                    }
                }, label: {
                    Text("저장")
                        .foregroundStyle((newTitle == "" || isModified == false) ? .myA9C5A3 : .my538F53)
                        .fontWeight((newTitle == "" || isModified == false) ? .regular : .bold)
                })
                .disabled(newTitle == "" || isModified == false)
                // 수정되거나 title 값이 있어야 한다.
            })
        }
        .navigationBarBackButtonHidden()
        .backButtonToolbar {
            if isModified {
                showBackAlert = true
            } else {
                subNavigation = false
            }
        }
        .alert("목표 작성을 중단하시겠습니까?", isPresented: $showBackAlert) {
            Button("나가기", role: .destructive) {
                subNavigation = false
            }
            Button("계속하기", role: .cancel) {}
        } message: {
            Text("이 페이지에서 나가면 작성된 목표가 저장되지 않아요.")
        }
        .navigationTitle("목표 추가하기")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .background(.myFFFAF4)
        .onAppear {
            if let subGoal = subGoal {
                let result = viewModel.initializeSubGoal(
                    subGoal: subGoal,
                    categories: categories
                )
                selectedCategory = result.0
                isCustomCategoryActive = result.1
                newTitle = subGoal.title
            }
        }
    }
}

extension SubGoalView {
    @ViewBuilder
    func categorySelectionGrid() -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("카테고리")
                .font(.Pretendard.SemiBold.size16)
                .padding(.leading, 4)
                .foregroundStyle(Color.my675542)
                .padding(.top)
            // 첫 번째 줄
            HStack(spacing: 8) {
                ForEach(categories[0..<5], id: \.self) { category in
                    categoryButton(category: category)
                }
            }
            
            // 두 번째 줄
            HStack(spacing: 8) {
                ForEach(categories[5..<categories.count], id: \.self) { category in
                    categoryButton(category: category)
                }
                
                // "기타" 버튼
                Button(action: {
                    isCustomCategoryActive = true
                    selectedCategory = ""
                }) {
                    Text("기타")
                        .padding(.vertical, 8)
                        .padding(.horizontal, 13)
                        .background(isCustomCategoryActive ? .my7FC77F : .clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(isCustomCategoryActive ? .my599859 : .myCFCFCF, lineWidth: 1)
                        )
                        .foregroundStyle(isCustomCategoryActive ? .white : .black.opacity(0.6))
                        .cornerRadius(22)
                }
            }
        }
    }
    
    // MARK: 카테고리 선택 버튼
    @ViewBuilder
    func categoryButton(category: String) -> some View {
        Button(action: {
            selectedCategory = category
            isCustomCategoryActive = false
            if let subGoal = subGoal {
                if subGoal.category != selectedCategory {
                    isModified = true
                } else {
                    isModified = false
                }
            }
        }) {
            Text(category)
                .font(selectedCategory == category ? .Pretendard.SemiBold.size16 : .Pretendard.Medium.size16)
                .padding(.vertical, 8)
                .padding(.horizontal, 13)
                .background(selectedCategory == category ? .my7FC77F : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(selectedCategory == category ? .my599859 : .myCFCFCF, lineWidth: 1)
                )
                .foregroundStyle(selectedCategory == category ? .white : .black.opacity(0.6))
                .cornerRadius(22)
        }
    }
    
    // MARK: 커스텀 카테고리 텍스트 필드
    @ViewBuilder
    func customCategoryView() -> some View {
        ZStack {
            TextField("진로, 관계, 감정 등", text: $customCategory)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.myF0E8DF, lineWidth: 1)
                )
                .onChange(of: customCategory) { oldValue, newValue in
                    if newValue != subGoal?.category {
                        isModified = true
                    }
                    if newValue.count > categoryLimit {
                        customCategory = String(newValue.prefix(categoryLimit))
                    }
                }
            
            HStack {
                Spacer()
                if customCategory != "" {
                    Button(action: {
                        customCategory = ""
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
        .padding(.top, 6)
        
        HStack(spacing: 0) {
            Spacer()
            Text("\(customCategory.count)")
                .font(.Pretendard.Medium.size12)
                .foregroundStyle(Color.my6C6C6C)
            Text("/\(categoryLimit)")
                .font(.Pretendard.Medium.size12)
                .foregroundStyle(Color.my6C6C6C.opacity(0.5))
        }
        .padding(.trailing, 10)
        .padding(.top, -2)
    }
    
    // MARK: 작은 목표 이름 텍스트 필드
    @ViewBuilder
    func WritingObject() -> some View {
        Text("작은 목표 이름")
            .font(.Pretendard.SemiBold.size16)
            .padding(.leading, 4)
            .foregroundStyle(Color.my675542)
            .padding(.top, 18)
        
        // 작은 목표 이름 입력란
        ZStack {
            TextField("2kg 감량하기, 규칙적인 수면패턴 갖기 등", text: $newTitle)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.myF0E8DF, lineWidth: 1)
                )
                .onChange(of: newTitle) { oldValue, newValue in
                    if newValue != subGoal?.title {
                        isModified = true
                        if newValue.count > titleLimit {
                            newTitle = String(newValue.prefix(titleLimit))
                        }
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
        .padding(.top, -2)
    }
    
    // MARK:  삭제 버튼
    @ViewBuilder
    func deleteButton() -> some View {
        Button(action: {
            showAlert = true
        }, label: {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundStyle(.red)
                Text("목표 삭제하기")
                    .font(.Pretendard.Medium.size16)
                    .foregroundStyle(.red)
            }
            .padding(.vertical, 14.5)
            .frame(maxWidth: .infinity)
            .background(Color.myF0E8DF)
            .cornerRadius(12)
        })
        .alert("목표를 삭제하시겠습니까?", isPresented: $showAlert) {
            Button("삭제하기", role: .destructive) {
                if let subGoal = subGoal {
                    viewModel.deleteSubDetailGoals(subGoal: subGoal, days: ["월", "화", "수", "목", "금", "토", "일"])
                }
                subNavigation = false
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("목표를 삭제하면 목표에 해당하는 루틴들도 일괄 삭제돼요.")
        }
    }
    
}
