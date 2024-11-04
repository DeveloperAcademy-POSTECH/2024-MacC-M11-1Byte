//
//  TaskView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

struct RetrospectMainView: View {
    
    @State private var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Button {
                    navigationManager.push(to: .select)
                } label: {
                    Text("월 선택 후 화면이동")
                }
            }
            .navigationTitle(Date().YearString)
            .navigationDestination(for: PathType.self) { pathType in
                pathType.NavigatingView()
            }
        }
        .environment(navigationManager)
    }
}

#Preview {
    RetrospectMainView()
        .environment(NavigationManager())
}
