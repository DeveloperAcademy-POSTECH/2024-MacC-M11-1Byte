//
//  ReflectionStateView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct ReflectionStateView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    @State private var isSheetPresented = false
    
    var body: some View {
        VStack {
            Text("스티커 선택")
            
            Button {
                navigationManager.popToRoot() // 회고 메인 뷰로 이동
            } label: {
                Text("회고 메인 뷰로 이동")
            }
            
            HStack {
                Text("피드백")
                
                Button {
                    isSheetPresented = true
                    // Task별 선택해서 회고남길 수 있는 action
                } label: {
                    Image(systemName: "plus.circle")
                        .tint(.black)
                }
                .sheet(isPresented: $isSheetPresented) {
                    FeedbackSheetView()
                        .presentationDetents([.medium]) // 시트 높이 조절
                }
            }
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
