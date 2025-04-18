//
//  EditNicknameSheetView.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI

struct EditNicknameSheetView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var viewModel: SettingViewModel
    
    var body: some View {
        VStack {
            Text("닉네임 변경하기")
                .font(.setPretendard(weight: .semiBold, size: 17))
            
            ZStack {
                TextField("닉네임을 입력해주세요.", text: $viewModel.newNickname)
                    .submitLabel(.done)
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
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
                    .opacity(viewModel.newNickname.isEmpty ? 0 : 1)
                    .padding(.trailing)
                }
            }
            .padding(.top, 20/852 * UIScreen.main.bounds.height)
            
            // 글자수 부분
            HStack(spacing: 0) {
                Spacer()
                Text("\(viewModel.newNickname.count)")
                    .font(.setPretendard(weight: .medium, size: 12))
                    .foregroundStyle(Color.my6C6C6C)
                Text("/10")
                    .font(.setPretendard(weight: .medium, size: 12))
                    .foregroundStyle(Color.my6C6C6C.opacity(0.5))
            }
            .padding(.trailing, 10)
            .padding(.top, 5)
            
            Spacer()
            
            // 버튼 영역
            HStack {
                Button {
                    viewModel.isEditNicknameSheet = false
                } label: {
                    Text("취소")
                        .font(.setPretendard(weight: .medium, size: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.my787880.opacity(0.2))
                        .foregroundStyle(Color.my3C3C43.opacity(0.6))
                        .cornerRadius(12)
                }
                
                Button {
                    viewModel.isEditNicknameSheet = false
                    UserDefaults.saveNickname(viewModel.newNickname)
                    //                    viewModel.updateNewNickname(modelContext: modelContext)
                    print("Button Tapped : 닉네임 변경 저장")
                } label: {
                    Text("저장")
                        .font(.setPretendard(weight: .medium, size: 16))
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
        .onAppear {
            // 닉네임 로드 (필요 시)
            viewModel.newNickname = UserDefaults.loadNickname()
        }
    }
}

#Preview {
    EditNicknameSheetView(viewModel: SettingViewModel())
}
