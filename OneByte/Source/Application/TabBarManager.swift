//
//  TabBarView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

struct TabBarManager: View {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                RoutineMainView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle.fill")
                        Text("루틴")
                    }
                    .tag(0)
                
                MandalartView()
                    .tabItem {
                        Image(systemName: "star.fill")
                            .hidden()
                    }
                    .tag(1)
                
                StatisticView()
                    .tabItem {
                        Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                        Text("통계")
                    }
                    .tag(2)
            }
            .accentColor(.my6FB56F)
            .onAppear {
                // 온보딩 완료 여부에 따라 기본 탭 설정
                if !hasSeenOnboarding {
                    selectedTab = 1
                    hasSeenOnboarding = true
                } else {
                    selectedTab = 0
                }
            }
            
            // 중앙탭 버튼
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .foregroundStyle(selectedTab == 1 ? .my6FB56F : .my999999)
                        .frame(width: 62, height: 62)
                    Image("TabbarMain")
                }
                .padding(.bottom, 36)
                .onTapGesture {
                    selectedTab = 1 // 중앙 버튼 선택 시 루틴 뷰로 이동
                }
                
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    TabBarManager()
}
