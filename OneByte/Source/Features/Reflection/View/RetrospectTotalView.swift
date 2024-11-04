//
//  RetrospectTotalView.swift
//  OneByte
//
//  Created by 이상도 on 11/4/24.
//

import SwiftUI

struct RetrospectTotalView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @Environment(\.dismiss) var dismiss
    
    let items = Array(1...12) // 뷰 테스트용 임시 변수
    
    let columns = [ // VGrid 3열
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.self) { item in
                        VStack {
                            // 나중에 Cell을 만들어서 회고 데이터 삽입
                            Text("\(item)월의 꽃")
                                .font(.headline)
                                .frame(maxWidth: .infinity, minHeight: 131)
                                .background(Color.blue.opacity(0.3))
                                .cornerRadius(8)
                                .padding(5)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("회고 모아보기")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
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
    RetrospectTotalView()
        .environment(NavigationManager())
}
