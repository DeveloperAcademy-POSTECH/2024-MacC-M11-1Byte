//
//  FeedbackSheetView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct FeedbackSheetView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var selectedTask = "" // 임시데이터
    var tasks = ["iOS Developer", "UiKit", "SwiftUI"] // 임시데이터
    
    @State private var text: String = "" // TextEditor 초기값
    
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .frame(width: 36, height: 5)
                    .cornerRadius(10)
                    .foregroundColor(Color(hex: "7F7F7F"))
                
                Text("피드백 작성")
                    .bold()
                    .padding(.top, 5)
                
                HStack {
                    Text("항목")
                        .padding()
                        .bold()
                    Text("\(selectedTask)") // 글자가 길면 몇글자까지만 보여줄건지
                    Spacer()
                    
                    Menu {
                        ForEach(tasks, id: \.self) { task in
                            Button(action: {
                                selectedTask = task
                            }) {
                                Text(task)
                            }
                        }
                    } label: {
                        HStack {
                            Text("전체")
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(.white)
                .cornerRadius(6)
                .padding(.horizontal)
                .padding(.top)
                
                HStack {
                    TextEditor(text: $text) // 나중에 Placeholder 추가하기
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10.0)
                        .frame(height: 200)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(6)
                .padding(.horizontal)
                .padding(.top)
                
                Button {
                    // 피드백 Sheet 완료 -> 저장시키는 action
                    dismiss()
                } label: {
                    Text("저장")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(.black)
                .cornerRadius(8)
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "EFEFEF"))
    }
}

#Preview {
    FeedbackSheetView()
}
