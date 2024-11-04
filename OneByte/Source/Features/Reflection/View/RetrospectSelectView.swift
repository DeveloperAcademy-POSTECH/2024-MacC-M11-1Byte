//
//  BeforeReflectionView.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

struct RetrospectSelectView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    @State  private  var tabBarVisible: Bool  =  false // Hide TabBar 변수
    
    var body: some View {
        VStack {
            HStack {
                Text("하위 목표를 선택해\n5월의 회고를 진행해보세요")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding()
            
            Spacer()
            
            VStack { // 원형 Subgoal List
                Circle()
                    .fill(.gray)
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text("저축")
                            .font(.headline)
                    )
                    .onTapGesture {
                        navigationManager.push(to: .retrospect)
                    }
                
                Circle()
                    .fill(.gray)
                    .frame(width: 100)
                
                Circle()
                    .fill(.gray)
                    .frame(width: 100)
            }
            Spacer()
            
            Button {
                print("Button Tapped : 회고끝내기")
                navigationManager.push(to: .complete)
            } label: {
                Text("회고 끝내기")
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }
            .background(.blue)
            .cornerRadius(8)
            .padding()
        }
        .toolbar(.hidden, for: .tabBar) // Hide Tabbar
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    self .tabBarVisible =  true
                    navigationManager.pop()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.black)
                    }
                }
            }
        }
        .toolbar(tabBarVisible ? .visible : .hidden, for: .tabBar)
    }
}

#Preview {
    RetrospectSelectView()
        .environment(NavigationManager())
}
