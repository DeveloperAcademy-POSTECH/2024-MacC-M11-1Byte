//
//  EditNicknameSheetView.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI

struct EditNicknameSheetView: View {
    
    @Binding var isPresented: Bool
    
    @State var newNickname = ""
    private let nicknameLimit = 10
    
    var body: some View {
        VStack {
            Text("닉네임 변경하기")
                .font(.Pretendard.SemiBold.size17)
            
            ZStack {
                TextField("닉네임을 입력해주세요.", text: $newNickname)
                    .padding()
                    .background(.white)
                    .cornerRadius(8)
                    .onChange(of: newNickname) { oldValue, newValue in
                        if newValue.count > nicknameLimit {
                            newNickname = String(newValue.prefix(nicknameLimit))
                        }
                    }
                HStack {
                    Spacer()
                    Button(action: {
                        newNickname = "" // 나중에 뷰모델로 빼기
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 23, height: 23)
                            .foregroundStyle(Color.myB9B9B9)
                    })
                    .padding(.trailing)
                }
            }
            .padding(.top, 20/852 * UIScreen.main.bounds.height)
            
            // 글자수 부분
            HStack(spacing: 0) {
                Spacer()
                Text("\(newNickname.count)")
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
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .font(.Pretendard.Medium.size16)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.my787880.opacity(0.2))
                        .foregroundStyle(Color.my3C3C43.opacity(0.6))
                        .cornerRadius(12)
                }
                
                Button(action: {
                    isPresented = false
                }) {
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
    EditNicknameSheetView(isPresented: .constant(true))
}
