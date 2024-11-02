//
//  ReflectionStateView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct ReflectionStateView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack {
            Text("스티커 선택")
            
            Button {
                navigationManager.popToRoot() // 회고 메인 뷰로 이동
            } label: {
                Text("회고 메인 뷰로 이동")
            }
            
            Text("메모")
        }
        .navigationDestination(for: PathType.self) { pathType in
            pathType.NavigatingView()
        }
    }
}

#Preview {
    ReflectionStateView()
        .environment(NavigationManager())
}
