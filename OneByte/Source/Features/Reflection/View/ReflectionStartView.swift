//
//  BeforeReflectionView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct ReflectionStartView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack {
            Text("만다라트를 점검해보아요.")
            
            Button {
                navigationManager.push(to: .comment)
            } label: {
                Text("점검 시작하기")
            }
        }
        .navigationDestination(for: PathType.self) { pathType in
            pathType.NavigatingView()
        }
    }
}

#Preview {
    ReflectionStartView()
        .environment(NavigationManager())
}
