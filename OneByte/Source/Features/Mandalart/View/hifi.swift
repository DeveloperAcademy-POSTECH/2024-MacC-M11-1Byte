//
//  hifi.swift
//  OneByte
//
//  Created by 트루디 on 12/3/24.
//

import SwiftUI

struct hifi: View {
    var body: some View {
        ZStack{
            Color.gray.opacity(0.2) // 배경 색상
            
            VStack(spacing: 16) {
                VStack {
                    Spacer()
                    HStack(spacing: 0) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.my6FB56F)
                            .background{
                                Circle()
                                    .foregroundStyle(.white)
                                    .frame(width: 15, height: 15)
                            }
                            .padding(.leading, 20)
                        Text("완료되었습니다!")
                            .font(.Pretendard.Bold.size16)
                            .foregroundStyle(.white)
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .blur(radius: 0.1)
                    .background(Color.my271500.opacity(0.55))
                    .cornerRadius(8)
                }
                .background(.regularMaterial)
                .transition(.opacity)
                .padding(.bottom, 40) // 화면 하단에서 여백
                // 메인 카드
                Image("hifi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 251/393 * UIScreen.main.bounds.width)
                // 공유 및 저장 버튼
                VStack(spacing: 12) {
                    Button(action: {
                        print("공유하기 버튼 눌림")
                    }) {
                        Text("공유하기")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {
                        print("이미지 저장 버튼 눌림")
                    }) {
                        Text("이미지 저장")
                            .font(.system(size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(width: 317/393 * UIScreen.main.bounds.width, height: 460)
            .background(.myF4F2F2)
            .cornerRadius(12)
        }
    }
}

#Preview {
    hifi()
}
