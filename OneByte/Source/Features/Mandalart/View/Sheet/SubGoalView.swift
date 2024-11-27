//
//  SubGoalView.swift
//  OneByte
//
//  Created by 트루디 on 11/27/24.
//

import SwiftUI
import SwiftUI

struct SubGoalView: View {
    @State private var selectedCategory: String = ""
    @State private var isCustomCategoryActive: Bool = false
    @State private var customCategory: String = ""
    @State private var subGoalTitle: String = ""
    private let titleLimit = 20
    private let categories = ["건강", "학업", "여행", "저축", "자기계발", "취미 생활", "가족", "새로운 도전"]
    private let customCategoryLimit = 6

    var body: some View {
        VStack(spacing: 20) {
            // 제목
            Text("작은 목표 추가하기")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top)

            // 카테고리 선택
            VStack(alignment: .leading, spacing: 10) {
                Text("카테고리")
                    .font(.system(size: 16, weight: .medium))
                categorySelectionGrid()
            }
            
            // "기타" 선택 시 입력란
            if isCustomCategoryActive {
                VStack(alignment: .leading, spacing: 5) {
                    TextField("진로, 관계, 감정 등", text: $customCategory)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: customCategory) { old, newValue in
                            if newValue.count > customCategoryLimit {
                                customCategory = String(newValue.prefix(customCategoryLimit))
                            }
                        }
                    Text("\(customCategory.count)/\(customCategoryLimit)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Text("루틴 이름")
                .font(.Pretendard.SemiBold.size16)
                .padding(.leading, 4)
                .foregroundStyle(Color.my675542)
            
            // 할 일 제목 입력란
            ZStack {
                TextField("진로, 관계, 감정 등", text: $customCategory)
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.myF0E8DF, lineWidth: 1)
                    )
                    .onChange(of: customCategory) { oldValue, newValue in
//                        if newValue != detailGoal?.title {
//                                isModified = true
//                            }
                        if newValue.count > titleLimit {
                            customCategory = String(newValue.prefix(titleLimit))
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
            // 작은 목표 이름
            VStack(alignment: .leading, spacing: 10) {
                Text("작은 목표 이름")
                    .font(.system(size: 16, weight: .medium))
                ZStack {
                    TextField("2kg 감량하기, 규칙적인 수면패턴 갖기 등.", text: $subGoalTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.trailing, 30)
                        .onChange(of: subGoalTitle) { old, newValue in
                            if newValue.count > titleLimit {
                                subGoalTitle = String(newValue.prefix(titleLimit))
                            }
                        }
                    HStack {
                        Spacer()
                        if !subGoalTitle.isEmpty {
                            Button(action: { subGoalTitle = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                }
                Text("\(subGoalTitle.count)/\(titleLimit)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
            
            // 삭제 버튼
            Button(action: {
                print("목표 삭제하기")
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("목표 삭제하기")
                }
                .foregroundColor(.red)
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
    }
}

extension SubGoalView {
    @ViewBuilder
    func categorySelectionGrid() -> some View {
        VStack(alignment: .leading, spacing: 9) {
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
    
    @ViewBuilder
    func categoryButton(category: String) -> some View {
        Button(action: {
            selectedCategory = category
            isCustomCategoryActive = false
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
}

#Preview {
    SubGoalView()
}
