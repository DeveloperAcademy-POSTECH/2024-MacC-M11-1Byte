//
//  TabBarView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

struct TabBarManager: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var mainGoals: [MainGoal]
    @AppStorage("FirstOnboarding") private var FirstOnboarding: Bool = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var isTabBarMainVisible: Bool = true
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            if FirstOnboarding {
                OnboardingStartView()
            } else {
                TabView(selection: $selectedTab) {
                    RoutineMainView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tabItem {
                            Image(systemName: "list.bullet.rectangle.fill")
                            Text("루틴")
                        }
                        .tag(0)
                    
                    MandalartView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tabItem {
                            Image(systemName: "star.fill")
                                .hidden()
                        }
                        .tag(1)
                    
                    StatisticView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tabItem {
                            Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                            Text("통계")
                        }
                        .tag(2)
                }
                .accentColor(.my6FB56F)
                .onChange(of: selectedTab) { oldValue, newValue in
                    triggerHaptic()
                }
                .onAppear {
                    // 온보딩 완료 여부에 따라 기본 탭 설정
                    if !hasSeenOnboarding {
                        selectedTab = 1
                        hasSeenOnboarding = true
                    } else {
                        selectedTab = 0
                    }
                }
                
                if isTabBarMainVisible { // 중앙탭 버튼
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
        .onAppear {
            let resetManager = WeeklyResetManager()
            resetManager.resetGoals(goals: mainGoals, modelContext: modelContext) // 초기화 수행
        }
    }
    
    // 햅틱
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}


#Preview {
    TabBarManager()
}
