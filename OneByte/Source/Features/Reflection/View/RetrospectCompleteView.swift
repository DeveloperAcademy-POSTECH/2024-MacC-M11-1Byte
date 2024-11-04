//
//  ReflectionStateView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct RetrospectCompleteView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack {
            VStack {
                Text("6월의 회고가 완료되었습니다.")
                    .bold()
                    .font(.title2)
                
                Text("올해의 목표에 한발 더 가까워지셨어요.")
            }
            .padding(.top, 20)
            
            Spacer()
            
            Image(systemName: "camera.macro.circle.fill")
                .resizable()
                .frame(width: 233, height: 288)
            
            Spacer()
            
            Button {
                print("Button Tapped : 회고 완료하기")
                navigationManager.popToRoot()
            } label: {
                Text("완료하기")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }
            .background(.blue)
            .cornerRadius(8)
            .padding()
        }
    }
}

#Preview {
    RetrospectCompleteView()
        .environment(NavigationManager())
}
