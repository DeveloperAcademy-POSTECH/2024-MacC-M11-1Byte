//
//  EditNicknameSheetView.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI

struct EditNicknameSheetView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var viewModel: MyPageViewModel
    
    var body: some View {
        VStack {
            Text("닉네임 변경하기")
                .font(.Pretendard.SemiBold.size17)
            
            ZStack {
                TextField("닉네임을 입력해주세요.", text: $viewModel.newNickname)
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .onChange(of: viewModel.newNickname) { oldValue, newValue in
                        if newValue.count > viewModel.nicknameLimit {
                            viewModel.newNickname = String(newValue.prefix(viewModel.nicknameLimit))
                        }
                    }
                
                HStack {
                    Spacer()
                    Button {
                        viewModel.clearNewNickname() // 수정되고 있는 닉네임 지우기
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .foregroundStyle(Color.myB9B9B9)
                    }
                    .padding(.trailing)
                }
            }
            .padding(.top, 20/852 * UIScreen.main.bounds.height)
            
            // 글자수 부분
            HStack(spacing: 0) {
                Spacer()
                Text("\(viewModel.newNickname.count)")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color.my6C6C6C)
                Text("/10")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color.my6C6C6C.opacity(0.5))
            }
            .padding(.trailing, 5)
            
            Spacer()
            
            // 버튼 영역
            HStack {
                Button {
                    viewModel.isEditNicknameSheet = false
                } label: {
                    Text("취소")
                        .font(.Pretendard.Medium.size16)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.my787880.opacity(0.2))
                        .foregroundStyle(Color.my3C3C43.opacity(0.6))
                        .cornerRadius(12)
                }
                
                Button {
                    viewModel.isEditNicknameSheet = false
                    viewModel.updateNewNickname(modelContext: modelContext)
                    print("Button Tapped : 닉네임 변경 저장")
                } label: {
                    Text("저장")
                        .font(.Pretendard.Medium.size16)
                        .frame(maxWidth: .infinity)
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
    }
}

#Preview {
    EditNicknameSheetView(viewModel: MyPageViewModel())
}
