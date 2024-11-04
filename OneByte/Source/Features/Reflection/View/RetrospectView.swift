//
//  ReflectionCommentView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct RetrospectView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    @State private var isSheetPresented = false // 피드백 Sheet Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("취미에 대한 회고와\n진행도를 체크해보세요")
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "exclamationmark.circle")
                    .resizable()
                    .frame(width: 29, height: 29)
                    .foregroundStyle(.gray)
            }
            .padding()
            
            VStack {
                HStack {
                    Text("3x3 Subgoal 공간")
                }
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .background(.gray)
            }
            .padding()
            
            HStack {
                Text("피드백")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button {
                    // 피드백 추가 action
                    isSheetPresented = true
                } label: {
                    Text("추가하기")
                        .foregroundStyle(.black)
                }
                .cornerRadius(30)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 2)
                )
                .sheet(isPresented: $isSheetPresented) {
                    // 나중에 Custom Sheet로 바꿔야 할 수도 있음
                    FeedbackSheetView()
                        .presentationDetents([.height(UIScreen.main.bounds.height * 1 / 2)])
                }
            }
            .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Text("피드백이 쌓이는 공간")
                    Text("피드백이 쌓이는 공간")
                    Text("피드백이 쌓이는 공간")
                }
                .frame(maxHeight: .infinity)
                .padding()
            }
            
            Button {
                // 현재 Subgoal 회고 저장 action
                navigationManager.pop()
            } label: {
                Text("저장하기")
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(.blue)
            .cornerRadius(8)
            .padding()
        }
        .navigationTitle("취미")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationManager.pop()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.black)
                    }
                }
            }
        }
        .navigationDestination(for: PathType.self) { pathType in
            pathType.NavigatingView()
        }
    }
}

#Preview {
    RetrospectView()
        .environment(NavigationManager())
}
