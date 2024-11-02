//
//  ReflectionCommentView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct ReflectionCommentView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack {
            Text("서브 골을 클릭해서 아이콘을 표시해봐요.")
            
            Button {
                navigationManager.push(to: .state)
            } label: {
                Text("다음 뷰로 이동")
            }
        }
        .navigationDestination(for: PathType.self) { pathType in
            pathType.NavigatingView()
        }
    }
}

#Preview {
    ReflectionCommentView()
        .environment(NavigationManager())
}
