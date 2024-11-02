//
//  TaskView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

struct ReflectionView: View {
    
    @State private var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                
                Button {
                    navigationManager.push(to: .start)
                } label: {
                    Text("ReflectionStart뷰로 이동")
                }
            }
            .navigationTitle("2024년") // 나중에 현재 Year를 받아올 수 있게 수정
            .navigationDestination(for: PathType.self) { pathType in
                pathType.NavigatingView()
            }
        }
        .environment(navigationManager)
    }
}

#Preview {
    ReflectionView()
        .environment(NavigationManager())
}
