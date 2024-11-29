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
    
    @State private var showCloverCardView: Bool = false  // 클로버 카드뷰 제어
    
    var body: some View {
        ZStack {
            if FirstOnboarding {
                OnboardingStartView()
            } else {
                TabView(selection: $selectedTab) {
                    RoutineMainView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tabItem {
                            (selectedTab == 0 ? Image("Tab_Routine_Selected") : Image("Tab_Routine_Default"))
                            Text("루틴")
                        }
                        .tag(0)
                    
                    MandalartView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tag(1)
                    
                    StatisticView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tabItem {
                            (selectedTab == 2 ? Image("Tab_Myclover_Selected") : Image("Tab_Myclover_Default"))
                            Text("나의 클로버")
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
                        (selectedTab == 1 ? Image("Tab_Myplan_Selected") : Image("Tab_Myplan_Default"))
                            .padding(.bottom, 34)
                            .onTapGesture {
                                selectedTab = 1 // 중앙 버튼 선택 시 나의계획 뷰로 이동
                            }
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .onAppear {
            let resetManager = WeeklyResetManager()
            if resetManager.resetGoals(goals: mainGoals, modelContext: modelContext) {
                showCloverCardView = true // 초기화가 발생한 경우에만 CloverCardView 로드
            }
        }
        .fullScreenCover(isPresented: $showCloverCardView) {
            CloverCardView()
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
