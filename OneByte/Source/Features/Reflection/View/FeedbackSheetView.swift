//
//  FeedbackSheetView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct FeedbackSheetView: View {
    
    var body: some View {
        VStack {
            Text("항목")
            
            Text("내용")
            
            TextField("피드백을 입력하세요", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button {
                    // 완료 action
                } label: {
                    Text("완료")
                }
            }
        }
        .padding()
    }
}

#Preview {
    FeedbackSheetView()
}
