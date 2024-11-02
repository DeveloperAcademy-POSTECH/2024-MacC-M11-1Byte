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
                    Text("다음 뷰로 이동")
                }
            }
        }
        .environment(navigationManager)
    }
}

#Preview {
    ReflectionView()
}
