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
                Text("\"오늘 할 수 있는 작은 일부터 시작해 보세요.\n꾸준함이 곧 당신의 습관이 될 거예요!\"")
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                
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
